import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:moonspace/darkknight/extensions/regex.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Widget/Chat/qr_box.dart';
import 'package:spacemoon/Widget/Common/video_player.dart';

class TweetBox extends HookConsumerWidget {
  const TweetBox({
    super.key,
    required this.tweet,
    required this.roomuser,
  });

  final Tweet tweet;
  final RoomUser roomuser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final ValueNotifier<PreviewData?> linkPreviewData = useState(null);

    return GestureDetector(
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsPadding: const EdgeInsets.all(8),
            title: const Text('Delete this tweet'),
            actions: [
              OutlinedButton(
                onPressed: () {
                  ref.read(tweetsProvider.notifier).deleteTweet(tweet: tweet);
                  Navigator.pop(context);
                },
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red, width: 1),
          borderRadius: 12.br,
        ),
        padding: (12, 0).e,
        child: Row(
          children: [
            const Expanded(
              flex: 2,
              child: SizedBox(),
            ),
            Expanded(
              flex: 8,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 1),
                  borderRadius: 12.br,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 50,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Icon(Icons.palette_outlined),
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SelectableText(
                            tweet.text,
                          ),
                          // SuperLink(tweet.text),

                          //
                          // if (tweet.mediaType == MediaType.VIDEO)
                          //   const VideoPlayerBox(
                          //     title: 'Sintel',
                          //     videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
                          //     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                          //   ),

                          // if (tweet.mediaType == MediaType.IMAGE)
                          //   ClipRRect(
                          //     borderRadius: 25.br,
                          //     child: SizedBox(
                          //       height: 300,
                          //       width: 300,
                          //       child: Image.network(
                          //         tweet.link,
                          //         fit: BoxFit.cover,
                          //       ),
                          //     ),
                          //   ),

                          // if (tweet.mediaType == MediaType.QR)
                          //   QrBox(
                          //     qrtext: tweet.text,
                          //   ),

                          // if (isWebsite(tweet.text))
                          //   link.LinkPreview(
                          //     enableAnimation: true,
                          //     onPreviewDataFetched: (p0) {
                          //       linkPreviewData.value = p0;
                          //     },
                          //     previewData: linkPreviewData.value,
                          //     text: tweet.text,
                          //     width: 300,
                          //   ),

                          Text(
                            'Time : ${tweet.created.toDateTime()}',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]..sort(
              (_, __) => roomuser.user == tweet.user ? -1 : 1,
            ),
        ),
      ),
    );
  }
}
