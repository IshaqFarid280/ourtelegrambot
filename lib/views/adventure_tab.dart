import 'package:flutter/material.dart';
import 'dart:html' as html; // Add this for browser back button handling
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/views/all_games/gameplay.dart';
import 'package:js/js.dart' as js;
import 'package:ourtelegrambot/widgets/custom_sizedBox.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart'; // Add this import

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
  @override
  void dispose() {
    // Hide Back Button when leaving AdventureTab

    super.dispose();
    coinController.hideoutallButton();
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

        body: Obx(
              () => coinController.totalHp.value < 1
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ninjaHpNeed,
                    width: MediaQuery.of(context).size.width*1,
                  ),

                  Sized(
                    height: 0.03,
                  ),
                   mediumText(
                       title:
                       "Your ninja is not ready to stealth!\nMinimum HP is 5 to play this game.",
                   fontSize: 15.0

                   ),
                ],
              )
              : const GameScreen(),
        ),
      ),
    );
  }
}
