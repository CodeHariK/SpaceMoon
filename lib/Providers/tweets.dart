import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/roomuser.dart';
import 'package:spacemoon/main.dart';

part 'tweets.g.dart';

extension SuperTweet on Tweet {
  Stream<DocumentSnapshot<Tweet?>>? get stream => FirebaseFirestore.instance
      .doc(path)
      .withConverter(
        fromFirestore: (snapshot, options) => fromDocSnap(Tweet(), snapshot),
        toFirestore: (value, options) => value?.toMap() ?? {},
      )
      .snapshots();
}

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

  FutureOr<String?> sendTweet({
    required Tweet tweet,
  }) async {
    final roomuser = ref.watch(currentRoomUserProvider).value;

    tweet.room = roomuser!.room;

    try {
      // Stopwatch stopwatch = Stopwatch()..start();
      final res = await SpaceMoon.fn('tweet-sendTweet').call(tweet.toMap());
      // stopwatch.stop();
      // print(stopwatch.elapsedMilliseconds);

      return res.data;
    } catch (e) {
      debugPrint('sendTweet Failed');
    }
    return null;
  }

  Future<void> updateTweet({required Tweet tweet}) async {
    try {
      await SpaceMoon.fn('tweet-updateTweet').call(tweet.toMap());
    } catch (e) {
      debugPrint('updateTweet Failed');
    }
  }

  FutureOr<void> deleteTweet({
    required Tweet tweet,
  }) async {
    try {
      await SpaceMoon.fn('tweet-deleteTweet').call(tweet.toMap());
    } catch (e) {
      debugPrint('deleteTweet Failed');
    }
  }

  FutureOr<void> reportTweet({required Tweet tweet, required Set<String> reason}) async {
    try {
      await SpaceMoon.fn('tweet-reportTweet').call({'tweet': tweet.toMap(), 'reason': reason.toList()});
    } catch (e) {
      debugPrint('reportTweet Failed$e');
    }
  }
}

@riverpod
FutureOr<Tweet?> getTweetById(GetTweetByIdRef ref, Tweet tweet) async {
  try {
    final tweetDoc = await FirebaseFirestore.instance
        .doc('${Const.rooms.name}/${tweet.room}/${Const.tweets.name}/${tweet.uid}')
        .get();

    return fromDocSnap(Tweet(), tweetDoc);
  } catch (e) {
    return null;
  }
}

@riverpod
Future<int?> getNewTweetCount(GetNewTweetCountRef ref, RoomUser user) async {
  return await user.tweetCol
      ?.where(
        Const.created.name,
        isGreaterThan: user.updated.isoDate,
      )
      .count()
      .get()
      .then((value) {
    return value.count;
  }).catchError((e, s) {
    lava(e);
    return 0;
  });
}
