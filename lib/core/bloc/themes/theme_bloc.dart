import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:qr_maker_scan/core/constants/enum.dart';
import 'package:qr_maker_scan/core/storage/main_storage.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(ThemeData.light()) {
    on<InitialThemeSetEvent>((event, emit) async {
      final bool hasDarkTheme = await getDarkTheme();
      if (hasDarkTheme) {
        emit(ThemeData.dark());
      } else {
        emit(ThemeData.light());
      }
    });

    on<ThemeSwitchEvent>((event, emit) {
      final isDark = state == ThemeData.dark();
      emit(isDark ? ThemeData.light() : ThemeData.dark());
      setTheme(isDark);
    });
  }
}

Future<bool> getDarkTheme() async {
  return darkmode.get(DARKMODE) ?? false;
}

Future<void> setTheme(bool isDark) async {
  darkmode.put(DARKMODE, !isDark);
}
