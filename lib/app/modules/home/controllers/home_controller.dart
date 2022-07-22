import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:quran_pro/app/data/db/bookmark.dart';
import 'package:quran_pro/app/data/models/detaiSurah.dart';
import 'dart:convert';

import 'package:quran_pro/app/data/models/surah.dart';
import 'package:sqflite/sqflite.dart';

import '../../../constant/color.dart';

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  List<Map<String, dynamic>> alljuz = [];
  RxBool isDark = false.obs;
  RxBool adaDataAllJuz = false.obs;

  DataBaseManager database = DataBaseManager.instance;

  Future<Map<String, dynamic>?> getLastRead() async {
    Database db = await database.db;
    List<Map<String, dynamic>> dataLastRead =
        await db.query("bookmark", where: "last_read == 1");
    if (dataLastRead.length == 0) {
      //ini tidak ada data last_read
      return null;
    } else {
      // ada data -> diambil index ke-0(karena da stu data di dlm list)
      return dataLastRead.first;
    }
  }

  void deleteBookmark(int id) async {
    Database db = await database.db;
    await db.delete("bookmark", where: "id = ${id}");
    update();
    Get.back();
    Get.snackbar("Berhasil", "Bookmark berhasil di hapus", colorText: whiteOld);
  }

  Future<List<Map<String, dynamic>>> getBM() async {
    Database db = await database.db;
    List<Map<String, dynamic>> allbookmarks = await db.query("bookmark",
        where: "last_read == 0", orderBy: "juz,via,surah ,ayat");
    return allbookmarks;
  }

  void changeThemeMode() async {
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);
    isDark.toggle();
    final box = GetStorage();
    if (Get.isDarkMode) {
      // dark -> lightc\
      box.remove("themeDark");
    } else {
      //  light -> dark
      box.write("themeDark", true);
    }
  }

  Future<List<Surah>> getAllSurrah() async {
    Uri url = Uri.parse("https://api.quran.sutanlab.id/surah");
    var res = await http.get(url);

    List? data = (json.decode(res.body) as Map<String, dynamic>)["data"];

    if (data == null || data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Map<String, dynamic>>> getAllJuz() async {
    int juz = 1;
    List<Map<String, dynamic>> penAyat = [];

    for (var i = 1; i <= 114; i++) {
      var res =
          await http.get(Uri.parse('https://api.quran.sutanlab.id/surah/$i'));
      Map<String, dynamic> rawData = json.decode(res.body)["data"];
      DetailSurah data = DetailSurah.fromJson(rawData);
      if (data.verses != null) {
        //ex: srh alfath  => 7 ayat dan kita cekk
        data.verses!.forEach((ayat) {
          if (ayat.meta?.juz == juz) {
            penAyat.add({
              "surah": data,
              "ayat": ayat,
            });
          } else {
            // jika juz bertambah
            alljuz.add({
              "juz": juz,
              "start": penAyat[0],
              "end": penAyat[penAyat.length - 1],
              "verses": penAyat,
            });
            juz++;
            penAyat = [];
            penAyat.add({
              "surah": data,
              "ayat": ayat,
            });
          }
        });
      }
    }

    alljuz.add({
      "juz": juz,
      "start": penAyat[0],
      "end": penAyat[penAyat.length - 1],
      "verses": penAyat,
    });
    return alljuz;
  }
}
