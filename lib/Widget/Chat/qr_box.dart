import 'dart:io';
import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:moonspace/Helper/extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Providers/tweets.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/Chat/send_box.dart';

class QrBox extends StatelessWidget {
  const QrBox({
    super.key,
    required this.codeQrtext,
    this.repaintKey,
  });

  final String codeQrtext;
  final GlobalKey? repaintKey;
  @override
  Widget build(BuildContext context) {
    final code =
        BarcodeType.values.where((element) => element.name == (codeQrtext.split('||').firstOrNull ?? '')).firstOrNull ??
            BarcodeType.QrCode;
    final qrText = codeQrtext.split('||').lastOrNull ?? '';

    return Column(
      children: [
        qrText.isEmpty
            ? SizedBox(
                width: context.mq.w,
                height: context.mq.w,
                child: Center(
                  child: Icon(
                    Icons.qr_code_rounded,
                    size: context.mq.w,
                  ),
                ),
              )
            : RepaintBoundary(
                key: repaintKey,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: BarcodeWidget(
                      barcode: code == BarcodeType.QrCode
                          ? Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.high)
                          : Barcode.fromType(code),
                      padding: const EdgeInsets.all(8),
                      // margin: EdgeInsets.all(4),
                      errorBuilder: (context, error) => Placeholder(
                        color: const Color.fromARGB(255, 255, 232, 235),
                        child: Center(
                          child: Text(
                            error,
                            style: const TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ),
                      ),
                      data: qrText,
                      // width: context.mq.w,
                      // height: context.mq.w,
                      // backgroundColor: AppTheme.darkness ? Colors.black : Colors.white,
                      color: AppTheme.darkness ? Colors.white : Colors.black, // AppTheme.seedColor,
                    ),
                  ),
                ),
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
    final barcodeType = useState(BarcodeType.QrCode);
    final repaintKey = GlobalKey();

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
                            text: '${barcodeType.value.name}||${qrtext.value}',
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
                    QrBox(
                      repaintKey: repaintKey,
                      codeQrtext: '${barcodeType.value.name}||${qrtext.value}',
                    ),

//
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            value: barcodeType.value,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.zero,
                            ),
                            alignment: Alignment.center,
                            items: BarcodeType.values
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.name),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                barcodeType.value = value;
                              }
                            },
                          ),
                        ),
                        if (qrtext.value.isNotEmpty)
                          OutlinedButton(
                            onPressed: () async {
                              RenderRepaintBoundary boundary =
                                  repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
                              var image = await boundary.toImage(pixelRatio: 1 + (qrtext.value.length ~/ 120) / 10);
                              var byteData = await image.toByteData(format: ImageByteFormat.png);
                              var pngBytes = byteData?.buffer.asUint8List();
                              final directory = await getDownloadsDirectory();

                              await File('${directory?.path}/my_image.png').writeAsBytes(pngBytes as List<int>);
                              // await ref.putData(
                              //   await imageFile.readAsBytes(),
                              //   SettableMetadata(contentType: "image/jpeg"),
                              // );
                            },
                            child: const Text('Download'),
                          ),
                      ],
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
