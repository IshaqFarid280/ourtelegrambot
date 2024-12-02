import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
import 'package:ourtelegrambot/widgets/custom_sizedBox.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';

import '../../controller/GameController.dart';


class GameScreen extends StatefulWidget {
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final GameController controller = Get.put(GameController());



  @override
  void initState() {
    super.initState();
    controller.initializeTelegramBackButton();
  }

  @override
  void dispose() {
    super.dispose();
    controller.hideoutallButton();
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

        body: FutureBuilder<bool>(
          future: controller.canPlayGame(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data == false) {
              return
              Column(
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
                      "You can now play in 24 hours.",
                      fontSize: 15.0

                  ),
                ],
              );



            }
            return Obx(() {
              return Column(
                children: [
                  Sized(height: 0.02),
                  Obx(()=> Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(coin,width: 50,),
                      Sized(width: 0.05,),
                      mediumText(title: "Coins: ${controller.coins.value}"),
                    ],
                  )),
                  Sized(height: 0.02),
                  Obx(()=> smallText(title: "Attempts Left : ${controller.tapCount.value}")),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      itemCount: controller.pictures.length,
                      itemBuilder: (context, index) {
                        return Obx(
                            ()=> GestureDetector(
                            onTap: () => controller.selectPicture(index),
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: primaryTextColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: controller.isRevealed[index]
                                    ? (controller.pictures[index] is String
                                    ? Image.asset(
                                  controller.pictures[index], // Assuming it's an asset path
                                  fit: BoxFit.cover,
                                )
                                    : controller.pictures[index] as Icon)
                                    : const Icon(Icons.question_mark, color: Colors.white), // Hidden state
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (controller.gameOver.value)
                    CustomButton(title: 'Play Again', onTap: controller.resetGame)
                ],
              );
            });
          },
        ),
      ),
    );
  }
}
