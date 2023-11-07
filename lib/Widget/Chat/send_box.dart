import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Form/mario.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Widget/Chat/photo_box.dart';
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

    final theme = context.theme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
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
          enabledBorder: 1.bs.out.r(15),
          focusedBorder: 1.bs.out.r(15),
          fillColor: theme.pri.withAlpha(10),
          filled: true,
          contentPadding: 16.e,
          // prefixIcon: const Icon(Icons.star),
          suffixIcon: (mediaType == MediaType.QR)
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (mediaType == MediaType.TEXT)
                      IconButton(
                        icon: const Icon(Icons.qr_code_rounded),
                        onPressed: () {
                          showDialog(
                            context: context,
                            useSafeArea: false,
                            builder: (context) {
                              return QrDialog(
                                roomUser: roomUser,
                              );
                            },
                          );
                        },
                      ),

                    if (mediaType == MediaType.TEXT)
                      IconButton(
                        icon: const Icon(Icons.tag),
                        onPressed: () async {
                          final userId = roomUser.user;
                          final imageTask = await saveFirePickCropImage(
                            '$userId/tweets',
                          );

                          if (context.mounted && imageTask != null) {
                            // final url = showDialog<String?>(
                            //   context: context,
                            //   builder: (context) {
                            //     return FireUploadDialog(imageTask: imageTask);
                            //   },
                            // );
                            // dino(url);
                            LoadingScreenController? contoller = LoadingScreen().show(
                              context: context,
                              text: 'Uploading',
                              action: Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      imageTask.cancel();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      imageTask.pause();
                                    },
                                    child: const Text('Pause'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      imageTask.resume();
                                    },
                                    child: const Text('Resume'),
                                  ),
                                ],
                              ),
                            );
                            imageTask.stream.listen(
                              (event) {
                                contoller?.update(event.transferred.toString());
                                if (!event.running) {
                                  LoadingScreen().hide();
                                }
                              },
                            );
                          }

                          final imageUrl = await imageTask?.then(
                            (task) => task.ref.getDownloadURL(),
                          );

                          if (imageUrl != null && context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return PhotoDialog(
                                  imageUrl: imageUrl,
                                  ref: ref,
                                  roomUser: roomUser,
                                  // scrollCon: scrollCon,
                                );
                              },
                            );
                          }
                        },
                      ),

                    // IconButton(
                    //   icon: const Icon(Icons.tag),
                    //   onPressed: () async {
                    //     final userId = me.id;
                    //     log('Hello');
                    //     final multiTask = await saveFireMedia(
                    //       '$userId/tweets',
                    //     );
                    //     final multiUrl = await multiTask?.then(
                    //       (p0) => p0.ref.getDownloadURL(),
                    //     );
                    //     // log(imageUrl.toString());

                    //     // if (imageUrl != null && context.mounted) {
                    //     //   showDialog(
                    //     //     context: context,
                    //     //     builder: (context) {
                    //     //       return PhotoDialog(
                    //     //         imageUrl: imageUrl,
                    //     //         ref: ref,
                    //     //         me: me,
                    //     //         // scrollCon: scrollCon,
                    //     //       );
                    //     //     },
                    //     //   );
                    //     // }
                    //   },
                    // ),

                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        if (tweetCon.text.isNotEmpty) {
                          //
                          ref.read(tweetsProvider.notifier).sendTweet(
                                tweet: Tweet(
                                  text: tweetCon.text,
                                  mediaType: mediaType,
                                  link: link,
                                ),
                              );

                          //
                          tweetCon.clear();
                          FocusManager.instance.primaryFocus?.unfocus();

                          // scrollCon.jumpTo(
                          //   scrollCon.position.minScrollExtent,
                          // );

                          if (mediaType != MediaType.TEXT) {
                            context.pop();
                          }
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
