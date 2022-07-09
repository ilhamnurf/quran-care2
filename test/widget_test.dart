import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:quran_pro/app/data/models/ayat.dart';
import 'package:quran_pro/app/data/models/detaiSurah.dart';
import 'package:quran_pro/app/data/models/juz.dart';
import 'package:quran_pro/app/data/models/surah.dart';

void main() async {
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
            'surah ': data.name?.transliteration?.id ?? '',
            'ayat': ayat,
          });
        } else {
          // jika juz bertambah
          print('BERHASIL MEMASUKAN JUZ $juz');
          print('============');
          print('START :');
          print('Ayat :${(penAyat[0]['ayat'] as Verse).number?.inSurah}');
          print((penAyat[0]['ayat'] as Verse).text?.arab);
          print('END :');
          print(
              'Ayat :${(penAyat[penAyat.length - 1]['ayat'] as Verse).number?.inSurah}');
          print((penAyat[penAyat.length - 1]['ayat'] as Verse).text?.arab);
          alljuz.add({
            'juz': juz,
            'start': penAyat[0],
            'end': penAyat[penAyat.length - 1],
            'verses': penAyat,
          });
          juz++;
          penAyat.clear();
          penAyat.add({
            'surah ': data.name?.transliteration?.id ?? '',
            'ayat': ayat,
          });
        }
      });
    }
  }
  print('BERHASIL MEMASUKAN JUZ $juz');
  print('============');
  print('START :');
  print('Ayat :${(penAyat[0]['ayat'] as Verse).number?.inSurah}');
  print((penAyat[0]['ayat'] as Verse).text?.arab);
  print('END :');
  print(
      'Ayat :${(penAyat[penAyat.length - 1]['ayat'] as Verse).number?.inSurah}');
  print((penAyat[penAyat.length - 1]['ayat'] as Verse).text?.arab);
  print('surah ${penAyat}');
  alljuz.add({
    'juz': juz,
    'start': penAyat[0],
    'end': penAyat[penAyat.length - 1],
    'verses': penAyat,
  });
}
