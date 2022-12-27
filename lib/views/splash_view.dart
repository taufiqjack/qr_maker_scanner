import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_maker_scan/utils/route.dart';
import 'package:qr_maker_scan/views/dashboard_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Go.to(const DashboardView());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
      child: Center(
        child: SvgPicture.asset(
          'assets/images/skenner.svg',
          height: MediaQuery.of(context).size.height / 8,
        ),
      ),
    );
  }
}
