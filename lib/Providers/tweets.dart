import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/room.dart';

part 'tweets.g.dart';

@riverpod
class Tweets extends _$Tweets {
  @override
  void build() {
    return;
  }

  // @override
  // Stream<List<Tweet?>> build() {
  //   final room = ref.watch(currentRoomProvider).value;

  //   final stream = room?.tweetCol
  //       ?.orderBy(
  //         Const.created.name,
  //         descending: true,
  //       )
  //       .snapshots()
  //       .map((event) => event.docs.map((e) => e.data()?..room = room.uid).toList());
  //   return stream ?? const Stream.empty();
  // }

  FutureOr<void> sendTweet({
    required Tweet tweet,
  }) async {
    final roomuser = ref.watch(currentRoomUserProvider).value;

    tweet.room = roomuser!.room;

    await FirebaseFunctions.instance.httpsCallable('sendTweet').call(tweet.toMap());
  }

  FutureOr<void> deleteTweet({
    required Tweet tweet,
  }) async {
    final roomuser = ref.watch(currentRoomUserProvider).value;

    tweet.room = roomuser!.room;

    await FirebaseFunctions.instance.httpsCallable('deleteTweet').call(tweet.toMap());
  }
}
