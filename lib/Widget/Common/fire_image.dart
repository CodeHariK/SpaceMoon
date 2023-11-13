import 'dart:developer';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moonspace/Helper/debug_functions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:moonspace/Helper/extensions.dart';

Future<List<UploadTask>?> saveFireMedia(
  String location,
) async {
  try {
    final mediaFiles = await ImagePicker().pickMultipleMedia();
    final mediasRead = mediaFiles.map((e) => e.readAsBytes());
    final medias = await Future.wait(mediasRead);

    return medias
        .mapIndexed(
          (i, bytes) => FirebaseStorage.instance
              .ref()
              .child(location)
              .child(
                mediaFiles[i].name,
              )
              .putData(bytes),
        )
        .toList();
  } catch (e) {
    lava(e);
  }
  return null;
}

Future<UploadTask?> saveFirePickCropImage(
  String location, {
  bool crop = false,
  bool camera = false,
}) async {
  print('save Fire Pick');

  final status = await Permission.photos.status;

  if (status == PermissionStatus.denied) {
    Permission.photos.request();
  } else if (status == PermissionStatus.permanentlyDenied) {
    openAppSettings();
  }

  final image = await ImagePicker().pickImage(
    source: camera ? ImageSource.camera : ImageSource.gallery,
  );

  log('save Fire Pick');

  if (image == null) return null;

  Uint8List? imageBytes;

  if (crop == false) {
    imageBytes = await image.readAsBytes();
  }

  if (crop == true) {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    imageBytes = await croppedFile?.readAsBytes();
  }

  log('Save Fire Image : ${imageBytes?.length}');

  if (imageBytes == null) return null;

  return FirebaseStorage.instance.ref().child(location).child(image.name).putData(
        imageBytes,
        SettableMetadata(
          customMetadata: {
            'owner': 'owner',
          },
        ),
      );
  // .then(
  //   (snapshot) async {
  //     return await snapshot.ref.getDownloadURL();
  //   },
  // );
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
}

extension SuperUploadTask on UploadTask {
  Stream<UploadStatus> get stream {
    return snapshotEvents.asyncMap(
      (event) async {
        return event.state == TaskState.success
            ? UploadStatus(
                url: await event.ref.getDownloadURL(),
                transferred: 1.0,
                running: event.state == TaskState.running || event.state == TaskState.paused,
              )
            : UploadStatus(
                url: null,
                transferred: (event.bytesTransferred / event.totalBytes),
                running: event.state == TaskState.running || event.state == TaskState.paused,
              );
      },
    );
  }
}

class AuthImage extends StatelessWidget {
  const AuthImage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () async {
            final uploadTask = await saveFirePickCropImage(
              '${FirebaseAuth.instance.currentUser?.uid}/avatars',
            );
            final hello = await uploadTask?.then((p0) => p0.ref.getDownloadURL());

            if (hello != null) {
              FirebaseAuth.instance.currentUser?.updatePhotoURL(hello);
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                FirebaseAuth.instance.currentUser?.photoURL ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.face_2_outlined, size: 120);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class FireImage extends StatefulWidget {
  const FireImage({super.key, required this.location, required this.imageUrl, required this.function});

  final String location;
  final String imageUrl;
  final Function(String url) function;

  @override
  State<FireImage> createState() => _FireImageState();
}

class _FireImageState extends State<FireImage> {
  late final String imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = widget.imageUrl;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        log('Hello');
        final hello = await saveFirePickCropImage(widget.location);
        final url = await hello?.then((p0) => p0.ref.getDownloadURL());

        if (url != null) {
          setState(() {
            imageUrl = url;
            widget.function(url);
          });
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: 16.br,
            border: Border.all(width: 1),
          ),
          margin: const EdgeInsets.all(16.0),
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.face_2_outlined, size: 120);
              },
            ),
          ),
        ),
      ),
    );
  }
}
