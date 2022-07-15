import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:lottie/lottie.dart';
import 'package:quran_pro/app/constant/color.dart';
import 'package:quran_pro/app/routes/app_pages.dart';

import '../controllers/introduction_controller.dart';

class IntroductionView extends GetView<IntroductionController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Quran Care',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'NGAJI BANG!?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 225,
            width: 225,
            child: Lottie.asset("assets/lotties/anim-quran2.json"),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () => Get.offAllNamed(Routes.HOME),
            child: Text(
              'Get Started',
              style: TextStyle(
                  color: Get.isDarkMode ? oldDrkGreen2 : whiteOld,
                  fontSize: 18),
            ),
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                primary: Get.isDarkMode ? whiteOld : oldDrkGreen2,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15)),
          )
        ],
      )),
    );
  }
}
