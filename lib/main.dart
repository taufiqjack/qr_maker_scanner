import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:qr_maker_scan/core/bloc/themes/theme_bloc.dart';
import 'package:qr_maker_scan/core/constants/hive_stuff.dart';
import 'package:qr_maker_scan/utils/route.dart';
import 'package:qr_maker_scan/views/splash_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await HiveStuff.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.light, // status bar color
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()..add(InitialThemeSetEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeData>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            navigatorKey: Go.navigatorKey,
            theme: state.copyWith(
                textTheme: state.textTheme
                    .apply(fontFamily: GoogleFonts.montserrat().fontFamily)),
            /* ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue[700],
              fontFamily: GoogleFonts.montserrat().fontFamily,
            ), */
            home: const SplashView(),
          );
        },
      ),
    );
  }
}
