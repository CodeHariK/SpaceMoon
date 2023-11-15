import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moonspace/Form/async_text_field.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Routes/Home/account.dart';

class GalleryImage extends StatelessWidget {
  const GalleryImage({
    super.key,
    required this.tweet,
    required this.index,
  });

  final Tweet tweet;
  final int index;

  @override
  Widget build(BuildContext context) {
    var imageMetadata = tweet.imageMetadata[index];
    return Expanded(
      child: CustomCacheImage(
        imageUrl: thumbImage(imageMetadata.url),
        blurHash: imageMetadata.blurhash,
      ),
    );
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageMetadata.localUrl.isNotEmpty
                ? Image.file(File(imageMetadata.localUrl)).image
                : Image.network(thumbImage(imageMetadata.url)).image,
            fit: BoxFit.cover,
          ),
        ),
        child: index != 3 || tweet.imageMetadata.length <= 4
            ? null
            : Container(
                color: const Color.fromARGB(55, 0, 0, 0),
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 36,
                  height: 36,
                  margin: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color.fromARGB(185, 255, 255, 255),
                  ),
                  child: Text(
                    '+${tweet.imageMetadata.length - 4}',
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
      ),
    );
  }
}

extension SuperImageMetadata on Tweet {
  List<ImageMetadata> get avaiable => imageMetadata.where((element) => element.url.isNotEmpty).toList();
  int get uploaded => avaiable.length;
  int get total => imageMetadata.length;
}

class GalleryBox extends StatelessWidget {
  const GalleryBox({
    super.key,
    required this.tweet,
  });

  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    final uploaded = tweet.imageMetadata.where((element) => element.url.isNotEmpty).length;
    final total = tweet.imageMetadata.length;

    final child = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 300,
          width: 300,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    GalleryImage(tweet: tweet, index: 0),
                    if (tweet.imageMetadata.length > 1) GalleryImage(tweet: tweet, index: 1),
                  ],
                ),
              ),
              if (tweet.imageMetadata.length > 2)
                Expanded(
                  child: Row(
                    children: [
                      if (tweet.imageMetadata.length > 2) GalleryImage(tweet: tweet, index: 2),
                      if (tweet.imageMetadata.length > 3) GalleryImage(tweet: tweet, index: 3),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (uploaded != total)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(8),
            child: CircularProgressIndicator(
              strokeWidth: 6,
              value: uploaded / total,
            ),
          ),
        if (uploaded != total)
          Text(
            '$uploaded / $total',
            style: const TextStyle(fontSize: 20, color: Colors.black),
          ),
      ],
    );

    return InkWell(
      onTap: () {
        context.cPush(
          GalleryScaffold(tweet: tweet),
        );
      },
      child: child,
    );
  }
}

class GalleryScaffold extends StatelessWidget {
  const GalleryScaffold({super.key, required this.tweet});

  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: tweet.imageMetadata.length,
        itemBuilder: (context, index) {
          var imageMetadata = tweet.imageMetadata[index];
          return Container(
            height: 320,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: imageMetadata.localUrl.isNotEmpty
                    ? Image.file(File(imageMetadata.localUrl)).image
                    : Image.network((imageMetadata.url)).image,
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.bottomRight,
            child: imageMetadata.localUrl.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black,
                      boxShadow: const [
                        BoxShadow(color: Color.fromARGB(160, 255, 255, 255), blurRadius: 2, spreadRadius: 4),
                      ],
                    ),
                    child: IconButton(
                      iconSize: 32,
                      color: Colors.white,
                      padding: const EdgeInsets.all(12),
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.cloud_upload_fill),
                    ),
                  )
                : AsyncTextFormField(
                    asyncFn: (value) async {
                      return true;
                    },
                    style: const TextStyle(fontSize: 20),
                    showPrefix: false,
                    milliseconds: 5000,
                    decoration: const InputDecoration(
                      fillColor: Colors.black38,
                      filled: true,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: 'Add Caption...',
                    ),
                  ),
          );
        },
      ),
    );
  }
}
