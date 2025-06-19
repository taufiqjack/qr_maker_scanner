import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_maker_scan/controllers/qr_controller.dart';
import 'package:qr_maker_scan/core/bloc/themes/theme_bloc.dart';
import 'package:qr_maker_scan/utils/route.dart';
import 'package:qr_maker_scan/views/scanner_view.dart';
import 'package:qr_maker_scan/widgets/modal_progres.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  Widget build(BuildContext context, QrController controller) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            exitApp();
          }
        },
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
                      child: Lottie.asset('assets/lotties/qr_scan.json',
                          height: 200),
                      // child: SvgPicture.asset(
                      //   'assets/images/skenner_logo.svg',
                      //   height: MediaQuery.of(context).size.height / 4,
                      // ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Column(children: [
                      TextFormField(
                        controller: controller.inputText,
                        onChanged: (value) {
                          if (kDebugMode) {
                            print(controller.inputText.toString());
                          }
                        },
                        inputFormatters: const [],
                        decoration: InputDecoration(
                          suffixIcon: InkWell(
                            onTap: () => controller.clearText(),
                            child: const Icon(FontAwesome.circle_xmark),
                          ),
                          hintText: 'Tulis teks atau Url',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              elevation: 0.5,
                              backgroundColor: Colors.grey.shade300),
                          onPressed: () {
                            controller.onGenerate();
                          },
                          child: const Text(
                            'Buat',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Mode Gelap'),
                          BlocBuilder<ThemeBloc, ThemeData>(
                            builder: (context, state) {
                              return CupertinoSwitch(
                                value: state == ThemeData.dark(),
                                onChanged: (value) =>
                                    BlocProvider.of<ThemeBloc>(context)
                                        .add(ThemeSwitchEvent()),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      controller.isLoading || controller.inputText.text.isEmpty
                          ? const SizedBox()
                          : Column(
                              children: [
                                RepaintBoundary(
                                  key: controller.globalKey,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white),
                                    child: QrImageView(
                                      data: controller.inputText.text,
                                      gapless: true,
                                      // embeddedImage: const AssetImage(
                                      //     'assets/images/skenner_logo.png'),
                                      size: MediaQuery.of(context).size.height /
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
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        backgroundColor: Colors.grey.shade300),
                                    onPressed: () {
                                      controller.saveToGallery();
                                    },
                                    child: const Text(
                                      'Save',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ]),
                  ],
                ),
              )),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            )),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: controller.bannerAd!.size.height.toDouble(),
            width: controller.bannerAd!.size.width.toDouble(),
            child: AdWidget(ad: controller.bannerAd!),
          ),
        ),
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
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: const Text(
          'Keluar dari aplikasi?',
        ),
        actions: [
          TextButton(
              onPressed: () {
                Go.back();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color.fromARGB(255, 182, 182, 182),
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
