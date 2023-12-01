import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/room.dart';

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
      final res = await FirebaseFunctions.instance.httpsCallable('sendTweet').call(tweet.toMap());
      return res.data;
    } catch (e) {
      debugPrint('sendTweet Failed');
    }
    return null;
  }

  Future<void> updateTweet({required Tweet tweet}) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('updateTweet').call(tweet.toMap());
    } catch (e) {
      debugPrint('updateTweet Failed');
    }
  }

  FutureOr<void> deleteTweet({
    required Tweet tweet,
  }) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('deleteTweet').call(tweet.toMap());
    } catch (e) {
      debugPrint('deleteTweet Failed');
    }
  }
}
