import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pro/app/data/models/juz.dart' as juz;
import 'package:quran_pro/app/data/models/surah.dart';

import '../../../constant/color.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final juz.Juz detailJuz = Get.arguments['juz'];
  final List<Surah> allSurahthisjuz = Get.arguments['surah'];
  @override
  Widget build(BuildContext context) {
    allSurahthisjuz.forEach((element) {
      print('[');
      print(element.name!.transliteration!.id);
      print(']');
    });
    return Scaffold(
        appBar: AppBar(
          title: Text('JUZ ${detailJuz.juz}'),
          centerTitle: true,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: detailJuz.verses?.length ?? 0,
          itemBuilder: (context, index) {
            if (detailJuz.verses == null || detailJuz.verses?.length == 0) {
              return Center(
                child: Text('lmao pisan, eweuhan'),
              );
            }
            juz.Verses ayat = detailJuz.verses![index];

            if (index!=0) {
              if (ayat.number?.inSurah==1) {
              controller.index++;
            }
            }
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Get.isDarkMode
                        ? oldGreen.withOpacity(0.5)
                        : oldDrkGreen2.withOpacity(0.1),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 15),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(Get.isDarkMode
                                            ? 'assets/images/Desain tanpa judul2.png'
                                            : 'assets/images/Desain tanpa judul.png'),
                                        fit: BoxFit.contain)),
                                child: Center(
                                  child: Text('${ayat.number?.inSurah}'),
                                ),
                              ),
                              Text(
                                '${allSurahthisjuz[controller.index].name?.transliteration?.id ?? ''}',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, fontSize: 18),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.bookmark_add_outlined)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.play_arrow_rounded))
                            ],
                          )
                        ],
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${ayat.text?.arab}",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "${ayat.text?.transliteration?.en}",
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "${ayat.translation?.id}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            );
          },
        ));
  }
}
