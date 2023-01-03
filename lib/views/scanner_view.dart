// ignore_for_file: unnecessary_null_comparison

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_maker_scan/utils/route.dart';
import 'package:qr_maker_scan/views/dashboard_view.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({Key? key}) : super(key: key);

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView>
    with SingleTickerProviderStateMixin {
  // static const flashOn = 'Nyalakan Flash';
  // static const flashOff = 'Matikan Flash';
  static const flashlighton = FontAwesome.bolt;
  static const flashlightoff = CupertinoIcons.bolt_slash_fill;
  static const frontCamera = 'Kamera Depan';
  // static const backCamera = 'Kamera Belakang';

  // Barcode? qrcode;
  var flashState = flashlightoff;
  var cameraState = frontCamera;
  // QRViewController? controller;
  MobileScannerController controller = MobileScannerController();
  String? result;

  final GlobalKey qrKey = GlobalKey();

  Future<void> _launchBrowser(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Toast.show('link url bermasalah', gravity: Toast.bottom);
    }
  }

  // void _onQRViewCreated(QRViewController controller) {
  //   this.controller = controller;
  //   controller.scannedDataStream.listen((scanData) {
  //     setState(() {
  //       result = scanData;
  //     });
  //   });
  // }

  bool _isFlashOn(IconData current) {
    return flashlighton == current;
  }

  // bool _isBackCamera(String current) {
  //   return backCamera == current;
  // }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        MobileScanner(
          controller: controller,
          onDetect: ((qrcode, args) {
            setState(() {
              result = qrcode.rawValue;
            });
          }),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 50,
                bottom: 10,
                left: 10,
              ),
              child: InkWell(
                onTap: () {
                  Go.back();
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 10,
          left: 0,
          right: 0,
          child: const Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.only(
                  top: 50,
                  bottom: 10,
                  left: 10,
                ),
                child: Text(
                  'Pindai kode QR pada\nperangkat',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                )),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: BlurryContainer(
            elevation: 0,
            height: MediaQuery.of(context).size.height / 4,
            blur: 5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.black.withOpacity(0.3),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (controller == null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'hasil convert : $result',
                          style:
                              TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () async {
                            FlutterClipboard.copy('$result').then((value) {
                              if (kDebugMode) {
                                print('copied');
                              }
                              Toast.show('Teks disalin', gravity: Toast.bottom);
                            });
                          },
                          child: Icon(Icons.copy,
                              color: Colors.white.withOpacity(0.8)),
                        ),
                      ],
                    )
                  else if (result != null)
                    // else
                    Text(
                      'Scan Kode',
                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                    )
                  else
                    const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  result == null ? const SizedBox() : openLink(context),
                  Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: _isFlashOn(flashState)
                                  ? Colors.orange
                                  : Colors.grey,
                              width: 2),
                          borderRadius: BorderRadius.circular(30)),
                      child: InkWell(
                        onTap: () {
                          controller.toggleTorch();
                          if (_isFlashOn(flashState)) {
                            setState(() {
                              flashState = flashlightoff;
                            });
                          } else {
                            setState(() {
                              flashState = flashlighton;
                            });
                          }
                        },
                        child: Icon(
                          flashState,
                          color: _isFlashOn(flashState)
                              ? Colors.orange
                              : Colors.grey,
                        ),
                      )),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Future<bool> exitApp() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const DashboardView()),
        (route) => false);
    return false;
  }

  openLink(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      showDialog(
          context: context,
          builder: (context) {
            return ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 100),
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Buka Link?'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('$result'),
                          InkWell(
                            onTap: () async {
                              FlutterClipboard.copy('$result').then((value) {
                                if (kDebugMode) {
                                  print('copied');
                                }
                                Toast.show('Teks disalin',
                                    gravity: Toast.bottom);
                              });
                            },
                            child: Icon(Icons.copy,
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.8)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        _launchBrowser('$result');
                      },
                      child: Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.blue.shade300),
                        child: const Center(
                            child: Text(
                          'OK',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Go.back();
                      },
                      child: Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey),
                        child: const Center(
                            child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ],
                ));
          });
    });
    return const SizedBox();
  }
}
