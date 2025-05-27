import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/animated_dialog.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Routes/Home/TabShell/unsplash.dart';
import 'package:moonspace/widgets/async_lock.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Chat/qr_box.dart';
import 'package:spacemoon/Widget/TextEditor/text_editor_box.dart';

class SendBox extends HookConsumerWidget {
  const SendBox({
    super.key,
    required this.roomUser,
    this.mediaType = MediaType.TEXT,
    this.link,
    this.onChanged,
    this.onSubmit,
  });

  final RoomUser roomUser;
  final MediaType mediaType;
  final String? link;
  final void Function(String value)? onChanged;
  final Future<void> Function(TextEditingController)? onSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tweetCon = useTextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: AsyncTextFormField(
              asyncValidator: (value) async {
                return null;
              },
              onSubmit: onSubmit ??
                  (controller) async {
                    sendTweet(context, tweetCon, null, ref, mediaType, link);
                  },
              textInputAction: TextInputAction.done,
              controller: tweetCon,
              minLines: 1,
              maxLines: mediaType == MediaType.QR ? 60 : 4,
              onChanged: onChanged,
              scrollPhysics: const ClampingScrollPhysics(),
              buildCounter: mediaType == MediaType.QR
                  ? ((context,
                      {required currentLength, required isFocused, maxLength}) {
                      return Text(
                          '$currentLength ${currentLength == 1200 ? "Max Length" : ""}');
                    })
                  : null,
              maxLength: mediaType == MediaType.QR ? 1200 : null,
              showPrefix: false,
              showSubmitSuffix: false,
              suffix: [
                if (mediaType != MediaType.QR)
                  SendActionMenu(roomUser: roomUser),
              ],
              decoration: (asyncText, textCon) => InputDecoration(
                hintText: mediaType == MediaType.QR
                    ? 'Type to generate QR Code'
                    : 'Type...',
                contentPadding: 16.e,
                prefixIcon: const Icon(Icons.star),
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

class SendActionMenu extends ConsumerWidget {
  const SendActionMenu({
    super.key,
    required this.roomUser,
  });

  final RoomUser roomUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(
        Icons.add_circle_outline_sharp,
        size: 20,
        semanticLabel: 'features',
      ),
      onPressed: () {
        AnimatedDialogBox(
          boxSize: const Size(200, 200),
          child: GridView.count(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(8),
            crossAxisCount: 3,
            children: [
              QrActionButton(roomUser: roomUser),
              GalleryUploaderButton(ref: ref),
              TextEditorActionButton(ref: ref),
              UnsplashButton(roomUser: roomUser)
            ],
          ),
        ).show(context);
      },
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
    return AsyncLock(
      builder: (loading, status, lock, open, setStatus) => FloatingActionButton(
        heroTag: 'sendButtonChat',
        elevation: 0,
        onPressed: () async {
          lock();
          await sendTweet(context, tweetCon, text, ref, mediaType, link);
          open();
        },
        child: const Icon(
          Icons.send,
          semanticLabel: 'Send tweet',
        ),
      ),
    );
  }
}

Future<void> sendTweet(
  BuildContext context,
  TextEditingController? tweetCon,
  String? text,
  WidgetRef ref,
  MediaType? mediaType,
  String? link,
) async {
  final sendText = tweetCon?.text ?? text ?? '';

  if (sendText.isNotEmpty == true) {
    //
    await ref.read(tweetsProvider.notifier).sendTweet(
          tweet: Tweet(
            text: sendText,
            mediaType: mediaType,
            link: link,
          ),
        );

    tweetCon?.clear();
    FocusManager.instance.primaryFocus?.unfocus();

    if (mediaType != MediaType.TEXT && context.mounted) {
      context.pop();
    }
  }
}
