import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/views/all_games/slot_machine_screen.dart';
import 'package:ourtelegrambot/views/leaderboard_screen.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
import 'package:ourtelegrambot/widgets/hud_view.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/widgets/tripletap_gesture.dart';
import 'package:shake_detector/shake_detector.dart';
import '../const/firebase_const.dart';
import '../serivices/firebase_services.dart';
import '../widgets/custom_indicator.dart';
import '../widgets/fling_number.dart';
import 'all_games/spin_wheel_screen.dart';

class HomeTab extends GetView<CoinController> {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinController>(
      builder: (coinController) => ShakeDetectWrap(
        onShake: () {
          coinController.increaseCoins(userId: userTelegramId.toString(), context: context,values: 1);
        },
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseServices.getUserData(userId: userTelegramId.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CustomIndicator());
            } else if (snapshot.hasData) {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              coinController.coins.value = userData['coins'];
              coinController.earnPerTap.value = userData['tap_per_earn']['value'];
              coinController.coinPerSecond.value = userData['coin_per_second']['value'];
              coinController.hpCurrentValue.value = userData['hp']['value'];
              coinController.totalHp.value = userData['hp']['total_hp'];
              coinController.totalEnergies.value =  userData['energies']['max_energies'];
              coinController.addEnergies(userId: userTelegramId.toString(), context: context);
              coinController.makeCoinPerSecond(userId: userTelegramId.toString(), context: context);
              double energyPercentage = (userData['energies']['value'] / controller.totalEnergies.value) * 100;
              // Determine the color based on the energy percentage
              Color iconColor;
              IconData iconData;
              if (energyPercentage > 80) {
                iconColor = Colors.green;
                iconData = Icons.battery_full_outlined;
              } else if (energyPercentage > 50) {
                iconColor = Colors.yellow;
                iconData = Icons.battery_6_bar_outlined;
              } else if (energyPercentage > 30) {
                iconColor = Colors.orange;
                iconData = Icons.battery_4_bar_outlined;
              } else {
                iconColor = Colors.red;
                iconData = Icons.battery_charging_full_outlined;
              }
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              HudView(
                                label: 'Earn Per tap: ${userData['tap_per_earn']['value']}',
                                icon: Image.asset(coin, height: 30, width: 30),
                              ),
                              const SizedBox(width: 8.0),
                              HudView(
                                label: 'HP ${userData['hp']['total_hp']}',
                                icon: Image.asset(health, height: 30, width: 30),
                              ),
                              const SizedBox(width: 8.0),
                              HudView(
                                label: 'Coin per sec: ${userData['coin_per_second']['value']}',
                                icon: Image.asset(coin, height: 30, width: 30),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomSized(height: 0.05),
                    TwoFingerTapDetector(
                      onTwoFingerTap: () {
            // Handle double tap (earn double coins)
            coinController.increaseCoins(userId: userTelegramId.toString(), context: context,values: 2 );
            coinController.consumeEnergies(userId: userTelegramId.toString(), context: context, inrementvalue: -2);
            coinController.triggerAnimation();
            coinController.lastAddedCoins.value = coinController.earnPerTap.value + 2; // Set the value to display for double tap
            coinController.showFlyingNumber.value = true;
            coinController.startPosition.value = Offset(
            MediaQuery.of(context).size.width / 2,
            280.0,
            ); // This is where the number will start
            },
                      child: GestureDetector(
                        onTap: () {
                          coinController.increaseCoins(userId: userTelegramId.toString(), context: context,values: 1 );
                          coinController.consumeEnergies(userId: userTelegramId.toString(), context: context, inrementvalue: -1);
                          coinController.triggerAnimation();
                          coinController.lastAddedCoins.value = coinController.earnPerTap.value; // Set the value to display
                          coinController.showFlyingNumber.value = true;
                          coinController.startPosition.value = Offset(
                            MediaQuery.of(context).size.width / 2,
                            280.0,
                          ); // This is where the number will start
                        },
                        child: ThreeFingerTapDetector(
                          onThreeFingerTap: () {
                            // Handle double tap (earn double coins)
                            coinController.increaseCoins(userId: userTelegramId.toString(), context: context,values: 3 );
                            coinController.consumeEnergies(userId: userTelegramId.toString(), context: context, inrementvalue: -3);
                            coinController.triggerAnimation();
                            coinController.lastAddedCoins.value = coinController.earnPerTap.value + 3; // Set the value to display for double tap
                            coinController.showFlyingNumber.value = true;
                            coinController.startPosition.value = Offset(
                              MediaQuery.of(context).size.width / 2,
                              280.0,
                            ); // This is where the number will start
                          },
                       child:  Obx(() => Stack(
                          alignment: Alignment.center, // Center align the children
                          children: [
                            // Background Image
                            AnimatedScale(
                              duration: const Duration(milliseconds: 300),
                              scale: coinController.isTapped.value ? 1.0 : 0.8,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: coinController.isTapped.value ? 0.8 : 1.0,
                                child: Image.asset(
                                  userData['avatar'],
                                  height: 270.0,
                                  width: 270.0, // Match width and height for a consistent size
                                  fit: BoxFit.cover, // Use BoxFit.cover to keep the image within bounds when scaling
                                ),
                              ),
                            ),
                            // Flying Number
                            Positioned(
                                left: 16,
                                top: 16,
                                child: HudViewSmall(
                                  onTap: (){
                                    print("HudViewSmall tapped!"); // Debug print
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LeaderboardScreen(
                                      userid: userTelegramId.toString(),
                                    )));
                                  },
                                  width: 0.18,
                                  fontsize: 8.0,
                                  height: 0.06,
                                  label: 'Leaderboard',
                                  icon: Image.asset(leaderboard, width: 20, height: 20),)),
                            Positioned(
                                right: MediaQuery.sizeOf(context).width * 0.005,
                                top: MediaQuery.sizeOf(context).height * 0.016,
                                child: HudViewSmall(
                                  onTap: (){
                                    Get.to(()=> SpinWheelScreen());
                                  },
                                  width: 0.2,
                                  fontsize: 8.0,
                                  height: 0.08,
                                  issizedbox: true,
                                  label: null,
                                  icon: Image.asset(spinWheel, width: 50,),)),
                            Positioned(
                                right: MediaQuery.sizeOf(context).width * 0.005,
                                top: MediaQuery.sizeOf(context).height * 0.12,
                                child: HudViewSmall(
                                  onTap: (){
                                    Get.to(()=> SlotMachineScreen());
                                  },
                                  width: 0.2,
                                  fontsize: 8.0,
                                  height: 0.08,
                                  issizedbox: true,
                                  label: null,
                                  icon: Image.asset(slotMachine, width: 50,),)),
                            if (coinController.showFlyingNumber.value)
                              FlyingNumber(
                                number: coinController.lastAddedCoins.value, // Number to display
                                startPosition: coinController.startPosition.value, // Pass the starting position
                                onAnimationComplete: () {
                                  // After animation completes, we can reset the flag
                                  coinController.showFlyingNumber.value = false;
                                  // Trigger an additional build to allow for new flying number on next tap
                                  Future.delayed(const Duration(milliseconds: 100), () {
                                    coinController.showFlyingNumber.value = true; // Allow the next flying number
                                  });
                                },
                              ),
                          ],
                        )),),
                      ),
                    ),
                    CustomSized(height: 0.03),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(coin, height: 40, width: 40),
                              CustomSized(height: 0, width: 0.02),
                              TweenAnimationBuilder<int>(
                                tween: IntTween(
                                    begin: 0, end: coinController.coins.value),
                                duration: const Duration(milliseconds: 500),
                                builder: (context, value, child) {
                                  return Text(
                                    'Coins: ${value}',
                                    style: const TextStyle(fontSize: 20),
                                  );
                                },
                              ),
                            ],
                          ),
                          CustomSized(height: 0.03),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(iconData,color: iconColor,size: 50,),
                                  CustomSized(height: 0.01),
                                  Obx(
                                      ()=> AnimatedScale(
                                      duration: const Duration(milliseconds: 300),
                                      scale: coinController.isTapped.value ? 1.2 : 1.0,
                                      child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 300),
                                        opacity: coinController.isTapped.value ? 0.8 : 1.0,
                                        child: Text('${userData['energies']['value']}', style: TextStyle(color: coinController.isTapped.value ?  coinColors : whiteColor)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CustomSized(width: 0.2, height: 0),
                              CustomButton(
                                title: '${'Buy HP (-${coinController.upgradeCost}'} coins)',
                                onTap: () {
                                  coinController.buyHp(userId: userTelegramId.toString(), context: context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Text('Something went wrong');
            }
          },
        ),
      ),
    );
  }
}




