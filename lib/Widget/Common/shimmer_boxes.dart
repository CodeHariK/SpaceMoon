import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';
import 'package:moonspace/helper/extensions/list.dart';

import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

List<String> blurHashes = [
  'LOHTN|}wItIq~B^PnTNKo{tPs;s;',
  'L8DIL;5M00xITjx04m-r02WV~WNX',
  'LbDm,SMwITxv~VM|Ips-?cRjRPoz',
  'L17AxV\$%100#}W4pKO9b.7t7-V9]',
  'LO6Iw9tVp0RNOxS,a\$ngVqtTV?XA',
  'L7Db:6T24T}U00-r.A9Y}U{v;eF|',
  'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
  'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.',
  'L6PZfSi_.AyE_3t7t7R**0o#DgR4',
];

class CustomCacheImage extends StatelessWidget {
  const CustomCacheImage({
    super.key,
    required this.imageUrl,
    this.blurHash,
    this.radius = 0,
    this.showError = false,
  });

  final String imageUrl;
  final String? blurHash;
  final double radius;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
          cacheManager: CacheManager(
            Config(
              "cache",
              stalePeriod: const Duration(days: 3600),
            ),
          ),
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) => showError
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: kDebugMode ? Text(error.toString()) : const Placeholder(),
                  ),
                )
              : BlurHash(hash: (blurHash != null) ? blurHash! : blurHashes.getHashOne(imageUrl)),
          progressIndicatorBuilder: (context, url, DownloadProgress progress) {
            return Stack(
              children: [
                BlurHash(hash: (blurHash != null) ? blurHash! : blurHashes.getHashOne(imageUrl)),
                // Center(
                //   child: CircularProgressIndicator(
                //     value: progress.progress ?? 1,
                //   ),
                // ),
              ],
            ).animate(
              onPlay: (controller) {
                controller.repeat();
              },
            ).shimmer(
              delay: 1500.ms,
              duration: 1500.ms,
              curve: Curves.decelerate,
              angle: 1,
            );
          },
          imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    // colorFilter: const ColorFilter.mode(
                    //   Colors.red,
                    //   BlendMode.colorBurn,
                    // ),
                  ),
                ),
              )
          // .animate()
          // .scale(
          //       duration: 300.ms,
          //       begin: const Offset(1.25, 1.25),
          //       end: const Offset(1, 1),
          //     ),
          ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.isLoading,
    required this.child,
    required this.loadingChild,
  });

  final bool isLoading;
  final Widget child;
  final Widget loadingChild;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? loadingChild.animate(
            onPlay: (controller) {
              controller.repeat();
            },
          ).shimmer(
            delay: 1500.ms,
            duration: 1500.ms,
            curve: Curves.decelerate,
            angle: 1,
          )
        : child;
  }
}
