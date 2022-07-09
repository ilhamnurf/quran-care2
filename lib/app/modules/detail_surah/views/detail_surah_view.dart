import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pro/app/data/models/detaiSurah.dart' as detail;
import 'package:quran_pro/app/data/models/surah.dart';

import '../../../constant/color.dart';
import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final Surah surah = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              'Surah ${surah.name?.transliteration?.id?.toUpperCase() ?? 'Error'}'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            GestureDetector(
              
              onTap: () => Get.dialog(Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
                child: Container(
                  
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20) ,color: Get.isDarkMode ? oldDrkGreen2.withOpacity(0.3) : white,),
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
              // onTap: () => Get.defaultDialog(
              //   backgroundColor: Get.isDarkMode?oldDrkGreen2.withOpacity(0.3):white,
              //   contentPadding:
              //       EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              //   title: ' Tafsir  ${surah.name?.transliteration?.id}',
              //   titleStyle: TextStyle(
              //     fontWeight: FontWeight.bold,
              //   ),
              //   // middleText: '${surah.tafsir?.id ?? 'Tidak ada tafsir di Surat ini'}',
              //   content: Container(
              //     // decoration: BoxDecoration(
              //     //   borderRadius: BorderRadius.circular(20),
              //     // ),
              // child: Text(
              //   ' ${surah.tafsir?.id ?? 'Tidak ada tafsir di Surat ini'}',
              //   textAlign: TextAlign.left,
              //   style:
              //       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              // ),
              //   ),
              // ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [youngGreen, oldDrkGreen2]),
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
            SizedBox(
              height: 20,
            ),
            FutureBuilder<detail.DetailSurah>(
                future: controller.getDetailSurrah(surah.number.toString()),
                // future:   Future.delayed(Duration(seconds: 2)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData) {
                    return Center(
                      child: Text("data tidak ditemukan"),
                    );
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data?.verses?.length ?? 0,
                      itemBuilder: ((context, index) {
                        if (snapshot.data?.verses == 0) {
                          return SizedBox();
                        }
                        detail.Verse? ayat = snapshot.data?.verses?[index];
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                  Icons.bookmark_add_outlined)),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                  Icons.play_arrow_rounded))
                                        ],
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
                              style: TextStyle(
                                  fontSize: 15, fontStyle: FontStyle.italic),
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
                      }));
                })
          ],
        ));
  }
}