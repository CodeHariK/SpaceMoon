import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:moonspace/helper/extensions/string.dart';
import 'package:moonspace/helper/validator/debug_functions.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:moonspace/form/mario.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Static/theme.dart';
import 'package:spacemoon/Widget/Chat/qr_scanner.dart';
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 500),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: SizedBox(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BarcodeWidget(
                          barcode: code == BarcodeType.QrCode
                              ? Barcode.qrCode(errorCorrectLevel: BarcodeQRCorrectionLevel.high)
                              : Barcode.fromType(code),
                          padding: const EdgeInsets.all(8),
                          // margin: EdgeInsets.all(4),
                          backgroundColor: AppTheme.darkness ? Colors.black : Colors.white,
                          errorBuilder: (context, error) => SizedBox(
                            width: context.mq.w,
                            height: context.mq.w,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Icon(
                                  Icons.qr_code_rounded,
                                  size: context.mq.w,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.black87,
                                    border: Border.all(color: AppTheme.seedColor, width: 2),
                                  ),
                                  child: Text(
                                    error,
                                    style: context.hs.c(Colors.white),
                                  ),
                                ),
                              ],
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
        body: TabBarView(
          children: [
            //
            Scaffold(
              floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
              floatingActionButton: (qrtext.value.isEmpty)
                  ? null
                  : SendButton(
                      text: '${barcodeType.value.name}||${qrtext.value}',
                      mediaType: MediaType.QR,
                    ),
              body: SingleChildScrollView(
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
                              try {
                                RenderRepaintBoundary boundary =
                                    repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
                                var image = await boundary.toImage(pixelRatio: 1 + (qrtext.value.length ~/ 120) / 10);
                                var byteData = await image.toByteData(format: ImageByteFormat.png);
                                var pngBytes = byteData?.buffer.asUint8List();

                                if (context.mounted) {
                                  await saveToGallery(pngBytes, context, 'QrCodes');
                                }
                              } catch (e) {
                                lava(e);
                              }
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
            ),

            //
            Device.isMobile
                ? const QrScanner()
                : const Center(
                    child: Text('Scanner Not available'),
                  )
          ],
        ),
      ),
    );
  }
}

Future<void> saveToGallery(Uint8List? pngBytes, BuildContext context, String path) async {
  if (pngBytes != null) {
    final saved = await SaverGallery.saveImage(
      pngBytes,
      name: '${randomString(12)}.png',
      androidRelativePath: "Pictures/Spacemoon/$path/",
      androidExistNotSave: false,
    );
    if (context.mounted) {
      if (saved.isSuccess) {
        marioBar(context: context, content: 'Image saved');
      } else {
        marioBar(context: context, content: 'Error : Cannot Save image');
      }
    }
  }
}

class QrActionButton extends StatelessWidget {
  const QrActionButton({
    super.key,
    required this.roomUser,
  });

  final RoomUser roomUser;

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      icon: const Icon(Icons.qr_code_rounded),
      onPressed: () {
        context.rSlidePush(
          QrDialog(
            roomUser: roomUser,
          ),
        );
        AnimatedOverlay.hide();
      },
    );
  }
}
