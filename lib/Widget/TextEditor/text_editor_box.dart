import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/animated_overlay.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/TextEditor/text_editor.dart';

class TextEditorBox extends ConsumerWidget {
  const TextEditorBox({
    super.key,
    required this.tweet,
  });

  final Tweet tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curuser = ref.watch(currentUserProvider).value;

    return Semantics(
      label: 'Editor',
      child: InkWell(
        onTap: () async {
          await context.cPush(
            Hero(
              tag: '${tweet.hashCode} TextEditor',
              child: TextEditor(
                jsonData: tweet.text,
                editable: curuser?.uid == tweet.user,
                onPopInvoked: (pop, data) async {
                  if (curuser?.uid == tweet.user) {
                    tweet.text = data;
                    ref.read(tweetsProvider.notifier).updateTweet(tweet: tweet);
                  }
                },
              ),
            ),
          );
        },
        child: IgnorePointer(
          child: SizedBox(
            width: (250, 600).c,
            height: (250, 600).c,
            child: Hero(
              tag: '${tweet.hashCode} TextEditor',
              child: TextEditor(
                key: ObjectKey(tweet),
                jsonData: tweet.text,
                showAppbar: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextEditorActionButton extends StatelessWidget {
  const TextEditorActionButton({
    super.key,
    required this.ref,
  });

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () async {
        AnimatedOverlay.hide();
        await context.cPush<String>(
          Hero(
            tag: 'TextEditor',
            child: TextEditor(
              onPopInvoked: (pop, data) async {
                ref.read(tweetsProvider.notifier).sendTweet(
                      tweet: Tweet(
                        text: data,
                        mediaType: MediaType.POST,
                      ),
                    );
              },
            ),
          ),
        );
      },
      icon: const Icon(
        Icons.post_add,
        semanticLabel: 'post',
      ),
    );
  }
}
