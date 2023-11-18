import 'package:flutter/material.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Widget/Chat/send_box.dart';

class PhotoDialog extends StatelessWidget {
  const PhotoDialog({
    super.key,
    required this.imageUrl,
    required this.roomUser,
  });

  final String imageUrl;
  final RoomUser roomUser;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: 0.bRound.r(25),
      child: ClipRRect(
        borderRadius: 25.br,
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text('Send Image'),
          // ),
          body: Stack(
            children: [
              Container(
                constraints: BoxConstraints.expand(
                  height: MediaQuery.of(context).size.height,
                ),
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  // tightMode: true,
                  // maxScale: PhotoViewComputedScale.covered * 2.0,
                  // minScale: PhotoViewComputedScale.contained * 0.8,
                  initialScale: PhotoViewComputedScale.covered,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color.fromARGB(120, 255, 255, 255),
                      Color.fromARGB(255, 255, 255, 255),
                    ],
                    stops: [0.7, 0.8, 1],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SendBox(
                    roomUser: roomUser,
                    link: imageUrl,
                    mediaType: MediaType.IMAGE,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
