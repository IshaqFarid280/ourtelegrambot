import 'package:flutter/material.dart';
import 'dart:html' as html; // Add this for browser back button handling
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/views/all_games/gameplay.dart';
import 'package:js/js.dart' as js; // Add this import

class AdventureTab extends StatefulWidget {
  const AdventureTab({super.key});

  @override
  _AdventureTabState createState() => _AdventureTabState();
}

class _AdventureTabState extends State<AdventureTab> {

  // Initialize coinController at the class level
  final CoinController coinController = Get.put(CoinController());


  @override
  void initState() {
    super.initState();
    coinController.initializeTelegramBackButton();
  }
  Future<bool> _handleBackNavigation() async {
    Navigator.pop(context);
    return false;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
        ),
        body: Obx(
              () => coinController.totalHp.value < 1
              ? Center(
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
                    "Your ninja is not ready to stealth!\nMinimum HP is 5 to play this game."),
              ],
            ),
          )
              : const GameScreen(),
        ),
      ),
    );
  }
}
