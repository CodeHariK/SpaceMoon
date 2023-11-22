import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/Form/async_text_field.dart';
import 'package:moonspace/Form/mario.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Init/firebase.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Widget/Common/fire_image.dart';
import 'package:photo_view/photo_view.dart';

class GalleryImage extends StatelessWidget {
  const GalleryImage({
    super.key,
    required this.tweet,
    required this.index,
    this.inScaffold = false,
  });

  final Tweet tweet;
  final int index;
  final bool inScaffold;

  @override
  Widget build(BuildContext context) {
    var imageMetadata = tweet.gallery[index];

    return GestureDetector(
      onTap: !inScaffold
          ? null
          : () {
              context.bSlidePush(
                Scaffold(
                  appBar: AppBar(
                      // title: Text('Send Image'),
                      ),
                  body: Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints.expand(
                          height: MediaQuery.of(context).size.height,
                        ),
                        child: PhotoView(
                          imageProvider: NetworkImage(imageMetadata.url),
                          // tightMode: true,
                          // maxScale: PhotoViewComputedScale.covered * 2.0,
                          // minScale: PhotoViewComputedScale.contained * 0.8,
                          initialScale: PhotoViewComputedScale.contained,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
      child: Container(
        height: 320,
        margin: const EdgeInsets.all(4),
        decoration: imageMetadata.localUrl.isEmpty
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              if (imageMetadata.url.isNotEmpty)
                CustomCacheImage(
                  imageUrl: inScaffold ? imageMetadata.url : thumbImage(imageMetadata.url),
                  // blurHash: imageMetadata.blurhash,
                ),
              if (imageMetadata.localUrl.isNotEmpty)
                FutureBuilder(
                  future: File(imageMetadata.localUrl).readAsBytes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const SizedBox();
                      // return BlurHash(hash: imageMetadata.blurhash);
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: Image.memory(snapshot.data!).image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                  },
                ),
              if (inScaffold && imageMetadata.localUrl.isNotEmpty)
                FutureBuilder(
                  future: File(imageMetadata.localUrl).exists(),
                  builder: (context, snapshot) {
                    if (snapshot.data == true) {
                      return Container(
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
                          onPressed: () async {
                            await uploadFire(
                              imageName: randomString(12),
                              user: tweet.user,
                              meta: imageMetadata,
                              location: tweet.path,
                              multipath: Const.gallery.name,
                            );
                          },
                          icon: const Icon(CupertinoIcons.cloud_upload_fill),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              if (inScaffold && imageMetadata.url.isNotEmpty)
                Consumer(
                  builder: (_, ref, ___) => AsyncTextFormField(
                    initialValue: imageMetadata.caption,
                    asyncValidator: (value) async {
                      final uIndex = tweet.gallery.indexWhere((element) => element == imageMetadata);
                      tweet.gallery[uIndex].caption = value;

                      ref.read(tweetsProvider.notifier).updateTweet(tweet: tweet);

                      return null;
                    },
                    style: context.hm.c(Colors.white),
                    showPrefix: false,
                    milliseconds: 1000,
                    decoration: const InputDecoration(
                      fillColor: Colors.black38,
                      hintStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      focusedBorder: InputBorder.none,
                      border: InputBorder.none,
                      hintText: 'Add Caption...',
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

extension SuperImageMetadata on Tweet {
  List<ImageMetadata> get avaiable => gallery.where((element) => element.url.isNotEmpty).toList();
  List<ImageMetadata> get notAvaiable => gallery.where((element) => element.localUrl.isNotEmpty).toList();
  int get uploaded => avaiable.length;
  int get total => gallery.length;
}

class GalleryBox extends StatelessWidget {
  const GalleryBox({
    super.key,
    required this.tweet,
  });

  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    final uploaded = tweet.gallery.where((element) => element.url.isNotEmpty).length;
    final total = tweet.gallery.length;

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
                    Expanded(child: GalleryImage(tweet: tweet, index: 0)),
                    if (tweet.gallery.length > 1) Expanded(child: GalleryImage(tweet: tweet, index: 1)),
                  ],
                ),
              ),
              if (tweet.gallery.length > 2)
                Expanded(
                  child: Row(
                    children: [
                      if (tweet.gallery.length > 2) Expanded(child: GalleryImage(tweet: tweet, index: 2)),
                      if (tweet.gallery.length > 3) Expanded(child: GalleryImage(tweet: tweet, index: 3)),
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

class GalleryScaffold extends StatefulWidget {
  const GalleryScaffold({super.key, required this.tweet});

  final Tweet tweet;

  @override
  State<GalleryScaffold> createState() => _GalleryScaffoldState();
}

class _GalleryScaffoldState extends State<GalleryScaffold> {
  List<ImageMetadata> selected = [];
  bool startSelection = false;

  Tweet get tweet => widget.tweet;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: tweet.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.data?.data() == null) {
          Future.delayed(const Duration(milliseconds: 50), () {
            context.nav.pop();
          });
        }

        tweet.gallery.removeWhere((element) => true);
        tweet.gallery.addAll(snapshot.data?.data()?.gallery ?? []);

        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.white,
            actions: [
              if (startSelection)
                Consumer(
                  builder: (context, ref, child) {
                    return InkWell(
                      onTap: () {
                        tweet.gallery.removeWhere((element) => selected.contains(element));

                        ref.read(tweetsProvider.notifier).updateTweet(tweet: tweet);

                        setState(() => startSelection = false);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Delete All'),
                      ),
                    );
                  },
                )
            ],
          ),
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                onPressed: null,
                child: Consumer(
                  builder: (context, ref, child) => GalleryUploaderButton(
                    tonal: false,
                    ref: ref,
                    tweet: tweet,
                  ),
                ),
              ),
              if (tweet.uploaded != tweet.total) ...[
                const SizedBox(width: 10),
                FloatingActionButton(
                  child: const Icon(CupertinoIcons.refresh_circled_solid, size: 40),
                  onPressed: () async {
                    for (var img in tweet.notAvaiable) {
                      await uploadFire(
                        imageName: randomString(12),
                        user: tweet.user,
                        meta: img,
                        location: tweet.path,
                        multipath: Const.gallery.name,
                      );
                    }
                  },
                ),
              ]
            ],
          ),
          body: ListView.builder(
            cacheExtent: 2000,
            itemCount: tweet.gallery.length,
            itemBuilder: (context, index) {
              void selector() {
                if (selected.contains(tweet.gallery[index])) {
                  selected.remove(tweet.gallery[index]);
                } else {
                  selected.add(tweet.gallery[index]);
                }
                setState(() {});
              }

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPress: () {
                  setState(() => startSelection = true);

                  selector();
                },
                onTap: !startSelection ? null : selector,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IgnorePointer(
                      ignoring: startSelection,
                      child: GalleryImage(
                        key: ObjectKey(tweet.gallery[index].hashCode + index),
                        tweet: tweet,
                        index: index,
                        inScaffold: true,
                      ),
                    ),
                    if (startSelection)
                      Checkbox(
                        value: selected.contains(tweet.gallery[index]),
                        onChanged: (v) {
                          selector();
                        },
                      ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class GalleryUploaderButton extends StatelessWidget {
  const GalleryUploaderButton({
    super.key,
    this.tonal = true,
    required this.ref,
    this.tweet,
  });

  final bool tonal;
  final WidgetRef ref;
  final Tweet? tweet;

  @override
  Widget build(BuildContext context) {
    final meInRoom = ref.watch(currentRoomUserProvider).value;
    void func() async {
      ContextMenu.hide();
      final imgs = (await selectMultiMedia()).where((element) => element != null);
      if (imgs.isEmpty) return;
      final path = tweet?.path ??
          await ref.read(tweetsProvider.notifier).sendTweet(
                tweet: Tweet(
                  mediaType: MediaType.GALLERY,
                  gallery: List<ImageMetadata>.from(imgs),
                ),
              );

      if (tweet != null) {
        tweet?.gallery.addAll(List.from(imgs));

        ref.read(tweetsProvider.notifier).updateTweet(tweet: tweet!);
      }

      for (var img in imgs) {
        await uploadFire(
          imageName: randomString(12),
          user: meInRoom!.user,
          meta: img!,
          location: path,
          multipath: Const.gallery.name,
        );
      }
    }

    if (tonal) {
      return IconButton.filledTonal(
        onPressed: func,
        icon: const Icon(CupertinoIcons.photo),
      );
    }

    return IconButton(
      onPressed: func,
      icon: const Icon(CupertinoIcons.photo),
    );
  }
}

String thumbImage(String u) {
  if (!u.contains(spacemoonStorageBucket)) return u;
  final uri = Uri.parse(u);
  final base = '${uri.path.split('/').lastOrNull?.split('%2F').lastOrNull}';
  return u.replaceFirst(base, 'thumb_$base');
}
