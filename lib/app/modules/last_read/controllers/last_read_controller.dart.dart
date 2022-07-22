import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quran_pro/app/data/db/bookmark.dart';
import 'package:quran_pro/app/data/models/detaiSurah.dart';
import 'dart:convert';

import 'package:quran_pro/app/data/models/surah.dart';
import 'package:sqflite/sqflite.dart';

import '../../../constant/color.dart';

class LastReadController extends GetxController {
  //TODO: Implement TestController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
