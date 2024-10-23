// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
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
      body: Obx(
          ()=> coinController.totalHp.value < 5 ?
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/broken.jpg",
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                      "Your spaceship not ready to ship!\nMinimum HP is 5 to play this game.")
                ],
              ),
            ):
           const GameScreen(),
      ),
    );
  }
}
