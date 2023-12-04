import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/validator/checkers.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Common/fire_image.dart';

class ProfileObj {
  final User? user;

  ProfileObj({required this.user});
}

class ProfileRoute extends GoRouteData {
  final ProfileObj? $extra;

  const ProfileRoute({this.$extra});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage(
      searchuser: $extra,
    );
  }
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
    this.searchuser,
  });

  final ProfileObj? searchuser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = searchuser?.user ?? ref.watch(currentUserDataProvider).value;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 240,
                    width: 240,
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      splashFactory: InkSplash.splashFactory,
                      onTap: searchuser?.user != null
                          ? null
                          : () async {
                              final imageMetadata = await selectImageMedia();

                              if (imageMetadata == null) return;

                              await uploadFire(
                                meta: imageMetadata,
                                imageName: 'profile',
                                storagePath: 'profile/users/${user!.uid}',
                                docPath: 'users/${user.uid}',
                                singlepath: Const.photoURL.name,
                              );
                            },
                      child: user?.photoURL == null || user?.photoURL.isEmpty == true
                          ? const Icon(
                              CupertinoIcons.person_crop_circle_badge_plus,
                              size: 120,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(250),
                              child: CustomCacheImage(
                                imageUrl: spaceThumbImage(user!.photoURL),
                              ),
                            ),
                    ),
                  ),
                  AsyncTextFormField(
                    key: ValueKey('Name ${user?.displayName}'),
                    initialValue: user?.displayName,
                    enabled: searchuser?.user == null,
                    style: context.hm,
                    asyncValidator: (value) async {
                      return value.checkMin(8);
                    },
                    maxLines: 1,
                    showPrefix: false,
                    textInputAction: TextInputAction.done,
                    onSubmit: (con) async => await callUserUpdate(
                      User(
                        displayName: con.text,
                      ),
                    ),
                    decoration: (AsyncText value, nickCon) => AppTheme.uInputDecoration.copyWith(
                      hintText: 'Name',
                    ),
                  ),
                  const SizedBox(height: 10),
                  AsyncTextFormField(
                    key: ValueKey('Nick ${user?.nick}'),
                    initialValue: user?.nick,
                    enabled: searchuser?.user == null,
                    style: context.tl,
                    maxLines: 1,
                    asyncValidator: (value) async {
                      if (value.checkMin(8) != null) {
                        return value.checkMin(8);
                      }
                      if (value.checkAlphanumeric() != null) {
                        return value.checkAlphanumeric();
                      }
                      if (user?.nick == value) {
                        return null;
                      }

                      final count = await countUserByNick(value);
                      if (count != 0) {
                        return 'Not available';
                      }
                      return null;
                    },
                    showPrefix: false,
                    textInputAction: TextInputAction.done,
                    onSubmit: (con) async => await callUserUpdate(
                      User(
                        nick: con.text,
                      ),
                    ),
                    decoration: (AsyncText value, nickCon) => AppTheme.uInputDecoration.copyWith(
                      hintText: 'Nick name',
                      prefix: const Text('Nick name : @'),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Email : ${user?.email}', style: context.tm),
                  ),
                  // ListTile(
                  //   title: Text('Visibility : ${user?.open.name}', style: context.tm),
                  // ),
                  // ListTile(
                  //   title: Text('Friends : ${user?.friends.length}', style: context.tm),
                  // ),
                  // ListTile(
                  //   title: Text('Status : ${user?.status.name}', style: context.tm),
                  // ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Joined on : ${user?.created.dateString}',
                      style: context.tm,
                    ),
                  ),
                  const RefreshTokenDisplay(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RefreshTokenDisplay extends ConsumerWidget {
  const RefreshTokenDisplay({super.key});

  Map<String, dynamic>? jwtParse(String? refreshToken) {
    final jwt = refreshToken?.split('.');
    if (jwt != null && jwt.length > 1) {
      String token = jwt[1];
      int l = (token.length % 4);
      token += List.generate(l, (index) => '=').join();
      final decoded = base64.decode(token);
      token = utf8.decode(decoded);
      return json.decode(token) as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    if (kDebugMode) {
      return FutureBuilder(
        future: user?.getIdToken(),
        builder: (context, snapshot) {
          final refreshToken = snapshot.data;
          // return Text(refreshToken ?? '-');
          return Text((beautifyMap(jwtParse(refreshToken))).toString());
        },
      );
    }
    return Container();
  }
}
