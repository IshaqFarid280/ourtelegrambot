// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/views/all_games/gameplay.dart';
import 'package:get/get.dart';

class AdventureTab extends StatefulWidget {
  const AdventureTab({super.key});

  @override
  _AdventureTabState createState() => _AdventureTabState();
}

class _AdventureTabState extends State<AdventureTab> {
  @override
  Widget build(BuildContext context) {
    var coinController = Get.put(CoinController());
    return Scaffold(
      appBar:AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: Obx(
          ()=> coinController.totalHp.value < 1 ?
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ninjaHpNeed,
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                      "Your ninja is not ready to stealth!\nMinimum HP is 5 to play this game.")
                ],
              ),
            ):
           const GameScreen(),
      ),
    );
  }
}
