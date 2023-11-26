import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/validator/validator.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/user_data.dart';
import 'package:spacemoon/Widget/Chat/gallery.dart';
import 'package:spacemoon/Widget/Common/fire_image.dart';

class ProfileRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPro = ref.watch(currentUserDataProvider);
    final user = userPro.value;

    if (userPro.isLoading) return const Scaffold();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 240,
                width: 240,
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  splashFactory: InkSplash.splashFactory,
                  onTap: () async {
                    final imageMetadata = await selectImageMedia();

                    if (imageMetadata == null) return;

                    await uploadFire(
                      meta: imageMetadata,
                      imageName: 'profile',
                      user: user!.uid,
                      location: 'users/${user.uid}',
                      singlepath: Const.photoURL.name,
                    );

                    // photo?.task.then((url) async {
                    //   final u = await url.ref.getDownloadURL();
                    //   callUserUpdate(User(photoURL: u));
                    // });
                  },
                  child: user?.photoURL == null || user?.photoURL.isEmpty == true
                      ? const Icon(
                          CupertinoIcons.person_crop_circle_badge_plus,
                          size: 120,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(250),
                          child: CustomCacheImage(
                            imageUrl: thumbImage(user!.photoURL),
                          ),
                        ),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: AsyncProfileField(
                  text: user?.displayName,
                  type: AsyncProfileFieldType.displayName,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: AsyncProfileField(
                  text: user?.nick,
                  type: AsyncProfileFieldType.nickname,
                ),
              ),
              ListTile(
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
                title: Text(
                  'Joined on : ${DateFormat.yMMMd().format(user?.created.toDateTime() ?? DateTime.now())}',
                  style: context.tm,
                ),
              ),
              // Consumer(
              //   builder: (context, ref, child) {
              //     final user = ref.watch(currentUserProvider).value;
              //     return FutureBuilder(
              //       future: user?.getIdToken(),
              //       builder: (context, snapshot) {
              //         final refreshToken = snapshot.data;
              //         return SelectableText(refreshToken ?? '-');
              //         return SelectableText((beautifyMap(jwtParse(refreshToken))).toString());
              //       },
              //     );
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class AsyncProfileFieldType {
  final String name;

  AsyncProfileFieldType({required this.name});

  static AsyncProfileFieldType nickname = AsyncProfileFieldType(name: "Nickname");
  static AsyncProfileFieldType displayName = AsyncProfileFieldType(name: "");
}

class AsyncProfileField extends StatelessWidget {
  const AsyncProfileField({
    super.key,
    required this.text,
    required this.type,
  });

  final String? text;
  final AsyncProfileFieldType type;

  @override
  Widget build(BuildContext context) {
    return AsyncTextFormField(
      key: ValueKey(text),
      initialValue: text,
      style: (type == AsyncProfileFieldType.nickname) ? context.tl : context.hm,
      asyncValidator: (value) async {
        if (value.isEmpty) {
          return 'Empty not possible';
        }
        if (!isAlphanumeric(value)) {
          return 'only alphanumeric characters are allowed';
        }

        if (type == AsyncProfileFieldType.nickname) {
          final count = await countUserByNick(value);

          if (count != 0) {
            return 'Not available';
          }
        }

        return null;
      },
      textAlign: (type == AsyncProfileFieldType.nickname) ? TextAlign.start : TextAlign.center,
      showPrefix: false,
      decoration: (AsyncText value, nickCon) => InputDecoration(
        hintText: type.name,
        enabledBorder: 1.bs.c(Colors.transparent).out,
        prefix: (type == AsyncProfileFieldType.nickname) ? Text('${type.name} : @ ') : null,
        suffixIcon: (value.error != null || text == nickCon.text)
            ? const Icon(Icons.edit)
            : IconButton(
                icon: const Icon(Icons.done),
                onPressed: () {
                  if (type == AsyncProfileFieldType.nickname) {
                    callUserUpdate(User(nick: nickCon.text));
                  }
                  if (type == AsyncProfileFieldType.displayName) {
                    callUserUpdate(User(displayName: nickCon.text));
                  }
                },
              ),
      ),
      textInputAction: TextInputAction.done,
      onSubmit: (value) {
        if (type == AsyncProfileFieldType.nickname) {
          callUserUpdate(User(nick: value));
        }
        if (type == AsyncProfileFieldType.displayName) {
          callUserUpdate(User(displayName: value));
        }
      },
    );
  }
}

Map<String, dynamic>? jwtParse(String? refreshToken) {
  final jwt = refreshToken?.split('.');
  if (jwt != null && jwt.length > 1) {
    String token = jwt[1];
    int l = 4 - (token.length % 4);
    token += List.generate(l, (index) => '=').join();
    final decoded = base64.decode(token);
    token = utf8.decode(decoded);
    return json.decode(token) as Map<String, dynamic>;
  }
  return null;
}
