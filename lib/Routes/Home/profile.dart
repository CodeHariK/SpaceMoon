import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/form/mario.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/validator/checkers.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Helpers/gorouter_ext.dart';
import 'package:spacemoon/Helpers/proto.dart';
import 'package:spacemoon/Providers/auth.dart';
import 'package:spacemoon/Providers/room.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Routes/Home/Chat/chat_screen.dart';
import 'package:spacemoon/Routes/Home/home.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Common/fire_image.dart';

class ProfileObj {
  final User? user;

  ProfileObj({required this.user});
}

class ProfileRoute extends GoRouteData {
  final User? $extra;

  const ProfileRoute({this.$extra});

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return fadePage(
      context,
      state,
      ProfilePage(
        searchuser: $extra,
      ),
    );
  }
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({
    super.key,
    this.searchuser,
  });

  final User? searchuser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = searchuser ?? ref.watch(currentUserDataProvider).value;

    return Scaffold(
      appBar: searchuser != null ? AppBar() : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: (240, 300).c,
                    width: (240, 300).c,
                    padding: const EdgeInsets.all(8),
                    foregroundDecoration: user?.admin == false
                        ? null
                        : BoxDecoration(
                            border: Border.all(width: 10, color: AppTheme.seedCard),
                            borderRadius: BorderRadius.circular(300),
                          ),
                    child: Semantics(
                      label: 'Update profile picture',
                      child: InkWell(
                        splashFactory: InkSplash.splashFactory,
                        onTap: searchuser != null
                            ? null
                            : () async {
                                final imageMetadata = await selectImageMedia();

                                if (imageMetadata == null) return;

                                await uploadFire(
                                  meta: imageMetadata.$1,
                                  file: imageMetadata.$2,
                                  imageName: 'profile${randomString(4)}',
                                  storagePath: 'profile/users/${user!.uid}',
                                  docPath: 'users/${user.uid}',
                                  singlepath: Const.photoURL.name,
                                );
                              },
                        child: user?.photoURL == null || user?.photoURL.isEmpty == true
                            ? Icon(
                                Icons.face_2_outlined,
                                size: (120, 160).c,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(250),
                                child: FutureSpaceBuilder(
                                  path: user?.photoURL,
                                  thumbnail: true,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Semantics(
                    label: 'Update display name',
                    child: AsyncTextFormField(
                      key: ValueKey('Name ${user?.displayName}'),
                      initialValue: user?.displayName,
                      enabled: searchuser == null,
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
                  ),
                  const SizedBox(height: 10),
                  Semantics(
                    label: 'Update Nick name',
                    child: AsyncTextFormField(
                      key: ValueKey('Nick ${user?.nick}'),
                      initialValue: user?.nick,
                      autocorrect: false,
                      enableSuggestions: false,
                      enabled: searchuser == null,
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
                  ),
                  if (user?.email.isNotEmpty ?? false)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Email : ${user?.email}', style: context.ts),
                    ),
                  if (user?.phoneNumber.isNotEmpty ?? false)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Phone : ${user?.phoneNumber}', style: context.ts),
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
                      style: context.ts,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Last seen : ${user?.updated.dateString}',
                      style: context.ts,
                    ),
                  ),
                  if (searchuser != null && searchuser != user)
                    Consumer(
                      builder: (context, ref, child) {
                        final me = ref.watch(currentUserDataProvider).value;

                        return OutlinedButton(
                          onPressed: () async {
                            final room = await ref.read(currentRoomProvider.notifier).createRoom(
                              room: Room(displayName: '${me!.displayName} ${user!.displayName}'),
                              users: [
                                me.uid,
                                user.uid,
                              ],
                            );
                            if (room != null && context.mounted) {
                              ChatRoute(chatId: room.uid).go(context);
                            }
                          },
                          child: const Text('Create new chat'),
                        );
                      },
                    ),
                  if (searchuser == null)
                    ListTile(
                      tileColor: context.theme.csSecCon,
                      titleTextStyle: context.ts.c(context.theme.csSec),
                      iconColor: context.theme.csSec,
                      leading: const Icon(Icons.logout),
                      onTap: () async {
                        final res = await showYesNo(context: context, title: 'Are you sure you want to sign out?');
                        if (res) {
                          auth.FirebaseAuth.instance.signOut();
                        }
                      },
                      title: const Text('Sign out'),
                    ),
                  const SizedBox(height: 5),
                  if (searchuser == null)
                    ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      tileColor: context.theme.csErrCon,
                      titleTextStyle: context.ts.c(context.theme.csErr),
                      iconColor: context.theme.csErr,
                      leading: const Icon(Icons.delete),
                      onTap: () async {
                        final res = await showYesNo(
                          context: context,
                          title: 'Confirm Account Deletion?',
                          content:
                              'Are you sure you want to delete your account? All your data will be automatically deleted.',
                        );
                        if (res) {
                          String? errorMessage;

                          await auth.FirebaseAuth.instance.currentUser?.delete().then((value) {
                            Navigator.pop(context);
                          }).onError(
                            (auth.FirebaseAuthException error, stackTrace) {
                              errorMessage = error.message;
                            },
                          );

                          if (context.mounted && errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 10),
                                content: Text(errorMessage!),
                              ),
                            );
                          }
                        }
                      },
                      title: const Text('Delete Account'),
                    ),
                  // const RefreshTokenDisplay(),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final refreshToken = ref.watch(currentUserTokenProvider).value;
    if (kDebugMode) {
      return Text((beautifyMap(refreshToken)).toString());
    }
    return Container();
  }
}
