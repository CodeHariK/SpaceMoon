import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:spacemoon/Gen/data.pb.dart';

Future<(ImageMetadata, XFile)?> selectImageMedia() async {
  try {
    final mediaFiles = await ImagePicker().pickImage(source: ImageSource.gallery);

    if ((await mediaFiles?.length() ?? 100000000000) > 10000000) return null;
    if (mediaFiles == null) return null;

    final mime = mediaFiles.mimeType ?? lookupMimeType(mediaFiles.path);

    return (
      ImageMetadata(localUrl: mediaFiles.path, type: mime
          // blurhash: blurHash.hash,
          // width: upImg.width,
          // height: upImg.height,
          ),
      mediaFiles
    );
  } catch (e) {
    return null;
  }
}

Future<List<(ImageMetadata, XFile)>> selectMultiMedia() async {
  try {
    final mediaFiles = await ImagePicker().pickMultipleMedia();
    final mediasRead = mediaFiles.where((element) {
      final mime = element.mimeType ?? lookupMimeType(element.path);
      return isImageVideo(mime ?? '');
    }).map((e) async {
      final savepath = e.path;

      final mime = e.mimeType ?? lookupMimeType(e.path);

      if ((await e.length()) > 30000000) {
        return null;
      }

      // final imageBytes = await e.readAsBytes();
      // final upImg = img.decodeImage(imageBytes);

      // final tmpPath = await getTemporaryDirectory();
      // final savepath = '${tmpPath.path}/${randomString(12)}${path.extension(e.path)}';
      // await e.saveTo(savepath);

      // if (upImg == null) return null;

      // final newImg = img.copyResize(
      //   upImg,
      //   width: 200,
      //   maintainAspect: true,
      // );

      // final blurHash = BlurHash.encode(newImg, numCompX: 3, numCompY: 2);

      return (
        ImageMetadata(
          localUrl: savepath,
          type: mime,
          // blurhash: blurHash.hash,
          // width: upImg.width,
          // height: upImg.height,
        ),
        e
      );
    });
    final medias = await Future.wait(mediasRead);
    return List.from(medias.where((element) => element != null));
  } catch (e) {
    debugPrint(e.toString());
  }
  return [];
}

// List<UploadStatus?> uploaderFireList = [];
// StreamController<List<UploadStatus?>> uploaderFireStream = StreamController.broadcast();
// ..stream.listen((data) {
//   uploaderFireList = data;
// });

bool isImageVideo(String mime) => mime.contains('image') == true || mime.contains('video') == true;

Future<void> uploadFire({
  required ImageMetadata meta,
  required XFile? file,
  required String imageName,
  required String docPath,
  required String storagePath,
  String? multipath,
  String? singlepath,
}) async {
  final mime = file?.mimeType ?? lookupMimeType(meta.localUrl);
  final name =
      '$imageName${path.extension(meta.localUrl).isNotEmpty ? path.extension(meta.localUrl) : ((mime?.split('/').length ?? 0) > 1) ? mime?.split('/')[1] : ''}';

  final metadata = SettableMetadata(
      contentType: mime,
      customMetadata: ({
        // 'name': name,
        // 'user': user,
        'path': docPath,
        'localUrl': meta.localUrl,
        // 'width': meta.width.toString(),
        // 'height': meta.height.toString(),
        if (multipath != null) 'multi': multipath,
        if (singlepath != null) 'single': singlepath,
        // 'path': image.path,
      }));

  if (isImageVideo(metadata.contentType ?? '')) {
    final ref = FirebaseStorage.instance.ref().child(storagePath).child(name);

    if (file != null) {
      await ref.putData(await file.readAsBytes(), metadata);
    } else {
      if (!kIsWeb) {
        await ref.putFile(File(meta.localUrl), metadata);
      }
    }
  }

  // late final UploadTask uploadTask;

  // if (kIsWeb) {
  // uploadTask =
  // } else {
  //   uploadTask = ref.putFile(file, metadata);
  // }

  // uploadTask.stream(meta.localUrl).listen((status) async {
  //   final index = uploaderFireList.indexWhere((element) => element?.url == meta.localUrl);
  //   if (index >= 0) {
  //     uploaderFireList[index] = status;
  //   } else {
  //     uploaderFireList.add(status);
  //   }
  //   uploaderFireList.removeWhere((element) => element?.running == false);
  //   uploaderFireStream.sink.add(uploaderFireList);
  // });

  // late final String? downloadurl;
  // await uploadTask.then((p0) async {
  //   return downloadurl = await p0.ref.getDownloadURL();
  // }).onError((error, stackTrace) {
  //   debugPrint(error.toString());
  //   return error.toString();
  // });

  // return downloadurl;
}

class UploadStatus {
  final double transferred;
  final String? url;
  final bool running;

  UploadStatus({
    required this.transferred,
    this.url,
    required this.running,
  });

  @override
  String toString() => 'UploadStatus(transferred: $transferred, url: ${url.hashCode}, running: $running)';
}

extension SuperUploadTask on UploadTask {
  Stream<UploadStatus> stream(String localUrl) {
    return snapshotEvents.map(
      (event) {
        return UploadStatus(
          url: localUrl,
          transferred: (event.bytesTransferred / event.totalBytes),
          running: event.state == TaskState.running,
        );
      },
    );
  }
}
