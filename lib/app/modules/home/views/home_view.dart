import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quran_pro/app/constant/color.dart';

import 'package:quran_pro/app/routes/app_pages.dart';

import '../../../data/models/surah.dart';
import '../controllers/home_controller.dart';
import 'package:quran_pro/app/data/models/detaiSurah.dart' as detail;

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: Get.isDarkMode ? 0 : 4,
        title: Text('Quran Care'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.SEARCH),
              icon: Icon(Icons.search))
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Assalamu'alaikum",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [youngGreen, oldDrkGreen2]),
                    borderRadius: BorderRadius.circular(20)),
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => Get.toNamed(Routes.LAST_READ),
                    child: Container(
                      child: Stack(
                        children: [
                          Positioned(
                              bottom: -10,
                              right: 0,
                              child: Container(
                                  height: 150,
                                  width: 150,
                                  child:
                                      Image.asset('assets/images/logo.png'))),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.menu_book_rounded,
                                      color: white,
                                    ),
                                    Text(
                                      'Terakhir Dibaca',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: white,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'AL-Fath',
                                  style: TextStyle(
                                      color: white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  'Juz 1 Ayat 9',
                                  style: TextStyle(color: white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              TabBar(
                  indicatorColor: oldGreen,
                  labelColor: Get.isDarkMode ? oldDrkGreen : oldGreen,
                  unselectedLabelColor: Colors.grey[400],
                  tabs: [
                    Tab(
                      child: Text(
                        'Surah',
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Juz',
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Bookmark',
                      ),
                    ),
                  ]),
              Expanded(
                child: TabBarView(children: [
                  FutureBuilder<List<Surah>>(
                      future: controller.getAllSurrah(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              //surah persatuannya
                              Surah surah = snapshot.data![index];
                              return ListTile(
                                onTap: () {
                                  Get.toNamed(Routes.DETAIL_SURAH,
                                      arguments: surah);
                                },
                                leading: Obx(
                                  () => Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(controller
                                                    .isDark.isTrue
                                                ? 'assets/images/Desain tanpa judul2.png'
                                                : 'assets/images/Desain tanpa judul.png'))),
                                    child: Center(
                                      child: Text("${surah.number}"),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  "${surah.name!.transliteration?.id ?? 'Error'}",
                                ),
                                subtitle: Obx(
                                  () => Text(
                                    "${surah.numberOfVerses} Ayat | ${surah.revelation?.id ?? 'Error'}",
                                    style: TextStyle(
                                        color: controller.isDark.isTrue
                                            ? Colors.grey[300]
                                            : Colors.grey),
                                  ),
                                ),
                                trailing: Text(
                                  "${surah.name?.short ?? 'Error'}",
                                ),
                              );
                            });
                      }),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: controller.getAllJuz(),
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
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> dataMapPerJuz =
                              snapshot.data![index];
                          return ListTile(
                            onTap: () {
                              Get.toNamed(Routes.DETAIL_JUZ,
                                  arguments: dataMapPerJuz);
                            },
                            leading: Obx(
                              () => Container(
                                height: 40,
                                width: 40,
                                child: Center(
                                  child: Text("${index + 1}"),
                                ),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(controller
                                                .isDark.isTrue
                                            ? 'assets/images/Desain tanpa judul2.png'
                                            : 'assets/images/Desain tanpa judul.png'))),
                              ),
                            ),
                            title: Obx(
                              () => Text(
                                "Juz ${index + 1}",
                                style: TextStyle(
                                    color: controller.isDark.isTrue
                                        ? white
                                        : oldDrkGreen2),
                              ),
                            ),
                            isThreeLine: true,
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    "Mulai Dari ${dataMapPerJuz['start']['surah']} ayat ${(dataMapPerJuz['start']['ayat'] as detail.Verse).number?.inSurah}"),
                                Text(
                                    "Sampai  ${dataMapPerJuz['end']['surah']} ayat  ${(dataMapPerJuz['end']['ayat'] as detail.Verse).number?.inSurah}"),
                              ],
                            ),
                          );
                          ;
                        },
                      );
                    },  
                  ),
                  Center(child: Text('data1')),
                ]),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () {
            controller.isDark.isTrue
                ? Get.changeTheme(themeLight)
                : Get.changeTheme(themeDark);
            controller.isDark.toggle();
          },
          child: Icon(
            Icons.color_lens,
            color: controller.isDark.isTrue ? oldDrkGreen2 : whiteOld,
          ),
        ),
      ),
    );
  }
}
