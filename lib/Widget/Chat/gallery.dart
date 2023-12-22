import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/form/mario.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/roomuser.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/Common/fire_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:spacemoon/Widget/Common/shimmer_boxes.dart';
import 'package:spacemoon/Widget/Common/video_player.dart';

part 'gallery.g.dart';

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
    final imageMetadata = tweet.gallery[index];

    final isVideo = imageMetadata.type.contains('video');

    if (isVideo) {
      return Container(
        height: 320,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 2,
              child: FutureSpaceBuilder(
                imageMetadata: imageMetadata,
                builder: (url) {
                  return VideoPlayerBox(
                    title: imageMetadata.caption,
                    url: url,
                  );
                },
              ),
            ),
            const IgnorePointer(child: Icon(Icons.play_circle_fill, size: 40)),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: !inScaffold
          ? null
          : () {
              context.bSlidePush(
                Scaffold(
                  appBar: AppBar(
                    title: Text(imageMetadata.caption),
                  ),
                  body: Container(
                    constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height,
                    ),
                    child: FutureSpaceBuilder(
                      imageMetadata: imageMetadata,
                      builder: (url) {
                        return PhotoView(
                          imageProvider: NetworkImage(url),
                          // tightMode: true,
                          // maxScale: PhotoViewComputedScale.covered * 2.0,
                          // minScale: PhotoViewComputedScale.contained * 0.8,
                          initialScale: PhotoViewComputedScale.contained,
                        );
                      },
                    ),
                  ),
                ),
              );
            },
      child: Container(
        height: (280, 500).c,
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
              FutureSpaceBuilder(
                imageMetadata: imageMetadata,
                thumbnail: !inScaffold,
              ),
              // if (imageMetadata.url.isNotEmpty)
              //   CustomCacheImage(
              //     imageUrl: inScaffold ? imageMetadata.url : spaceThumbImage(imageMetadata.url),
              //     // blurHash: imageMetadata.blurhash,
              //   ),
              if (imageMetadata.localUrl.isNotEmpty && !kIsWeb)
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
              if (inScaffold && imageMetadata.localUrl.isNotEmpty && !kIsWeb)
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
                            try {
                              final p = tweet.path.split('/');
                              final roomId = p[1];
                              final tweetId = p[3];

                              await uploadFire(
                                imageName: randomString(12),
                                storagePath: 'tweet/$roomId/${tweet.user}/$tweetId',
                                docPath: 'rooms/$roomId/tweets/$tweetId',
                                meta: imageMetadata,
                                file: null,
                                multipath: Const.gallery.name,
                              );
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          },
                          icon: const Icon(CupertinoIcons.cloud_upload_fill),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

extension SuperImageMetadata on Tweet {
  List<ImageMetadata> get avaiable => gallery.where((element) => element.localUrl.isEmpty).toList();
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
    final uploaded = tweet.avaiable.length;
    final total = tweet.gallery.length;

    final child = Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: (250, 500).c,
          width: (250, 500).c,
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

class GalleryScaffold extends ConsumerStatefulWidget {
  const GalleryScaffold({super.key, required this.tweet});

  final Tweet tweet;

  @override
  ConsumerState<GalleryScaffold> createState() => _GalleryScaffoldState();
}

class _GalleryScaffoldState extends ConsumerState<GalleryScaffold> {
  List<ImageMetadata> selected = [];
  bool startSelection = false;

  Tweet get tweet => widget.tweet;

  @override
  Widget build(BuildContext context) {
    final me = ref.watch(currentUserProvider).value;

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
            title: Text(tweet.path),
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
          floatingActionButton: me?.uid != tweet.user
              ? null
              : Row(
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
                            try {
                              final p = tweet.path.split('/');
                              final roomId = p[1];
                              final tweetId = p[3];

                              await uploadFire(
                                imageName: randomString(12),
                                storagePath: 'tweet/$roomId/${tweet.user}/$tweetId',
                                docPath: 'rooms/$roomId/tweets/$tweetId',
                                meta: img,
                                file: null,
                                multipath: Const.gallery.name,
                              );
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          }
                        },
                      ),
                    ]
                  ],
                ),
          body: Container(
            alignment: Alignment.center,
            child: GridView.builder(
              cacheExtent: 2000,
              itemCount: tweet.gallery.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (1, 4).c.toInt()),
              itemBuilder: (context, index) {
                void selector() {
                  if (selected.contains(tweet.gallery[index])) {
                    selected.remove(tweet.gallery[index]);
                  } else {
                    selected.add(tweet.gallery[index]);
                  }
                  setState(() {});
                }

                return Container(
                  foregroundDecoration: BoxDecoration(
                    color: selected.contains(tweet.gallery[index]) ? Colors.black12 : null,
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onLongPress: () {
                      setState(() => startSelection = true);

                      selector();
                    },
                    onTap: !startSelection ? null : selector,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
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
                        if (me?.uid == tweet.user)
                          Consumer(
                            builder: (_, ref, ___) => AsyncTextFormField(
                              initialValue: tweet.gallery[index].caption,
                              asyncValidator: (value) async {
                                final uIndex = tweet.gallery.indexWhere((element) => element == tweet.gallery[index]);
                                tweet.gallery[uIndex].caption = value;

                                ref.read(tweetsProvider.notifier).updateTweet(tweet: tweet);

                                return null;
                              },
                              style: context.hs.c(Colors.white),
                              showPrefix: false,
                              milliseconds: 1000,
                              maxLines: 3,
                              decoration: (AsyncText value, galleryCon) => const InputDecoration(
                                fillColor: Colors.black38,
                                hintStyle: TextStyle(color: Colors.white70),
                                filled: true,
                                focusedBorder: InputBorder.none,
                                border: InputBorder.none,
                                hintText: 'Add Caption...',
                              ),
                            ),
                          ),
                        if (startSelection)
                          Align(
                            alignment: Alignment.topRight,
                            child: Checkbox(
                              value: selected.contains(tweet.gallery[index]),
                              onChanged: (v) {
                                selector();
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
      AnimatedOverlay.hide();
      final imgs = await selectMultiMedia();
      if (imgs.isEmpty) return;
      final path = tweet?.path ??
          await ref.read(tweetsProvider.notifier).sendTweet(
                tweet: Tweet(
                  mediaType: MediaType.GALLERY,
                  gallery: imgs.map((e) => e.$1),
                ),
              );

      if (tweet != null) {
        tweet?.gallery.addAll(imgs.map((e) => e.$1));

        ref.read(tweetsProvider.notifier).updateTweet(tweet: tweet!);
      }

      for (var img in imgs) {
        if (path != null) {
          try {
            final p = path.split('/');
            final roomId = p[1];
            final tweetId = p[3];

            await uploadFire(
              imageName: randomString(12),
              meta: img.$1,
              file: img.$2,
              storagePath: 'tweet/$roomId/${meInRoom!.user}/$tweetId',
              docPath: 'rooms/$roomId/tweets/$tweetId',
              multipath: Const.gallery.name,
            );
          } catch (e) {
            debugPrint(e.toString());
          }
        }
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

@Riverpod(keepAlive: true)
FutureOr<String> spaceStoreRef(SpaceStoreRefRef ref, String url) async {
  final r = await FirebaseStorage.instance.ref(url).getDownloadURL();
  return r;
}

class FutureSpaceBuilder extends ConsumerWidget {
  const FutureSpaceBuilder({
    super.key,
    this.imageMetadata,
    this.path,
    this.thumbnail = false,
    this.builder,
    this.radius,
  });

  final bool thumbnail;
  final Widget Function(String url)? builder;
  final ImageMetadata? imageMetadata;
  final String? path;
  final double? radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (imageMetadata?.unsplashurl.isNotEmpty ?? false) {
      return CustomCacheImage(
        radius: radius ?? 0,
        imageUrl: imageMetadata?.unsplashurl ?? '',
      );
    }

    final p = path ?? imageMetadata?.path ?? '';

    final spaceurl = ref.watch(spaceStoreRefProvider(thumbnail ? spaceThumbPath(p) : p));

    return spaceurl.when(
      data: (url) {
        if (builder == null) {
          return CustomCacheImage(
            radius: radius ?? 0,
            imageUrl: url,
          );
        } else {
          return builder!(url);
        }
      },
      error: (error, stackTrace) => const SizedBox(),
      loading: () => const SizedBox(),
    );
  }
}

String spaceThumbPath(String u) {
  final base = '${u.split('/').lastOrNull}';
  return u.replaceFirst(base, 'thumb_$base');
}
