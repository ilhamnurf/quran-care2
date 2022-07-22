import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pro/app/data/models/detaiSurah.dart' as detail;
import 'package:quran_pro/app/modules/home/controllers/home_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../constant/color.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final Map<String, dynamic> dataMapPerJuz = Get.arguments["juz"];
  Map<String, dynamic>? bookmark;
  final homeC = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    if (Get.arguments["bookmark"] != null) {
      bookmark = Get.arguments["bookmark"];
      var ia = int.parse(bookmark!["index_ayat"]);
      print("INDEX AYAT : ${bookmark!["index_ayat"]}");
      // print("GO TO INDEX AUTO SCROLL : ${bookmark!["index_ayat"] + 2}");
      controller.scrollC.scrollToIndex(ia,
          // bookmark!["index_ayat"] + 2,
          // 5,
          preferPosition: AutoScrollPosition.begin);
    }
    ;

    print(bookmark);
    List<Widget> AllAyat =
        List.generate((dataMapPerJuz['verses'] as List).length, (index) {
      Map<String, dynamic> ayat = dataMapPerJuz['verses'][index];
      detail.DetailSurah surah = ayat["surah"];
      detail.Verse verse = ayat["ayat"];
      return AutoScrollTag(
        index: index,
        controller: controller.scrollC,
        key: ValueKey(index),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (verse.number?.inSurah == 1)
                GestureDetector(
                  onTap: () => Get.dialog(Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Get.isDarkMode
                            ? oldDrkGreen2.withOpacity(0.3)
                            : white,
                      ),
                      padding: EdgeInsets.all(25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            ' ${surah.name?.transliteration?.id}',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(),
                          Text(
                            ' ${surah.tafsir?.id ?? 'Tidak ada tafsir di Surat ini'}',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )),
                  child: Container(
                    width: Get.width,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient:
                          LinearGradient(colors: [appGreen, oldDrkGreen2]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        Text(
                          ' ${surah.name?.transliteration?.id?.toUpperCase() ?? 'Error'}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: whiteOld),
                        ),
                        Text(
                          '( ${surah.name?.translation?.id?.toUpperCase() ?? 'Error'})',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: whiteOld),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          ' ${surah.numberOfVerses ?? 'Error'} Ayat | ${surah.revelation?.id ?? 'Error'}',
                          style: TextStyle(fontSize: 16, color: whiteOld),
                        ),
                      ]),
                    ),
                  ),
                ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode
                      ? oldGreen.withOpacity(0.5)
                      : oldDrkGreen2.withOpacity(0.1),
                ),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                                child: Text('${verse.number?.inSurah}'),
                              ),
                            ),
                            Text(
                              "${surah.name?.transliteration?.id ?? 'err'}",
                              style: TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 18),
                            )
                          ],
                        ),
                        GetBuilder<DetailJuzController>(
                          builder: (c) => Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.defaultDialog(
                                        title: "BOOKMARK",
                                        middleText: "pilih",
                                        actions: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              await c.addBookMark(
                                                true,
                                                surah,
                                                verse,
                                                index,
                                              );
                                              homeC.update();
                                            },
                                            child: Text("LastRead"),
                                            style: ElevatedButton.styleFrom(
                                                primary: oldDrkGreen),
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                c.addBookMark(
                                                  false,
                                                  surah,
                                                  verse,
                                                  index,
                                                );
                                              },
                                              child: Text("bookmark"),
                                              style: ElevatedButton.styleFrom(
                                                  primary: oldDrkGreen))
                                        ]);
                                  },
                                  icon: Icon(Icons.bookmark_add_outlined)),
                              (verse.kondisiAudio == "stop")
                                  ? IconButton(
                                      onPressed: () {
                                        c.playAudio(verse);
                                      },
                                      icon: Icon(Icons.play_arrow_rounded))
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        (verse.kondisiAudio == "playing")
                                            ? IconButton(
                                                onPressed: () {
                                                  c.pauseAudio(verse);
                                                },
                                                icon: Icon(Icons.pause))
                                            : IconButton(
                                                onPressed: () {
                                                  c.resumeAudio(verse);
                                                },
                                                icon: Icon(
                                                    Icons.play_arrow_rounded)),
                                        IconButton(
                                            onPressed: () {
                                              c.stopAudio(verse);
                                            },
                                            icon:
                                                Icon(Icons.stop_circle_rounded))
                                      ],
                                    )
                            ],
                          ),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${(ayat['ayat'] as detail.Verse).text?.arab}",
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "${(ayat['ayat'] as detail.Verse).text?.transliteration?.en}",
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "${(ayat['ayat'] as detail.Verse).translation?.id}",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      );
    });
    return Scaffold(
        appBar: AppBar(
          title: Text("JUZ ${dataMapPerJuz['juz']}"),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          controller: controller.scrollC,
          children: AllAyat,
        ));
  }
}
