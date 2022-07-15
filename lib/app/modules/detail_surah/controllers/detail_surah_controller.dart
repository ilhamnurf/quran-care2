import 'dart:convert';
import 'package:get/get.dart';
import 'package:quran_pro/app/constant/color.dart';
import 'package:quran_pro/app/data/db/bookmark.dart';
import 'package:quran_pro/app/data/models/detaiSurah.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import 'package:sqflite/sqflite.dart';

class DetailSurahController extends GetxController {
  get isDark => null;
  final player = AudioPlayer();
  

  Verse? lastVerse;

  DataBaseManager database = DataBaseManager.instace;

  Future <void> addBookMark(
      bool lastread, DetailSurah surah, Verse ayat, int indexAyat) async {
    Database db = await database.db;

    bool flagExist = false;

    if (lastread == true) {
      await db.delete("bookmark", where: "last_read = 1");
      
    } else {
      List checkData = await db.query("bookmark",
          columns: ["surah", "ayat", "juz", "via", "index_ayat", "last_read"],
          where:
              "surah ='${surah.name!.transliteration!.id!.replaceAll("'", "+")}' and ayat = ${ayat.number!.inSurah!} and juz = ${ayat.meta!.juz!} and via = 'surah' and index_ayat = $indexAyat and last_read = 0");
      if (checkData.length != 0) {
        //ada data
        flagExist = true;
      }
    }
    if (flagExist == false) {
      await db.insert("bookmark", {
        "surah": "${surah.name!.transliteration!.id!.replaceAll("'", "+")}",
        "ayat": ayat.number!.inSurah!,
        "juz": ayat.meta!.juz!,
        "via": "surah",
        "index_ayat": indexAyat,
        "last_read": lastread == true ? 1 : 0,
      });
      Get.back(); //tutup dialog
    
      Get.snackbar("Berhasil", "Berhasil Menambahkan Book Mark",
          colorText: youngGreen);
    } else {
      Get.back(); //tutup dialog
      Get.snackbar("Gagal", "Gagal bookmark sudah tersedia",
          colorText: youngGreen);
    }
    var data = await db.query("bookmark");
    print(data);
  }

  // Future deleteN ()

  Future<DetailSurah> getDetailSurrah(String id) async {
    Uri url = Uri.parse("https://api.quran.sutanlab.id/surah/$id");
    var res = await http.get(url);

    Map<String, dynamic> data =
        (json.decode(res.body) as Map<String, dynamic>)["data"];

    return DetailSurah.fromJson(data);
  }

  void stopAudio(Verse ayat) async {
    try {
      await player.stop();
      ayat.kondisiAudio = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "terjadi kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "terjadi kesalahan",
          middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "terjadi kesalahan", middleText: "tidak dapat stop audio");
    }
  }

  void resumeAudio(Verse ayat) async {
    try {
      ayat.kondisiAudio = "playing";
      update();
      await player.play();
      ayat.kondisiAudio = "stop";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "terjadi kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "terjadi kesalahan",
          middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "terjadi kesalahan", middleText: "tidak dapat resume audio");
    }
  }

  void pauseAudio(Verse ayat) async {
    try {
      await player.pause();
      ayat.kondisiAudio = "pause";
      update();
    } on PlayerException catch (e) {
      Get.defaultDialog(
          title: "terjadi kesalahan", middleText: e.message.toString());
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
          title: "terjadi kesalahan",
          middleText: "Connection aborted: ${e.message}");
    } catch (e) {
      Get.defaultDialog(
          title: "terjadi kesalahan", middleText: "tidak dapat pause audio");
    }
  }

  void playAudio(Verse? ayat) async {
    if (ayat?.audio?.primary != null) {
      // mencegah terjadinya penumpukan audio yg sedang berjalan
      try {
        if (lastVerse == null) {
          lastVerse = ayat;
        }
        lastVerse!.kondisiAudio = "stop";
        lastVerse = ayat; //logic ketika lastVerse   sudah ada
        lastVerse!.kondisiAudio = "stop";
        update();
        await player
            .stop(); //mencegah terjadinya penumpukan audio yg sedang di play
        await player.setUrl(ayat!.audio!.primary!);
        ayat.kondisiAudio = "playing";
        update();
        await player.play();
        ayat.kondisiAudio = "stop";
        await player.stop();
        update();
      } on PlayerException catch (e) {
        Get.defaultDialog(
            title: "terjadi kesalahan", middleText: e.message.toString());
      } on PlayerInterruptedException catch (e) {
        Get.defaultDialog(
            title: "terjadi kesalahan",
            middleText: "Connection aborted: ${e.message}");
      } catch (e) {
        Get.defaultDialog(
            title: "terjadi kesalahan",
            middleText: "tidak dapat memutar audio");
      }
    } else {
      Get.defaultDialog(
          title: "terjadi kesalahan",
          middleText: "URL tidak ada atau tidak dapat di akses");
    }
  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }
}
