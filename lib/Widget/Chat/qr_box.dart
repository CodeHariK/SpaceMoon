import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spacemoon/Gen/data.pb.dart';
import 'package:spacemoon/Widget/Chat/send_box.dart';

class QrBox extends StatelessWidget {
  const QrBox({
    super.key,
    required this.qrtext,
  });

  final String qrtext;

  @override
  Widget build(BuildContext context) {
    double size = (qrtext.length > 1250 ? 2 : qrtext.length ~/ 500) * 100 + 200;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: FlutterLogo(),
      // child: BarcodeWidget(
      //   barcode: Barcode.qrCode(
      //     errorCorrectLevel: BarcodeQRCorrectionLevel.high,
      //   ),
      //   padding: const EdgeInsets.all(16),
      //   // margin: EdgeInsets.all(4),
      //   errorBuilder: (context, error) => Center(
      //     child: Text(
      //       error,
      //       style: TextStyle(color: Colors.red),
      //     ),
      //   ),
      //   data: qrtext,
      //   width: size,
      //   height: size,
      //   // decoration: BoxDecoration(
      //   //   border: Border.all(
      //   //     color: Colors.yellow,
      //   //     width: 3,
      //   //   ),
      //   // ),
      //   color: Colors.black,
      //   backgroundColor: Colors.white,
      // ),
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
          title: Text('Qr'),
          bottom: TabBar.secondary(
            tabs: [
              Tab(text: 'Generate'),
              Tab(text: 'Scan'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            children: [
              //
              SingleChildScrollView(
                child: Column(
                  children: [
                    //
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (qrtext.value.isEmpty)
                          const SizedBox(
                            height: 300,
                            width: 300,
                            child: Center(
                              child: Text('Generate qr code'),
                            ),
                          ),
                        if (qrtext.value.isNotEmpty)
                          QrBox(
                            qrtext: qrtext.value,
                          ),

                        // Icon(Icons.heart_broken_rounded),

                        // Container(
                        //   color: Colors.white,
                        //   width: 60,
                        //   height: 60,
                        //   child: const FlutterLogo(),
                        // ),
                      ],
                    ),

                    //
                    Container(
                      height: 40,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Center(
                                child: Text('Hello'),
                              ),
                              onTap: () {
                                //
                              },
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              child: Center(
                                child: Text('Send'),
                              ),
                              onTap: () {
                                //
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    //
                    Divider(),

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
              // SingleChildScrollView(
              //   child: Column(
              //     children: [
              //       //
              //       GestureDetector(
              //         onTap: () {},
              //         child: AspectRatio(
              //           aspectRatio: 1,
              //           child: FittedBox(
              //             fit: BoxFit.fill,
              //             child: Icon(Icons.qr_code_rounded),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
