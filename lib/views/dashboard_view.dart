import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:qr_maker_scan/controllers/qr_controller.dart';
import 'package:qr_maker_scan/utils/route.dart';
import 'package:qr_maker_scan/views/scanner_view.dart';
import 'package:qr_maker_scan/widgets/modal_progres.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  Widget build(BuildContext context, QrController controller) {
    controller.view = this;

    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: WillPopScope(
        onWillPop: exitApp,
        child: ModalProgress(
          inAsyncCall: controller.isLoading,
          child: Padding(
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
                    'assets/images/skenner.svg',
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
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () => controller.clearText(),
                        child: Icon(FontAwesome.circle_xmark,
                            color: Colors.grey.shade200),
                      ),
                      hintText: 'Your Text or Url',
                      hintStyle: TextStyle(color: Colors.grey.shade300),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Colors.white)),
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
                        'Create',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  controller.inputText.text.isEmpty || controller.isLoading
                      ? const SizedBox()
                      : Column(
                          children: [
                            RepaintBoundary(
                              key: controller.globalKey,
                              child: CustomPaint(
                                painter: QrPainter(
                                    data: controller.inputText.text,
                                    options: const QrOptions(
                                        // shapes: QrShapes(
                                        //   darkPixel: QrPixelShapeRoundCorners(
                                        //       cornerFraction: .5),
                                        //   frame: QrFrameShapeRoundCorners(
                                        //       cornerFraction: 25),
                                        //   ball: QrBallShapeRoundCorners(
                                        //       cornerFraction: .25),
                                        // ),
                                        // colors: QrColors(
                                        //     dark: QrColorLinearGradient(
                                        //         colors: [
                                        //   Color.fromARGB(255, 255, 0, 0),
                                        //   Color.fromARGB(255, 0, 0, 255)
                                        // ],
                                        //         orientation: GradientOrientation
                                        //             .leftDiagonal))
                                        )),
                                size: const Size(200, 200),
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
            )),
          ),
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
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          'Keluar?',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Keluar dari aplikasi?',
          style: TextStyle(color: Colors.grey.shade300),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Go.back();
              },
              child: const Text(
                'Batalkan',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              )),
          TextButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text(
                'Ok',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ))
        ],
      ),
    );
  }

  @override
  State<DashboardView> createState() => QrController();
}
