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
              GetBuilder<HomeController>(
                builder: (c) => FutureBuilder<Map<String, dynamic>?>(
                  future: c.getLastRead(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [appGreen, oldDrkGreen2]),
                            borderRadius: BorderRadius.circular(20)),
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
                                    'loading',
                                    style: TextStyle(
                                        color: white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    '',
                                    style:
                                        TextStyle(color: white, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    Map<String, dynamic>? lastRead = snapshot.data;
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                          gradient:
                              LinearGradient(colors: [appGreen, oldDrkGreen2]),
                          borderRadius: BorderRadius.circular(20)),
                      child: Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onLongPress: () {
                            if (lastRead != null) {
                              Get.defaultDialog(
                                  title: "Delete Last Read",
                                  middleText: "Are u dumb, u'll loose it",
                                  actions: [
                                    OutlinedButton(
                                        onPressed: () => Get.back(),
                                        child: Text("CANCEL")),
                                    ElevatedButton(
                                      onPressed: () {
                                        c.deleteBookmark(lastRead['id']);
                                      },
                                      child: Text("DELETE"),
                                    )
                                  ]);
                            }
                          },
                          onTap: () {
                            if (lastRead != null) {
                              print(lastRead);
                            }
                          },
                          child: Container(
                            child: Stack(
                              children: [
                                Positioned(
                                    bottom: -10,
                                    right: 0,
                                    child: Container(
                                        height: 150,
                                        width: 150,
                                        child: Image.asset(
                                            'assets/images/logo.png'))),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        lastRead == null
                                            ? ""
                                            : "${lastRead['surah'].toString().replaceAll("+", "'")}",
                                        style: TextStyle(
                                            color: white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        lastRead == null
                                            ? 'Belum ada tanda'
                                            : 'Juz ${lastRead['juz']} Ayat ${lastRead['ayat']}',
                                        style: TextStyle(
                                            color: white, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              TabBar(
                  indicatorColor: oldGreen,
                  labelColor: Get.isDarkMode ? oldGreen : Colors.grey,
                  unselectedLabelColor: Colors.grey,
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
                                  Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                    "name": surah.name!.transliteration!.id,
                                    "number": surah.number!,
                                  });
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
                                    "Mulai Dari ${(dataMapPerJuz['start']['surah'] as detail.DetailSurah).name?.transliteration?.id} ayat ${(dataMapPerJuz['start']['ayat'] as detail.Verse).number?.inSurah}"),
                                Text(
                                    "Sampai  ${(dataMapPerJuz['end']['surah'] as detail.DetailSurah).name?.transliteration?.id}ayat  ${(dataMapPerJuz['end']['ayat'] as detail.Verse).number?.inSurah}"),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  GetBuilder<HomeController>(
                    builder: (c) {
                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: controller.getBM(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: oldDrkGreen,
                            ));
                          }

                          if (snapshot.data?.length == 0) {
                            return Center(
                              child: Text("Book Mark tidak tersedia"),
                            );
                          }

                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data = snapshot.data![index];
                              return ListTile(
                                onTap: () {
                                  Get.toNamed(Routes.DETAIL_SURAH, arguments: {
                                    "name": data["surah"]
                                        .toString()
                                        .replaceAll("+", "'"),
                                    "number": data["number_surah"],
                                    "bookmark": data
                                  });
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
                                title: Text(
                                    "${data['surah'].toString().replaceAll("+", "'")}"),
                                subtitle: Text(
                                    "Ayat ${data['ayat']} - via ${data['via']}"),
                                trailing: IconButton(
                                    onPressed: () {
                                      c.deleteBookmark(data['id']);
                                    },
                                    icon: Icon(Icons.delete)),
                              );
                            },
                          );
                        },
                      );
                    },
                  )
                ]),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: () => controller.changeThemeMode(),
          child: Icon(
            Icons.color_lens,
            color: controller.isDark.isTrue ? oldDrkGreen2 : whiteOld,
          ),
        ),
      ),
    );
  }
}
