// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:qr_maker_scan/views/dashboard_view.dart';

class QrController extends State<DashboardView> {
  static late QrController instance;
  late DashboardView view;
  TextEditingController inputText = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    instance = this;
  }

  @override
  void dispose() {
    void dispose() => super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);

  onGenerate() async {
    isLoading = true;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {});
    Future.delayed(
      const Duration(seconds: 2),
      () {
        isLoading = false;
        setState(() {});
      },
    );
  }
}

class MvcController {}
