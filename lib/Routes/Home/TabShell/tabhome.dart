import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moonspace/form/async_text_field.dart';
import 'package:moonspace/helper/extensions/color.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:moonspace/widgets/shimmer_boxes.dart';
import 'package:spacemoon/Helpers/shell_data.dart';

import 'package:http/http.dart' as http;

final GlobalKey<NavigatorState> tabShellNavigatorKey = GlobalKey<NavigatorState>();

class TabShellRoute extends ShellRouteData {
  const TabShellRoute();

  static final GlobalKey<NavigatorState> $navigatorKey = tabShellNavigatorKey;

  static List<ShellData> data = [
    ShellData(name: 'Tab1', location: '/tabhome/tab1', icon: const Icon(Icons.mode_of_travel)),
    ShellData(name: 'Tab2', location: '/tabhome/tab2', icon: const Icon(Icons.face_2_outlined)),
  ];

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            TabShellRoute.data.tabBar(context),
            Expanded(
              child: navigator,
            ),
          ],
        ),
      ),
    );
  }
}

// class TabHomeRoute extends GoRouteData {
//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     return const TabHomePage();
//   }

//   @override
//   FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
//     return '/tabhome/tab1';
//   }
// }

// class TabHomePage extends StatelessWidget {
//   const TabHomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('TabHome'),
//       ),
//       body: const Column(
//         children: [],
//       ),
//     );
//   }
// }

class Tab1Route extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Tab1Page();
  }
}

class Tab1Page extends StatefulWidget {
  const Tab1Page({super.key});

  @override
  State<Tab1Page> createState() => _Tab1PageState();
}

class _Tab1PageState extends State<Tab1Page> {
  int page = 1;
  String query = 'krishna';
  Unsplash? res;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  Future<void> fetch() async {
    final r = await http.get(Uri.parse(
        'https://api.unsplash.com/search/photos?page=$page&query=$query&orientation=portrait&client_id=i2I0ZoWiW1efbC6m-hc9aSfJJk7DnhQixKWhhDdq5Bo'));
    res = Unsplash.fromJson(r.body);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab1'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AsyncTextFormField(
              asyncValidator: (value) async {
                query = value;
                page = 1;
                await fetch();
                return null;
              },
            ),
          ),
        ),
      ),
      body: res == null ? null : Grid(res),
      // body: res == null ? null : UnslashRow(res),
      extendBody: true,
      bottomNavigationBar: SizedBox(height: context.mq.pad.bottom),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          page += 1;
          fetch();
        },
        child: const Icon(
          Icons.fence,
        ),
      ),
    );
  }
}

class UnslashRow extends StatelessWidget {
  const UnslashRow(
    this.res, {
    super.key,
  });

  final Unsplash? res;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: PageView.builder(
            controller: PageController(viewportFraction: .8),
            itemCount: res?.results?.length,
            itemBuilder: (context, index) {
              final e = res?.results?[index];
              final url = e?.urls?.small ?? e?.urls?.regular ?? e?.urls?.full;

              if (e == null || url == null) return const Placeholder();
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 1,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                margin: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: e.id!,
                  child: CustomCacheImage(
                    imageUrl: url,
                    radius: 12,
                    blurHash: e.blurHash,
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            res?.results?.length ?? 0,
            (index) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey,
              ),
              width: 12,
              height: 12,
              margin: const EdgeInsets.all(8),
            ),
          ),
        ),
      ],
    );
  }
}

class Grid extends StatelessWidget {
  const Grid(
    this.res, {
    super.key,
  });

