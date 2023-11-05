import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Widget/Chat/send_box.dart';

//TODO : Click on Photo to open photoview dialog
//TODO : Display photoview with textformfield

class PhotoDialog extends StatelessWidget {
  const PhotoDialog({
    super.key,
    required this.imageUrl,
    required this.ref,
    required this.roomUser,
    // required this.scrollCon,
  });

  final String imageUrl;
  final WidgetRef ref;
  final RoomUser roomUser;
  // final ScrollController scrollCon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ClipRRect(
        borderRadius: 25.br,
        child: Scaffold(
          // appBar: AppBar(
          //   title: Text('Send Image'),
          // ),
          body: Stack(
            children: [
              ClipRRect(
                child: Container(
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
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                    stops: [0.7, 1],
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
