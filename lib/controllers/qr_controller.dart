// ignore_for_file: unused_element

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_maker_scan/utils/ads.dart';
import 'package:qr_maker_scan/views/dashboard_view.dart';
import 'dart:ui' as ui;

import 'package:toast/toast.dart';

class QrController extends State<DashboardView> {
  static late QrController instance;
  late DashboardView view;
  TextEditingController inputText = TextEditingController();
  bool isLoading = false;
  final GlobalKey globalKey = GlobalKey();
  int originalSize = 800;
  BannerAd? bannerAd;

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    instance = this;
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: sample,
      listener: const BannerAdListener(),
      request: const AdRequest(),
    );
    bannerAd!.load();
  }

  @override
  void dispose() {
    void dispose() => super.dispose();
    bannerAd!.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  onGenerate() async {
    if (inputText.text.isEmpty) {
      Toast.show('form tidak boleh kosong',
          gravity: Toast.bottom, duration: Toast.lengthLong);
    } else {
      isLoading = true;
      FocusManager.instance.primaryFocus?.unfocus();
      setState(() {});
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          isLoading = false;
          setState(() {});
        },
      );
    }
  }

  requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    if (kDebugMode) {
      print(info);
    }
  }

  saveToGallery() async {
    await requestPermission();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        RenderRepaintBoundary boundary = globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 2.0);
        ByteData? byteData =
            await (image.toByteData(format: ui.ImageByteFormat.png));
        if (byteData != null) {
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());

          Toast.show('Gambar tersimpan!',
              gravity: Toast.bottom, duration: Toast.lengthLong);
        }
      },
    );
  }

  clearText() {
    inputText.clear();
    setState(() {});
  }
}

class MvcController {}
