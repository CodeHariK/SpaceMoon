import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Form/mario.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:moonspace/darkknight/extensions/string.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Widget/AppFlowy/app_flowy.dart';
import 'package:spacemoon/Widget/Chat/photo_box.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Widget/Chat/qr_box.dart';
import 'package:spacemoon/Widget/Common/fire_image.dart';

class SendBox extends HookConsumerWidget {
  const SendBox({
    super.key,
    required this.roomUser,
    this.mediaType = MediaType.TEXT,
    this.link,
    this.onChanged,
  });

  final RoomUser roomUser;
  final MediaType mediaType;
  final String? link;
  final Function(String value)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetCon = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: tweetCon,
              minLines: 1,
              maxLines: mediaType == MediaType.QR ? 60 : 4,
              onChanged: onChanged,
              scrollPhysics: const ClampingScrollPhysics(),
              buildCounter: mediaType == MediaType.QR
                  ? ((context, {required currentLength, required isFocused, maxLength}) {
                      return Text('$currentLength ${currentLength == 1200 ? "Max Length" : ""}');
                    })
                  : null,
              maxLength: mediaType == MediaType.QR ? 1200 : null,
              decoration: InputDecoration(
                hintText: mediaType == MediaType.QR ? 'Type to generate QR Code' : 'Type...',
                contentPadding: 16.e,
                prefixIcon: const Icon(Icons.star),
                suffixIcon: (mediaType == MediaType.QR)
                    ? null
                    : ContextMenu(
                        boxSize: const Size(200, 200),
                        optionChild: GridView.count(
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          padding: const EdgeInsets.all(8),
                          crossAxisCount: 3,
                          children: [
                            IconButton.filledTonal(
                              icon: const Icon(Icons.qr_code_rounded),
                              onPressed: () {
                                context.rSlidePush(
                                  QrDialog(
                                    roomUser: roomUser,
                                  ),
                                );
                                ContextMenu.hide();
                              },
                            ),
                            // IconButton.filledTonal(
                            //   icon: const Icon(Icons.camera_alt_outlined),
                            //   onPressed: () async {
                            //     ContextMenu.hide();

                            //     final userId = roomUser.user;
                            //     final saveFire = await saveFirePickCropImage(
                            //       '$userId/tweets',
                            //     );

                            //     // final imageMeta = saveFire?.meta;
                            //     final imageTask = saveFire?.task;

                            //     if (context.mounted && imageTask != null) {
                            //       LoadingScreenController? contoller = LoadingScreen().show(
                            //         context: context,
                            //         text: 'Uploading',
                            //         action: Row(
                            //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            //           children: [
                            //             TextButton(
                            //               onPressed: () {
                            //                 imageTask.cancel();
                            //               },
                            //               child: const Text('Cancel'),
                            //             ),
                            //             TextButton(
                            //               onPressed: () {
                            //                 imageTask.pause();
                            //               },
                            //               child: const Text('Pause'),
                            //             ),
                            //             TextButton(
                            //               onPressed: () {
                            //                 imageTask.resume();
                            //               },
                            //               child: const Text('Resume'),
                            //             ),
                            //           ],
                            //         ),
                            //       );
                            //       imageTask.stream.listen(
                            //         (event) {
                            //           contoller?.update(event.transferred.toString());
                            //           if (!event.running) {
                            //             LoadingScreen().hide();
                            //           }
                            //         },
                            //       );
                            //     }

                            //     final imageUrl = await imageTask?.then(
                            //       (task) => task.ref.getDownloadURL(),
                            //     );

                            //     if (imageUrl != null && context.mounted) {
                            //       showDialog(
                            //         context: context,
                            //         builder: (context) {
                            //           return PhotoDialog(
                            //             imageUrl: imageUrl,
                            //             ref: ref,
                            //             roomUser: roomUser,
                            //             // scrollCon: scrollCon,
                            //           );
                            //         },
                            //       );
                            //     }
                            //   },
                            // ),

                            IconButton.filledTonal(
                              onPressed: () async {
                                ContextMenu.hide();
                                final imgs = await saveFireMedia('loc');
                                if (imgs.isEmpty) return;
                                final tweetPath = await ref.read(tweetsProvider.notifier).sendTweet(
                                      tweet: Tweet(
                                        mediaType: MediaType.GALLERY,
                                        imageMetadata: List<ImageMetadata>.from(imgs),
                                      ),
                                    );
                                // for (var img in imgs) {
                                //   await uploadFire(
                                //     imageName: randomString(12),
                                //     user: roomUser.user,
                                //     meta: img!,
                                //     location: tweetPath,
                                //     multipath: 'imageMetadata',
                                //   );
                                // }
                              },
                              icon: const Icon(Icons.call_merge_sharp),
                            ),

                            IconButton.filledTonal(
                              onPressed: () async {
                                ContextMenu.hide();
                                final res = await context.cPush<String>(
                                  Hero(
                                    tag: 'Appflowy',
                                    child: AppFlowy(
                                      jsonData: exampleJson,
                                    ),
                                  ),
                                );
                                ref.read(tweetsProvider.notifier).sendTweet(
                                      tweet: Tweet(
                                        text: res,
                                        mediaType: MediaType.POST,
                                      ),
                                    );
                              },
                              icon: const Icon(Icons.post_add),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add_circle_outline_sharp),
                      ),
              ),
            ),
          ),
          if (mediaType != MediaType.QR) const SizedBox(width: 10),
          if (mediaType != MediaType.QR)
            FloatingActionButton(
              elevation: 0,
              onPressed: () async {
                if (tweetCon.text.isNotEmpty) {
                  //
                  ref.read(tweetsProvider.notifier).sendTweet(
                        tweet: Tweet(
                          text: tweetCon.text,
                          mediaType: mediaType,
                          link: link,
                        ),
                      );

                  tweetCon.clear();
                  FocusManager.instance.primaryFocus?.unfocus();

                  if (mediaType != MediaType.TEXT) {
                    context.pop();
                  }
                }
              },
              child: const Icon(Icons.send),
            ),
        ],
      ),
    );
  }
}
