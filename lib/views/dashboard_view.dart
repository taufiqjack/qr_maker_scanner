import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_maker_scan/controllers/qr_controller.dart';
import 'package:qr_maker_scan/utils/route.dart';
import 'package:qr_maker_scan/views/scanner_view.dart';
import 'package:qr_maker_scan/widgets/modal_progres.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  Widget build(BuildContext context, QrController controller) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: WillPopScope(
        onWillPop: exitApp,
        child: ModalProgress(
          inAsyncCall: controller.isLoading,
          child: Stack(children: [
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10,
                    left: 20,
                    right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SvgPicture.asset(
                          'assets/images/skenner_logo.svg',
                          height: MediaQuery.of(context).size.height / 4,
                          // child: Icon(
                          //   IonIcons.qr_code,
                          //   color: Colors.white,
                          //   size: MediaQuery.of(context).size.height / 5,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(children: [
                        TextFormField(
                          controller: controller.inputText,
                          style: const TextStyle(color: Colors.white),
                          onChanged: (value) {
                            if (kDebugMode) {
                              print(controller.inputText.toString());
                            }
                          },
                          inputFormatters: const [],
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () => controller.clearText(),
                              child: Icon(FontAwesome.circle_xmark,
                                  color: Colors.grey.shade200),
                            ),
                            hintText: 'Tulis teks atau Url',
                            hintStyle: TextStyle(color: Colors.grey.shade300),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 40,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () {
                              controller.onGenerate();
                            },
                            child: const Text(
                              'Buat',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        controller.isLoading ||
                                controller.inputText.text.isEmpty
                            ? const SizedBox()
                            : Column(
                                children: [
                                  RepaintBoundary(
                                    key: controller.globalKey,
                                    child:
                                        // CustomPaint(
                                        //   painter:
                                        // QrPainter(
                                        //     data: controller.inputText.text,
                                        //     options: const QrOptions(
                                        //         // shapes: QrShapes(
                                        //         //   darkPixel: QrPixelShapeRoundCorners(
                                        //         //       cornerFraction: .5),
                                        //         //   frame: QrFrameShapeRoundCorners(
                                        //         //       cornerFraction: 25),
                                        //         //   ball: QrBallShapeRoundCorners(
                                        //         //       cornerFraction: .25),
                                        //         // ),
                                        //         // colors: QrColors(
                                        //         //     dark: QrColorLinearGradient(
                                        //         //         colors: [
                                        //         //   Color.fromARGB(255, 255, 0, 0),
                                        //         //   Color.fromARGB(255, 0, 0, 255)
                                        //         // ],
                                        //         //         orientation: GradientOrientation
                                        //         //             .leftDiagonal))
                                        //         )),
                                        // size: const Size(200, 200),

                                        // ),

                                        Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white),
                                      child: QrImage(
                                        data: controller.inputText.text,
                                        gapless: true,
                                        embeddedImage: const AssetImage(
                                            'assets/images/skenner_logo.png'),
                                        size:
                                            MediaQuery.of(context).size.height /
                                                5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 100,
                                    height: 40,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white),
                                      onPressed: () {
                                        controller.saveToGallery();
                                      },
                                      child: const Text(
                                        'Save',
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ]),
                    ],
                  ),
                )),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: SizedBox(
            //     height: controller.bannerAd!.size.height.toDouble(),
            //     width: controller.bannerAd!.size.width.toDouble(),
            //     child: AdWidget(ad: controller.bannerAd!),
            //   ),
            // )
          ]),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Go.to(const ScannerView());
        },
        child: const Icon(
          Icons.qr_code_scanner_outlined,
        ),
      ),
      bottomNavigationBar: Container(
        height: MediaQuery.of(context).size.height / 20,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
      ),
    );
  }

  Future<bool> exitApp() async {
    return await showDialog(
      context: globalContext,
      builder: (contex) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: const Text(
          'Skenner',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Keluar dari aplikasi?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Go.back();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color.fromARGB(255, 98, 98, 98),
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              )),
          TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(
                    color: Color.fromARGB(255, 245, 27, 27),
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ))
        ],
      ),
    );
  }

  @override
  State<DashboardView> createState() => QrController();
}
