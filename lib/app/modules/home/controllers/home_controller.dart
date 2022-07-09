import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:quran_pro/app/data/models/detaiSurah.dart';
import 'package:quran_pro/app/data/models/juz.dart';
import 'dart:convert';

import 'package:quran_pro/app/data/models/surah.dart';

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  RxBool isDark = false.obs;
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
    List<Map<String, dynamic>> alljuz = [];

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
              'surah ': data.name?.transliteration?.id,
              'ayat': ayat,
            });
          } else {
            // jika juz bertambah
            alljuz.add({
              'juz': juz,
              'start': penAyat[0],
              'end': penAyat[penAyat.length - 1],
              'verses': penAyat,
            });
            juz++;
            penAyat.clear();
            penAyat.add({
              'surah ': data.name?.transliteration?.id,
              'ayat': ayat,
            });
          }
        });
      }
    }

    alljuz.add({
      'juz': juz,
      'start': penAyat[0],
      'end': penAyat[penAyat.length - 1],
      'verses': penAyat,
    });
    return alljuz;
  }
}
