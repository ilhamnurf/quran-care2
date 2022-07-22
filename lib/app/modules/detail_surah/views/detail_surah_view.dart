import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pro/app/data/models/detaiSurah.dart' as detail;
import 'package:quran_pro/app/data/models/surah.dart';
import 'package:quran_pro/app/modules/home/controllers/home_controller.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../constant/color.dart';
import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  // final Surah surah = Get.arguments;
  final homeC = Get.find<HomeController>();
  Map<String, dynamic>? bookmark;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Text('Surah ${Get.arguments['name'].toString().toUpperCase()}'),
          centerTitle: true,
        ),
        body: FutureBuilder<detail.DetailSurah>(
          future:
              controller.getDetailSurrah(Get.arguments['number'].toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Text("Tidak Ada data"),
              );
            }

            if (Get.arguments["bookmark"] != null) {
              bookmark = Get.arguments["bookmark"];
              var ia = int.parse(bookmark!["index_ayat"]) + 2;
              print("INDEX AYAT : ${bookmark!["index_ayat"]}");
              // print("GO TO INDEX AUTO SCROLL : ${bookmark!["index_ayat"] + 2}");
              controller.scrollC.scrollToIndex(ia,
                  // bookmark!["index_ayat"] + 2,
                  // 5,
                  preferPosition: AutoScrollPosition.begin);
            }
            ;

            print(bookmark);

            detail.DetailSurah surah = snapshot.data!;

            List<Widget> allAyat =
                List.generate(snapshot.data?.verses?.length ?? 0, (index) {
              detail.Verse? ayat = snapshot.data?.verses?[index];
              return AutoScrollTag(
                key: ValueKey(index + 2),
                index: index + 2,
                controller: controller.scrollC,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 10),
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
                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(Get.isDarkMode
                                            ? 'assets/images/Desain tanpa judul2.png'
                                            : 'assets/images/Desain tanpa judul.png'),
                                        fit: BoxFit.contain)),
                                child: Center(
                                  child: Text('${index + 1}'),
                                ),
                              ),
                              GetBuilder<DetailSurahController>(
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
                                                      snapshot.data!,
                                                      ayat!,
                                                      index,
                                                    );
                                                    homeC.update();
                                                  },
                                                  child: Text("LastRead"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          primary: oldDrkGreen),
                                                ),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      c.addBookMark(
                                                        false,
                                                        snapshot.data!,
                                                        ayat!,
                                                        index,
                                                      );
                                                    },
                                                    child: Text("bookmark"),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary:
                                                                oldDrkGreen))
                                              ]);
                                        },
                                        icon:
                                            Icon(Icons.bookmark_add_outlined)),
                                    (ayat?.kondisiAudio == "stop")
                                        ? IconButton(
                                            onPressed: () {
                                              c.playAudio(ayat);
                                            },
                                            icon:
                                                Icon(Icons.play_arrow_rounded))
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              (ayat?.kondisiAudio == "playing")
                                                  ? IconButton(
                                                      onPressed: () {
                                                        c.pauseAudio(ayat!);
                                                      },
                                                      icon: Icon(Icons.pause))
                                                  : IconButton(
                                                      onPressed: () {
                                                        c.resumeAudio(ayat!);
                                                      },
                                                      icon: Icon(Icons
                                                          .play_arrow_rounded)),
                                              IconButton(
                                                  onPressed: () {
                                                    c.stopAudio(ayat!);
                                                  },
                                                  icon: Icon(Icons
                                                      .stop_circle_rounded))
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
                      "${ayat!.text?.arab}",
                      textAlign: TextAlign.end,
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${ayat.text?.transliteration?.en}",
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      "${ayat.translation?.id}",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              );
            });

            //sudah pasti ada
            return ListView(
              controller: controller.scrollC,
              padding: EdgeInsets.all(20),
              children: [
                AutoScrollTag(
                  key: ValueKey(0),
                  index: 0,
                  controller: controller.scrollC,
                  child: GestureDetector(
                    onTap: () => Get.dialog(Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Get.isDarkMode ? whiteOld : oldGreen,
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
                ),
                AutoScrollTag(
                  key: ValueKey(1),
                  index: 1,
                  controller: controller.scrollC,
                  child: SizedBox(
                    height: 20,
                  ),
                ),
                ...allAyat,
              ],
            );
          },
        ));
  }
}
