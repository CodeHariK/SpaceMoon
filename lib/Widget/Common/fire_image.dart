// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:collection/collection.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';

import 'package:moonspace/Helper/debug_functions.dart';
import 'package:moonspace/darkknight/extensions/string.dart';

Future<List<ImageMetadata?>> saveFireMedia(
  String location,
) async {
  try {
    final mediaFiles = await ImagePicker().pickMultipleMedia();
    final mediasRead = mediaFiles.map((e) async {
      final imageBytes = await e.readAsBytes();
      final upImg = img.decodeImage(imageBytes);

      final tmpPath = await getTemporaryDirectory();
      final savepath = '${tmpPath.path}/${randomString(12)}${path.extension(e.path)}';
      await e.saveTo(savepath);

      if (upImg == null) return null;

      final newImg = img.copyResize(
        upImg,
        width: 200,
        maintainAspect: true,
      );

      final blurHash = BlurHash.encode(newImg, numCompX: 4, numCompY: 3);

      return ImageMetadata(
        localUrl: savepath,
        blurhash: blurHash.hash,
        width: upImg.width,
        height: upImg.height,
      );
    });
    final medias = await Future.wait(mediasRead);
    return medias;

    // return medias
    //     .mapIndexed(
    //       (i, bytes) => FirebaseStorage.instance
    //           .ref()
    //           .child(location)
    //           .child(
    //             mediaFiles[i].name,
    //           )
    //           .putData(bytes),
    //     )
    //     .toList();
  } catch (e) {
    lava(e);
  }
  return [];
}

// List<UploadStatus?> uploaderFireList = [];
// StreamController<List<UploadStatus?>> uploaderFireStream = StreamController.broadcast();
// ..stream.listen((data) {
//   uploaderFireList = data;
// });

Future<String?> uploadFire({
  required ImageMetadata meta,
  required String imageName,
  required String user,
  required String location,
  String? multipath,
  String? singlepath,
}) async {
  final name = '$imageName${path.extension(meta.localUrl)}';
  final imageBytes = await File(meta.localUrl).readAsBytes();
  final uploadTask = FirebaseStorage.instance.ref().child('$user/$location').child(name).putData(
        imageBytes,
        SettableMetadata(
          contentType: lookupMimeType(meta.localUrl),
          customMetadata: ({
            // 'name': name,
            // 'user': user,
            // 'path': location,
            'localUrl': meta.localUrl,
            // 'width': meta.width.toString(),
            // 'height': meta.height.toString(),
            if (multipath != null) 'multi': multipath,
            if (singlepath != null) 'single': singlepath,
            // 'path': image.path,
          }),
        ),
      );
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

  late final String? downloadurl;
  await uploadTask.then((p0) async => downloadurl = await p0.ref.getDownloadURL());

  return downloadurl;
}

// class SaveFire {
//   // final ImageMeta meta;
//   final UploadTask task;

//   SaveFire({
//     // required this.meta,
//     required this.task,
//   });
// }

// Future<SaveFire?> saveFirePickCropImage(
//   String location, {
//   bool crop = false,
//   bool camera = false,
//   String? multipath,
//   String? singlepath,
// }) async {
//   debugPrint('save Fire Pick');

//   final status = await Permission.photos.status;

//   if (status == PermissionStatus.denied) {
//     Permission.photos.request();
//   } else if (status == PermissionStatus.permanentlyDenied) {
//     openAppSettings();
//   }

//   final image = await ImagePicker().pickImage(
//     source: camera ? ImageSource.camera : ImageSource.gallery,
//   );

//   log('save Fire Pick');

//   if (image == null) return null;

//   Uint8List? imageBytes;

//   if (crop == false) {
//     imageBytes = await image.readAsBytes();
//   }

//   if (crop == true) {
//     CroppedFile? croppedFile = await ImageCropper().cropImage(
//       sourcePath: image.path,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9
//       ],
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.deepOrange,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         IOSUiSettings(
//           title: 'Cropper',
//         ),
//       ],
//     );
//     imageBytes = await croppedFile?.readAsBytes();
//   }

//   log('Save Fire Image : ${imageBytes?.length}');

//   if (imageBytes == null) return null;
//   final upImg = img.decodeImage(imageBytes);
//   if (upImg == null) return null;

//   final blurHash = BlurHash.encode(upImg, numCompX: 4, numCompY: 3);

//   print(base64Encode(utf8.encode(blurHash.hash)));

//   // final imageMeta = ImageMeta(
//   //   path: location,
//   //   localUrl: image.path,
//   //   // blurhash: base64Encode(utf8.encode(blurHash.hash)),
//   //   width: upImg.width,
//   //   height: upImg.height,
//   // );
//   return SaveFire(
//     // meta: imageMeta,
//     task: FirebaseStorage.instance
//         .ref()
//         .child(location)
//         .child('${randomString(12)}${path.extension(image.path)}')
//         .putData(
//           imageBytes,
//           SettableMetadata(
//             contentType: lookupMimeType(image.path),
//             // customMetadata: (imageMeta.toMap()?.map((key, value) => MapEntry(key, value.toString())))
//             //   ?..addAll({

//             customMetadata: ({
//               'path': location,
//               'localUrl': image.path,
//               // blurhash: base64Encode(utf8.encode(blurHash.hash)),
//               'width': upImg.width.toString(),
//               'height': upImg.height.toString(),
//               if (multipath != null) 'multi': multipath,
//               if (singlepath != null) 'single': singlepath,
//               // 'path': image.path,
//             }),
//           ),
//         ),
//   );
// }

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