  final Unsplash? res;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 2,
      children: res?.results?.map(
            (e) {
              final url = e.urls?.small ?? e.urls?.regular ?? e.urls?.full;
              if (url != null) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        fullscreenDialog: true,
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return Scaffold(
                            appBar: AppBar(),
                            body: Stack(
                              children: [
                                Hero(
                                  tag: e.id!,
                                  child: InteractiveViewer(
                                    child: CustomCacheImage(
                                      imageUrl: url,
                                      // blurHash: e.blurHash,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: const [0, 1],
                                      colors: [
                                        (HexColor(e.color ?? '#ffffff')),
                                        (HexColor(e.color ?? '#ffffff')).withAlpha(0),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (e.description != null || (e.description?.isNotEmpty ?? false))
                                        Text(
                                          e.description.toString().toUpperCase(),
                                          style: context.hs.c(HexColor(e.color ?? '#ffffff').mop),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      if (e.altDescription != null || (e.altDescription?.isNotEmpty ?? false))
                                        Text(
                                          e.altDescription.toString().toUpperCase(),
                                          style: context.tm.c(HexColor(e.color ?? '#ffffff').mop),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Hero(
                    tag: e.id!,
                    child: CustomCacheImage(
                      imageUrl: url,
                      blurHash: e.blurHash,
                    ),
                  ),
                );
              } else {
                return const Placeholder();
              }
            },
          ).toList() ??
          [],
    );
  }
}

class Tab2Route extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Tab2Page();
  }
}

class Tab2Page extends StatelessWidget {
  const Tab2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tab2'),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}

class Unsplash {
  final int? total;
  final int? totalPages;
  final List<Result>? results;

  Unsplash({
    this.total,
    this.totalPages,
    this.results,
  });

  factory Unsplash.fromJson(String str) => Unsplash.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Unsplash.fromMap(Map<String, dynamic> json) => Unsplash(
        total: json["total"],
        totalPages: json["total_pages"],
        results: json["results"] == null ? [] : List<Result>.from(json["results"]!.map((x) => Result.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "total_pages": totalPages,
        "results": results == null ? [] : List<dynamic>.from(results!.map((x) => x.toMap())),
      };
}

class Result {
  final String? id;
  final String? slug;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? promotedAt;
  final int? width;
  final int? height;
  final String? color;
  final String? blurHash;
  final String? description;
  final String? altDescription;
  final List<Breadcrumb>? breadcrumbs;
  final Urls? urls;
  final ResultLinks? links;
  final int? likes;
  final bool? likedByUser;
  final List<dynamic>? currentUserCollections;
  final dynamic sponsorship;
  final ResultTopicSubmissions? topicSubmissions;
  final ResultUser? user;
  final List<Tag>? tags;

  Result({
    this.id,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.promotedAt,
    this.width,
    this.height,
    this.color,
    this.blurHash,
    this.description,
    this.altDescription,
    this.breadcrumbs,
    this.urls,
    this.links,
    this.likes,
    this.likedByUser,
    this.currentUserCollections,
    this.sponsorship,
    this.topicSubmissions,
    this.user,
    this.tags,
  });

  factory Result.fromJson(String str) => Result.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        id: json["id"],
        slug: json["slug"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        promotedAt: json["promoted_at"] == null ? null : DateTime.parse(json["promoted_at"]),
        width: json["width"],
        height: json["height"],
        color: json["color"],
        blurHash: json["blur_hash"],
        description: json["description"],
        altDescription: json["alt_description"],
        breadcrumbs: json["breadcrumbs"] == null
            ? []
            : List<Breadcrumb>.from(json["breadcrumbs"]!.map((x) => Breadcrumb.fromMap(x))),
        urls: json["urls"] == null ? null : Urls.fromMap(json["urls"]),
        links: json["links"] == null ? null : ResultLinks.fromMap(json["links"]),
        likes: json["likes"],
        likedByUser: json["liked_by_user"],
        currentUserCollections: json["current_user_collections"] == null
            ? []
            : List<dynamic>.from(json["current_user_collections"]!.map((x) => x)),
        sponsorship: json["sponsorship"],
        topicSubmissions:
            json["topic_submissions"] == null ? null : ResultTopicSubmissions.fromMap(json["topic_submissions"]),
        user: json["user"] == null ? null : ResultUser.fromMap(json["user"]),
        tags: json["tags"] == null ? [] : List<Tag>.from(json["tags"]!.map((x) => Tag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "slug": slug,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "promoted_at": promotedAt?.toIso8601String(),
        "width": width,
        "height": height,
        "color": color,
        "blur_hash": blurHash,
        "description": description,
        "alt_description": altDescription,
        "breadcrumbs": breadcrumbs == null ? [] : List<dynamic>.from(breadcrumbs!.map((x) => x.toMap())),
        "urls": urls?.toMap(),
        "links": links?.toMap(),
        "likes": likes,
        "liked_by_user": likedByUser,
        "current_user_collections":
            currentUserCollections == null ? [] : List<dynamic>.from(currentUserCollections!.map((x) => x)),
        "sponsorship": sponsorship,
        "topic_submissions": topicSubmissions?.toMap(),
        "user": user?.toMap(),
        "tags": tags == null ? [] : List<dynamic>.from(tags!.map((x) => x.toMap())),
      };
}

class Breadcrumb {
  final String? slug;
  final String? title;
  final int? index;
  final UnsplashType? type;

  Breadcrumb({
    this.slug,
    this.title,
    this.index,
    this.type,
  });

  factory Breadcrumb.fromJson(String str) => Breadcrumb.fromMap(json.decode(str));

  @override
  String toString() => json.encode(toMap());

  factory Breadcrumb.fromMap(Map<String, dynamic> json) => Breadcrumb(
        slug: json["slug"],
        title: json["title"],
        index: json["index"],
        type: UnsplashType.values.where((element) => element.name == json["type"]).firstOrNull,
      );

  Map<String, dynamic> toMap() => {
        "slug": slug,
        "title": title,
        "index": index,
        "type": type?.name,
      };
}

enum UnsplashType { landingPage, search }

class ResultLinks {
  final String? self;
  final String? html;
  final String? download;
  final String? downloadLocation;

  ResultLinks({
    this.self,
    this.html,
    this.download,
    this.downloadLocation,
  });

  factory ResultLinks.fromJson(String str) => ResultLinks.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultLinks.fromMap(Map<String, dynamic> json) => ResultLinks(
        self: json["self"],
        html: json["html"],
        download: json["download"],
        downloadLocation: json["download_location"],
      );

  Map<String, dynamic> toMap() => {
        "self": self,
        "html": html,
        "download": download,
        "download_location": downloadLocation,
      };
}

class Tag {
  final UnsplashType? type;
  final String? title;
  final Source? source;

  Tag({
    this.type,
    this.title,
    this.source,
  });

  factory Tag.fromJson(String str) => Tag.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Tag.fromMap(Map<String, dynamic> json) => Tag(
        type: UnsplashType.values.where((element) => element.name == json["type"]).firstOrNull,
        title: json["title"],
        source: json["source"] == null ? null : Source.fromMap(json["source"]),
      );

  Map<String, dynamic> toMap() => {
        "type": type?.name,
        "title": title,
        "source": source?.toMap(),
      };
}

class Source {
  final Ancestry? ancestry;
  final String? title;
  final String? subtitle;
  final String? description;
  final String? metaTitle;
  final String? metaDescription;
  final CoverPhoto? coverPhoto;

  Source({
    this.ancestry,
    this.title,
    this.subtitle,
    this.description,
    this.metaTitle,
    this.metaDescription,
    this.coverPhoto,
  });

  factory Source.fromJson(String str) => Source.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Source.fromMap(Map<String, dynamic> json) => Source(
        ancestry: json["ancestry"] == null ? null : Ancestry.fromMap(json["ancestry"]),
        title: json["title"],
        subtitle: json["subtitle"],
        description: json["description"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        coverPhoto: json["cover_photo"] == null ? null : CoverPhoto.fromMap(json["cover_photo"]),
      );

  Map<String, dynamic> toMap() => {
        "ancestry": ancestry?.toMap(),
        "title": title,
        "subtitle": subtitle,
        "description": description,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "cover_photo": coverPhoto?.toMap(),
      };
}

class Ancestry {
  final Category? type;
  final Category? category;
  final Category? subcategory;

  Ancestry({
    this.type,
    this.category,
    this.subcategory,
  });

  factory Ancestry.fromJson(String str) => Ancestry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ancestry.fromMap(Map<String, dynamic> json) => Ancestry(
        type: json["type"] == null ? null : Category.fromMap(json["type"]),
        category: json["category"] == null ? null : Category.fromMap(json["category"]),
        subcategory: json["subcategory"] == null ? null : Category.fromMap(json["subcategory"]),
      );

  Map<String, dynamic> toMap() => {
        "type": type?.toMap(),
        "category": category?.toMap(),
        "subcategory": subcategory?.toMap(),
      };
}

class Category {
  final String? slug;
  final String? prettySlug;

  Category({
    this.slug,
    this.prettySlug,
  });

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        slug: json["slug"],
        prettySlug: json["pretty_slug"],
      );

  Map<String, dynamic> toMap() => {
        "slug": slug,
        "pretty_slug": prettySlug,
      };
}

class CoverPhoto {
  final String? id;
  final String? slug;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? promotedAt;
  final int? width;
  final int? height;
  final String? color;
  final String? blurHash;
  final String? description;
  final String? altDescription;
  final List<Breadcrumb>? breadcrumbs;
  final Urls? urls;
  final ResultLinks? links;
  final int? likes;
  final bool? likedByUser;
  final List<dynamic>? currentUserCollections;
  final dynamic sponsorship;
  final CoverPhotoTopicSubmissions? topicSubmissions;
  final bool? premium;
  final bool? plus;
  final CoverPhotoUser? user;

  CoverPhoto({
    this.id,
    this.slug,
    this.createdAt,
    this.updatedAt,
    this.promotedAt,
    this.width,
    this.height,
    this.color,
    this.blurHash,
    this.description,
    this.altDescription,
    this.breadcrumbs,
    this.urls,
    this.links,
    this.likes,
    this.likedByUser,
    this.currentUserCollections,
    this.sponsorship,
    this.topicSubmissions,
    this.premium,
    this.plus,
    this.user,
  });

  factory CoverPhoto.fromJson(String str) => CoverPhoto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CoverPhoto.fromMap(Map<String, dynamic> json) => CoverPhoto(
        id: json["id"],
        slug: json["slug"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        promotedAt: json["promoted_at"] == null ? null : DateTime.parse(json["promoted_at"]),
        width: json["width"],
        height: json["height"],
        color: json["color"],
        blurHash: json["blur_hash"],
        description: json["description"],
        altDescription: json["alt_description"],
        breadcrumbs: json["breadcrumbs"] == null
            ? []
            : List<Breadcrumb>.from(json["breadcrumbs"]!.map((x) => Breadcrumb.fromMap(x))),
        urls: json["urls"] == null ? null : Urls.fromMap(json["urls"]),
        links: json["links"] == null ? null : ResultLinks.fromMap(json["links"]),
        likes: json["likes"],
        likedByUser: json["liked_by_user"],
        currentUserCollections: json["current_user_collections"] == null
            ? []
            : List<dynamic>.from(json["current_user_collections"]!.map((x) => x)),
        sponsorship: json["sponsorship"],
        topicSubmissions:
            json["topic_submissions"] == null ? null : CoverPhotoTopicSubmissions.fromMap(json["topic_submissions"]),
        premium: json["premium"],
        plus: json["plus"],
        user: json["user"] == null ? null : CoverPhotoUser.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "slug": slug,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "promoted_at": promotedAt?.toIso8601String(),
        "width": width,
        "height": height,
        "color": color,
        "blur_hash": blurHash,
        "description": description,
        "alt_description": altDescription,
        "breadcrumbs": breadcrumbs == null ? [] : List<dynamic>.from(breadcrumbs!.map((x) => x.toMap())),
        "urls": urls?.toMap(),
        "links": links?.toMap(),
        "likes": likes,
        "liked_by_user": likedByUser,
        "current_user_collections":
            currentUserCollections == null ? [] : List<dynamic>.from(currentUserCollections!.map((x) => x)),
        "sponsorship": sponsorship,
        "topic_submissions": topicSubmissions?.toMap(),
        "premium": premium,
        "plus": plus,
        "user": user?.toMap(),
      };
}

class CoverPhotoTopicSubmissions {
  final Wallpapers? texturesPatterns;
  final Wallpapers? animals;

  CoverPhotoTopicSubmissions({
    this.texturesPatterns,
    this.animals,
  });

  factory CoverPhotoTopicSubmissions.fromJson(String str) => CoverPhotoTopicSubmissions.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CoverPhotoTopicSubmissions.fromMap(Map<String, dynamic> json) => CoverPhotoTopicSubmissions(
        texturesPatterns: json["textures-patterns"] == null ? null : Wallpapers.fromMap(json["textures-patterns"]),
        animals: json["animals"] == null ? null : Wallpapers.fromMap(json["animals"]),
      );

  Map<String, dynamic> toMap() => {
        "textures-patterns": texturesPatterns?.toMap(),
        "animals": animals?.toMap(),
      };
}

class Wallpapers {
  final String? status;
  final DateTime? approvedOn;

  Wallpapers({
    this.status,
    this.approvedOn,
  });

  factory Wallpapers.fromJson(String str) => Wallpapers.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Wallpapers.fromMap(Map<String, dynamic> json) => Wallpapers(
        status: json["status"],
        approvedOn: json["approved_on"] == null ? null : DateTime.parse(json["approved_on"]),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "approved_on": approvedOn?.toIso8601String(),
      };
}

class Urls {
  final String? raw;
  final String? full;
  final String? regular;
  final String? small;
  final String? thumb;
  final String? smallS3;

  Urls({
    this.raw,
    this.full,
    this.regular,
    this.small,
    this.thumb,
    this.smallS3,
  });

  factory Urls.fromJson(String str) => Urls.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Urls.fromMap(Map<String, dynamic> json) => Urls(
        raw: json["raw"],
        full: json["full"],
        regular: json["regular"],
        small: json["small"],
        thumb: json["thumb"],
        smallS3: json["small_s3"],
      );

  Map<String, dynamic> toMap() => {
        "raw": raw,
        "full": full,
        "regular": regular,
        "small": small,
        "thumb": thumb,
        "small_s3": smallS3,
      };
}

class CoverPhotoUser {
  final String? id;
  final DateTime? updatedAt;
  final String? username;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? twitterUsername;
  final String? portfolioUrl;
  final String? bio;
  final String? location;
  final UserLinks? links;
  final ProfileImage? profileImage;
  final String? instagramUsername;
  final int? totalCollections;
  final int? totalLikes;
  final int? totalPhotos;
  final bool? acceptedTos;
  final bool? forHire;
  final Social? social;

  CoverPhotoUser({
    this.id,
    this.updatedAt,
    this.username,
    this.name,
    this.firstName,
    this.lastName,
    this.twitterUsername,
    this.portfolioUrl,
    this.bio,
    this.location,
    this.links,
    this.profileImage,
    this.instagramUsername,
    this.totalCollections,
    this.totalLikes,
    this.totalPhotos,
    this.acceptedTos,
    this.forHire,
    this.social,
  });

  factory CoverPhotoUser.fromJson(String str) => CoverPhotoUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CoverPhotoUser.fromMap(Map<String, dynamic> json) => CoverPhotoUser(
        id: json["id"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        username: json["username"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        twitterUsername: json["twitter_username"],
        portfolioUrl: json["portfolio_url"],
        bio: json["bio"],
        location: json["location"],
        links: json["links"] == null ? null : UserLinks.fromMap(json["links"]),
        profileImage: json["profile_image"] == null ? null : ProfileImage.fromMap(json["profile_image"]),
        instagramUsername: json["instagram_username"],
        totalCollections: json["total_collections"],
        totalLikes: json["total_likes"],
        totalPhotos: json["total_photos"],
        acceptedTos: json["accepted_tos"],
        forHire: json["for_hire"],
        social: json["social"] == null ? null : Social.fromMap(json["social"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "updated_at": updatedAt?.toIso8601String(),
        "username": username,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "twitter_username": twitterUsername,
        "portfolio_url": portfolioUrl,
        "bio": bio,
        "location": location,
        "links": links?.toMap(),
        "profile_image": profileImage?.toMap(),
        "instagram_username": instagramUsername,
        "total_collections": totalCollections,
        "total_likes": totalLikes,
        "total_photos": totalPhotos,
        "accepted_tos": acceptedTos,
        "for_hire": forHire,
        "social": social?.toMap(),
      };
}

class UserLinks {
  final String? self;
  final String? html;
  final String? photos;
  final String? likes;
  final String? portfolio;
  final String? following;
  final String? followers;

  UserLinks({
    this.self,
    this.html,
    this.photos,
    this.likes,
    this.portfolio,
    this.following,
    this.followers,
  });

  factory UserLinks.fromJson(String str) => UserLinks.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserLinks.fromMap(Map<String, dynamic> json) => UserLinks(
        self: json["self"],
        html: json["html"],
        photos: json["photos"],
        likes: json["likes"],
        portfolio: json["portfolio"],
        following: json["following"],
        followers: json["followers"],
      );

  Map<String, dynamic> toMap() => {
        "self": self,
        "html": html,
        "photos": photos,
        "likes": likes,
        "portfolio": portfolio,
        "following": following,
        "followers": followers,
      };
}

class ProfileImage {
  final String? small;
  final String? medium;
  final String? large;

  ProfileImage({
    this.small,
    this.medium,
    this.large,
  });

  factory ProfileImage.fromJson(String str) => ProfileImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProfileImage.fromMap(Map<String, dynamic> json) => ProfileImage(
        small: json["small"],
        medium: json["medium"],
        large: json["large"],
      );

  Map<String, dynamic> toMap() => {
        "small": small,
        "medium": medium,
        "large": large,
      };
}

class Social {
  final String? instagramUsername;
  final String? portfolioUrl;
  final String? twitterUsername;
  final dynamic paypalEmail;

  Social({
    this.instagramUsername,
    this.portfolioUrl,
    this.twitterUsername,
    this.paypalEmail,
  });

  factory Social.fromJson(String str) => Social.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Social.fromMap(Map<String, dynamic> json) => Social(
        instagramUsername: json["instagram_username"],
        portfolioUrl: json["portfolio_url"],
        twitterUsername: json["twitter_username"],
        paypalEmail: json["paypal_email"],
      );

  Map<String, dynamic> toMap() => {
        "instagram_username": instagramUsername,
        "portfolio_url": portfolioUrl,
        "twitter_username": twitterUsername,
        "paypal_email": paypalEmail,
      };
}

class ResultTopicSubmissions {
  final ArtsCulture? experimental;
  final ArtsCulture? artsCulture;
  final ArtsCulture? people;
  final ArtsCulture? technology;
  final Wallpapers? wallpapers;

  ResultTopicSubmissions({
    this.experimental,
    this.artsCulture,
    this.people,
    this.technology,
    this.wallpapers,
  });

  factory ResultTopicSubmissions.fromJson(String str) => ResultTopicSubmissions.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultTopicSubmissions.fromMap(Map<String, dynamic> json) => ResultTopicSubmissions(
        experimental: json["experimental"] == null ? null : ArtsCulture.fromMap(json["experimental"]),
        artsCulture: json["arts-culture"] == null ? null : ArtsCulture.fromMap(json["arts-culture"]),
        people: json["people"] == null ? null : ArtsCulture.fromMap(json["people"]),
        technology: json["technology"] == null ? null : ArtsCulture.fromMap(json["technology"]),
        wallpapers: json["wallpapers"] == null ? null : Wallpapers.fromMap(json["wallpapers"]),
      );

  Map<String, dynamic> toMap() => {
        "experimental": experimental?.toMap(),
        "arts-culture": artsCulture?.toMap(),
        "people": people?.toMap(),
        "technology": technology?.toMap(),
        "wallpapers": wallpapers?.toMap(),
      };
}

class ArtsCulture {
  final String? status;

  ArtsCulture({
    this.status,
  });

  factory ArtsCulture.fromJson(String str) => ArtsCulture.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ArtsCulture.fromMap(Map<String, dynamic> json) => ArtsCulture(
        status: json["status"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
      };
}

class ResultUser {
  final String? id;
  final DateTime? updatedAt;
  final String? username;
  final String? name;
  final String? firstName;
  final String? lastName;
  final String? twitterUsername;
  final String? portfolioUrl;
  final String? bio;
  final String? location;
  final UserLinks? links;
  final ProfileImage? profileImage;
  final String? instagramUsername;
  final int? totalCollections;
  final int? totalLikes;
  final int? totalPhotos;
  final int? totalPromotedPhotos;
  final bool? acceptedTos;
  final bool? forHire;
  final Social? social;

  ResultUser({
    this.id,
    this.updatedAt,
    this.username,
    this.name,
    this.firstName,
    this.lastName,
    this.twitterUsername,
    this.portfolioUrl,
    this.bio,
    this.location,
    this.links,
    this.profileImage,
    this.instagramUsername,
    this.totalCollections,
    this.totalLikes,
    this.totalPhotos,
    this.totalPromotedPhotos,
    this.acceptedTos,
    this.forHire,
    this.social,
  });

  factory ResultUser.fromJson(String str) => ResultUser.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ResultUser.fromMap(Map<String, dynamic> json) => ResultUser(
        id: json["id"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        username: json["username"],
        name: json["name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        twitterUsername: json["twitter_username"],
        portfolioUrl: json["portfolio_url"],
        bio: json["bio"],
        location: json["location"],
        links: json["links"] == null ? null : UserLinks.fromMap(json["links"]),
        profileImage: json["profile_image"] == null ? null : ProfileImage.fromMap(json["profile_image"]),
        instagramUsername: json["instagram_username"],
        totalCollections: json["total_collections"],
        totalLikes: json["total_likes"],
        totalPhotos: json["total_photos"],
        totalPromotedPhotos: json["total_promoted_photos"],
        acceptedTos: json["accepted_tos"],
        forHire: json["for_hire"],
        social: json["social"] == null ? null : Social.fromMap(json["social"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "updated_at": updatedAt?.toIso8601String(),
        "username": username,
        "name": name,
        "first_name": firstName,
        "last_name": lastName,
        "twitter_username": twitterUsername,
        "portfolio_url": portfolioUrl,
        "bio": bio,
        "location": location,
        "links": links?.toMap(),
        "profile_image": profileImage?.toMap(),
        "instagram_username": instagramUsername,
        "total_collections": totalCollections,
        "total_likes": totalLikes,
        "total_photos": totalPhotos,
        "total_promoted_photos": totalPromotedPhotos,
        "accepted_tos": acceptedTos,
        "for_hire": forHire,
        "social": social?.toMap(),
      };
}
