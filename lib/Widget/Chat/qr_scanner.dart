import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:moonspace/helper/extensions/theme_ext.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  Barcode? barcode;
  BarcodeCapture? capture;
  MobileScannerArguments? arguments;

  late final AnimationController animCon;

  @override
  void initState() {
    animCon = AnimationController(vsync: this, duration: const Duration(milliseconds: 4000))..repeat();
    super.initState();
  }

  @override
  void dispose() {
    animCon.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 'GalleryQr',
        onPressed: () async {
          final image = await ImagePicker().pickImage(source: ImageSource.gallery);

          if (image?.path != null) {
            final result = await controller.analyzeImage(image!.path);
            if (mounted && result == false) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No Code Found')),
              );
            }
          }
        },
        child: const Icon(Icons.photo),
      ),
      bottomNavigationBar: (barcode == null)
          ? null
          : DraggableScrollableSheet(
              expand: false,
              minChildSize: (barcode != null) ? 0.2 : 0,
              initialChildSize: (barcode != null) ? 0.4 : 0,
              maxChildSize: .8,
              snapSizes: const [0.2, 0.4, 0.6, 0.8],
              builder: (context, scrollController) {
                return Scaffold(
                  floatingActionButton: FloatingActionButton.small(
                    heroTag: 'CopyQr',
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: barcode!.displayValue!),
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copied to Clipboard')),
                        );
                      }
                    },
                    child: const Icon(Icons.copy),
                  ),
                  body: CustomScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        leading: const SizedBox(),
                        title: Text('${capture!.barcodes.length} match found'),
                        pinned: true,
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: SelectableText(
                            barcode!.displayValue.toString(),
                            style: context.bl,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scanWindow = Rect.fromCenter(
            center: constraints.biggest.center(Offset.zero),
            width: 300,
            height: 300,
          );

          return Stack(
            children: [
              MobileScanner(
                scanWindow: scanWindow,
                controller: controller,
                onScannerStarted: (arguments) {
                  this.arguments = arguments;
                  setState(() {});
                },
                errorBuilder: (context, error, child) {
                  return ScannerErrorWidget(error: error);
                },
                onDetect: (BarcodeCapture capture) async {
                  this.capture = capture;
                  setState(() => barcode = capture.barcodes.first);
                },
                overlay: Center(
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Icon(
                        Icons.qr_code_scanner_rounded,
                        color: context.theme.pri.withAlpha(120),
                      ),
                    ),
                  ),
                ),
              ),
              if (barcode != null && barcode?.corners != null && arguments != null)
                CustomPaint(
                  painter: BarcodeOverlay(
                    barcode: barcode!,
                    arguments: arguments!,
                    boxFit: BoxFit.contain,
                    capture: capture!,
                  ),
                ),
              // const ScanningPainter(),
              // const PolygonPainter(),
              CustomPaint(painter: ScannerOverlay(scanWindow, animCon)),
            ],
          );
        },
      ),
    );
  }
}

class BarcodeOverlay extends CustomPainter {
  BarcodeOverlay({
    required this.barcode,
    required this.arguments,
    required this.boxFit,
    required this.capture,
  });

  final BarcodeCapture capture;
  final Barcode barcode;
  final MobileScannerArguments arguments;
  final BoxFit boxFit;

  @override
  void paint(Canvas canvas, Size size) {
    if (barcode.corners.isEmpty) {
      return;
    }

    final adjustedSize = applyBoxFit(boxFit, arguments.size, size);

    double verticalPadding = size.height - adjustedSize.destination.height;
    double horizontalPadding = size.width - adjustedSize.destination.width;
    if (verticalPadding > 0) {
      verticalPadding = verticalPadding / 2;
    } else {
      verticalPadding = 0;
    }

    if (horizontalPadding > 0) {
      horizontalPadding = horizontalPadding / 2;
    } else {
      horizontalPadding = 0;
    }

    final double ratioWidth;
    final double ratioHeight;

    if (!kIsWeb && Platform.isIOS) {
      ratioWidth = capture.size.width / adjustedSize.destination.width;
      ratioHeight = capture.size.height / adjustedSize.destination.height;
    } else {
      ratioWidth = arguments.size.width / adjustedSize.destination.width;
      ratioHeight = arguments.size.height / adjustedSize.destination.height;
    }

    final List<Offset> adjustedOffset = [];
    for (final offset in barcode.corners) {
      adjustedOffset.add(
        Offset(
          offset.dx / ratioWidth + horizontalPadding,
          offset.dy / ratioHeight + verticalPadding,
        ),
      );
    }
    final cutoutPath = Path()..addPolygon(adjustedOffset, true);

    final backgroundPaint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    canvas.drawPath(cutoutPath, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = 'Controller not ready.';
        break;
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = 'Permission denied';
        break;
      case MobileScannerErrorCode.unsupported:
        errorMessage = 'Scanning is unsupported on this device';
        break;
      default:
        errorMessage = 'Generic Error';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class ScannerOverlay extends CustomPainter {
  ScannerOverlay(this.scanWindow, this.animation) : super(repaint: animation);

  final Rect scanWindow;
  final double borderRadius = 12.0;
  final Animation animation;
  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()..addRect(Rect.largest);
    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          scanWindow,
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
          bottomLeft: Radius.circular(borderRadius),
          bottomRight: Radius.circular(borderRadius),
        ),
      );

    final Paint paint = Paint()..color = Colors.transparent;
    final progress = animation.value;
    if (progress > 0.0) {
      paint.color = Colors.black;
      paint.shader = SweepGradient(
        colors: Colors.primaries.take(15).toList(),
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: GradientRotation(math.pi * 2 * progress),
      ).createShader(scanWindow);
    }

    final backgroundPaint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.dstOut;

    final backgroundWithCutout = Path.combine(
      PathOperation.difference,
      backgroundPath,
      cutoutPath,
    );

    // Create a Paint object for the white border
    // final borderPaint = Paint()
    //   ..color = Colors.white
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 4.0; // Adjust the border width as needed

    // Calculate the border rectangle with rounded corners
// Adjust the radius as needed
    final borderRect = RRect.fromRectAndCorners(
      scanWindow,
      topLeft: Radius.circular(borderRadius),
      topRight: Radius.circular(borderRadius),
      bottomLeft: Radius.circular(borderRadius),
      bottomRight: Radius.circular(borderRadius),
    );

    // Draw the white border
    canvas.drawPath(backgroundWithCutout, backgroundPaint);
    // canvas.drawRRect(borderRect, borderPaint);

    final path = Path.combine(
      PathOperation.xor,
      Path()..addRRect(borderRect),
      Path()..addRRect(borderRect.deflate(4.0)),
    );
    canvas.drawPath(path, paint);

    final textSpan = TextSpan(
      text: 'Scan',
      style: TextStyle(foreground: paint, fontSize: 30),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: 100,
    );
    textPainter.paint(
      canvas,
      scanWindow.topCenter + Offset(-textPainter.size.width / 2, -40),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => oldDelegate != this;
}
