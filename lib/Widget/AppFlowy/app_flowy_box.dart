import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonspace/form/mario.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Widget/AppFlowy/app_flowy.dart';

class AppFlowyBox extends ConsumerWidget {
  const AppFlowyBox({
    super.key,
    required this.tweet,
  });

  final Tweet tweet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () async {
        final data = await context.cPush(
          Hero(
            tag: '${tweet.hashCode} Appflowy',
            child: AppFlowy(
              jsonData: tweet.text,
            ),
          ),
        );

        tweet.text = data;
        ref.read(tweetsProvider.notifier).updateTweet(tweet: tweet);
      },
      child: IgnorePointer(
        child: SizedBox(
          width: 300,
          height: 300,
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
    );
  }
}
