import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_maker_scan/core/constants/enum.dart';
import 'package:qr_maker_scan/core/storage/main_storage.dart';

class HiveStuff {
  static Future<void> init() async {
    if (!kIsWeb) {
      var path = await getTemporaryDirectory();
      Hive.init(path.path);
    }

    darkmode = await Hive.openBox(DARKMODE);
  }
}
