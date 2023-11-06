import 'dart:io';
import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/Chat/send_box.dart';

class QrBox extends StatelessWidget {
  const QrBox({
    super.key,
    required this.qrtext,
  });

  final String qrtext;

  @override
  Widget build(BuildContext context) {
    // double size = (qrtext.length > 1250 ? 2 : qrtext.length ~/ 500) * 150 + 200;

    final repaintKey = GlobalKey();

    return Column(
      children: [
        RepaintBoundary(
          key: repaintKey,
          child: BarcodeWidget(
            barcode: Barcode.qrCode(
              errorCorrectLevel: BarcodeQRCorrectionLevel.high,
            ),
            padding: const EdgeInsets.all(12),
            // margin: EdgeInsets.all(4),
            errorBuilder: (context, error) => Center(
              child: Text(
                error,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            data: qrtext,
            width: context.mq.w,
            height: context.mq.w,
            // decoration: BoxDecoration(
            //   border: Border.all(
            //     color: Colors.yellow,
            //     width: 3,
            //   ),
            // ),
            color: AppTheme.seedColor,
          ),
        ),
        IconButton.filledTonal(
          onPressed: () async {
            RenderRepaintBoundary boundary = repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
            var image = await boundary.toImage();
            var byteData = await image.toByteData(format: ImageByteFormat.png);
            var pngBytes = byteData?.buffer.asUint8List();
            print(pngBytes);
            final file = await File('my_image.png').writeAsBytes(pngBytes as List<int>);
            // await ref.putData(
            //   await imageFile.readAsBytes(),
            //   SettableMetadata(contentType: "image/jpeg"),
            // );
          },
          icon: const Icon(Icons.download),
        ),
      ],
    );
  }
}

class QrDialog extends HookWidget {
  const QrDialog({
    super.key,
    required this.roomUser,
  });

  final RoomUser roomUser;

  @override
  Widget build(BuildContext context) {
    final qrtext = useState('');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Qr'),
          bottom: const TabBar.secondary(
            tabs: [
              Tab(text: 'Generate'),
              Tab(text: 'Scan'),
            ],
          ),
        ),
        floatingActionButton: (qrtext.value.isEmpty)
            ? null
            : Consumer(
                builder: (context, ref, child) => FloatingActionButton(
                  onPressed: () {
                    ref.read(tweetsProvider.notifier).sendTweet(
                          tweet: Tweet(
                            text: qrtext.value,
                            mediaType: MediaType.QR,
                          ),
                        );
                    context.pop();
                  },
                  child: const Icon(Icons.send),
                ),
              ),
        body: Padding(
          padding: const EdgeInsets.all(2.0),
          child: TabBarView(
            children: [
              //
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [
                    //
                    if (qrtext.value.isEmpty)
                      SizedBox(
                        width: context.mq.w,
                        height: context.mq.w,
                        child: Center(
                          child: Icon(
                            Icons.qr_code_rounded,
                            size: context.mq.w,
                          ),
                        ),
                      ),
                    if (qrtext.value.isNotEmpty)
                      QrBox(
                        qrtext: qrtext.value,
                      ),
                    //
                    SendBox(
                      roomUser: roomUser,
                      onChanged: (value) {
                        qrtext.value = value;
                      },
                      mediaType: MediaType.QR,
                    ),
                  ],
                ),
              ),

              //
              // BarcodeScannerView(),
              SingleChildScrollView(
                child: Column(
                  children: [
                    //
                    GestureDetector(
                      onTap: () {},
                      child: const AspectRatio(
                        aspectRatio: 1,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Icon(Icons.qr_code_scanner_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
