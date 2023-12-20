import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:spacemoon/Gen/data.pb.dart';

Future<ImageMetadata?> selectImageMedia() async {
  try {
    final mediaFiles = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (mediaFiles == null) return null;

    return ImageMetadata(
      localUrl: mediaFiles.path,
      // blurhash: blurHash.hash,
      // width: upImg.width,
      // height: upImg.height,
    );
  } catch (e) {
    return null;
  }
}

Future<List<ImageMetadata?>> selectMultiMedia() async {
  try {
    final mediaFiles = await ImagePicker().pickMultipleMedia();
    final mediasRead = mediaFiles.map((e) async {
      final savepath = e.path;

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

      return ImageMetadata(
        localUrl: savepath,
        // blurhash: blurHash.hash,
        // width: upImg.width,
        // height: upImg.height,
      );
    });
    final medias = await Future.wait(mediasRead);
    return medias;
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

Future<void> uploadFire({
  required ImageMetadata meta,
  required String imageName,
  required String docPath,
  required String storagePath,
  String? multipath,
  String? singlepath,
}) async {
  final name = '$imageName${path.extension(meta.localUrl)}';

  final metadata = SettableMetadata(
      contentType: lookupMimeType(meta.localUrl),
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

  final ref = FirebaseStorage.instance.ref().child(storagePath).child(name);

  final file = File(meta.localUrl);

  // late final UploadTask uploadTask;

  // if (kIsWeb) {
  // uploadTask =
  ref.putData(await file.readAsBytes(), metadata);
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
