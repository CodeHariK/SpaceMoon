import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/form/mario.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/AppFlowy/app_flowy.dart';

class AppFlowyBox extends ConsumerWidget {
  const AppFlowyBox({
    super.key,
    required this.tweet,
  });

  final Tweet tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final curuser = ref.watch(currentUserProvider).value;

    return Semantics(
      label: 'AppFlowy Editor',
      child: InkWell(
        onTap: () async {
          await context.cPush(
            Hero(
              tag: '${tweet.hashCode} Appflowy',
              child: AppFlowy(
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
              tag: '${tweet.hashCode} Appflowy',
              child: AppFlowy(
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

class AppFlowyActionButton extends StatelessWidget {
  const AppFlowyActionButton({
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
            tag: 'Appflowy',
            child: AppFlowy(
              jsonData: exampleJson,
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
