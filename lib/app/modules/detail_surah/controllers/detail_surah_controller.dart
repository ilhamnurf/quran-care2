import 'dart:convert';

import 'package:get/get.dart';
import 'package:quran_pro/app/data/models/detaiSurah.dart';
import 'package:http/http.dart' as http;

class DetailSurahController extends GetxController {
  
  get isDark => null;

  Future<DetailSurah> getDetailSurrah(String id) async {
    Uri url = Uri.parse("https://api.quran.sutanlab.id/surah/$id");
    var res = await http.get(url);
    
    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)["data"];
    
    
    
    return DetailSurah.fromJson(data);
  }
  
}
