import 'package:custom_qr_generator/custom_qr_generator.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:qr_maker_scan/controllers/qr_controller.dart';
import 'package:qr_maker_scan/widgets/modal_progres.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  Widget build(BuildContext context, QrController controller) {
    controller.view = this;

    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: ModalProgress(
          inAsyncCall: controller.isLoading,
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 10,
                left: 20,
                right: 20),
            child: SingleChildScrollView(
              child: Column(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Icon(
                    IonIcons.qr_code,
                    color: Colors.white,
                    size: MediaQuery.of(context).size.height / 5,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    TextFormField(
                      controller: controller.inputText,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () => controller.inputText.clear(),
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
                        : CustomPaint(
                            painter: QrPainter(
                                data: controller.inputText.text,
                                options: const QrOptions(
                                    shapes: QrShapes(
                                      darkPixel: QrPixelShapeRoundCorners(
                                          cornerFraction: .5),
                                      frame: QrFrameShapeRoundCorners(
                                          cornerFraction: 25),
                                      ball: QrBallShapeRoundCorners(
                                          cornerFraction: .25),
                                    ),
                                    colors: QrColors(
                                        dark: QrColorLinearGradient(
                                            colors: [
                                          Color.fromARGB(255, 255, 0, 0),
                                          Color.fromARGB(255, 0, 0, 255)
                                        ],
                                            orientation: GradientOrientation
                                                .leftDiagonal)))),
                            size: const Size(200, 200),
                          )
                  ],
                ),
              ]),
            ),
          ),
        ));
  }

  @override
  State<DashboardView> createState() => QrController();
}
