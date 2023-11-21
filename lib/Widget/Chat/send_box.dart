import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Form/mario.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Widget/AppFlowy/app_flowy.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Chat/qr_box.dart';

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
  final void Function(String value)? onChanged;

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
                            GalleryUploaderButton(ref: ref),
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
                                if (res != null) {
                                  ref.read(tweetsProvider.notifier).sendTweet(
                                        tweet: Tweet(
                                          text: res,
                                          mediaType: MediaType.POST,
                                        ),
                                      );
                                }
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
            SendButton(
              tweetCon: tweetCon,
              mediaType: mediaType,
              link: link,
            ),
        ],
      ),
    );
  }
}

class SendButton extends ConsumerWidget {
  const SendButton({
    super.key,
    this.text,
    this.tweetCon,
    this.mediaType,
    this.link,
  });

  final TextEditingController? tweetCon;
  final MediaType? mediaType;
  final String? link;
  final String? text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      elevation: 0,
      // onPressed: () {
      //   final roomUser = ref.read(currentRoomUserProvider).value;
      //   if (roomUser == null) return;
      //   for (int i = 0; i < 10; i++) {
      //     FirebaseFirestore.instance.collection('rooms/${roomUser.room}/tweets').add(
      //       {
      //         'created': DateTime.now().subtract(Duration(days: Random().nextInt(30))).toIso8601String(),
      //         'text': randomString(Random().nextInt(Random().nextBool() ? 20 : 300)),
      //         'user': Random().nextBool() ? roomUser.user : randomString(28),
      //       },
      //     );
      //   }
      // },
      onPressed: () async {
        final sendText = tweetCon?.text ?? text ?? '';

        if (sendText.isNotEmpty == true) {
          //
          ref.read(tweetsProvider.notifier).sendTweet(
                tweet: Tweet(
                  text: sendText,
                  mediaType: mediaType,
                  link: link,
                ),
              );

          tweetCon?.clear();
          FocusManager.instance.primaryFocus?.unfocus();

          if (mediaType != MediaType.TEXT) {
            context.pop();
          }
        }
      },
      child: const Icon(Icons.send),
    );
  }
}
