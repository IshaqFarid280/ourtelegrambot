

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/views/adventure_tab.dart';
import 'package:ourtelegrambot/views/all_games/GameScreen.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
import 'package:ourtelegrambot/widgets/hud_view.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/widgets/tripletap_gesture.dart';
import '../const/firebase_const.dart';
import '../controller/set_status_controller.dart';
import '../serivices/firebase_services.dart';
import '../widgets/custom_indicator.dart';
import '../widgets/fling_number.dart';
import 'all_games/spin_wheel_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab>  with  WidgetsBindingObserver {
  var statusController = Get.put(SetStatusController());
  var coinController = Get.put(CoinController());


  @override
  void initState() {
  super.initState();
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.addObserver(this);
  coinController.regenerateEnergy(userTelegramId.toString());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed ) {
      statusController.setStatus(isOnline: true);
      statusController.isOnline.value = true;
    } else {
      statusController.setStatus(isOnline: false).then((value){
        coinController.makeCoinPerSecond(userId: userTelegramId.toString(), context: context);
        coinController.increaseCoins(userId: userTelegramId.toString(), context: context);
        coinController.consumeEnergies(userId: userTelegramId.toString(), context: context);
        coinController.addEnergies(userId: userTelegramId.toString(), context: context);
        coinController.earnPerTap.value = 0;
        coinController.coinPerSecondCurrent.value = 0;
        coinController.coinPerSecond.value = 0;
        coinController.addedEnergies.value = 0 ;
        coinController.consumedEnergies.value = 0;
        coinController.earnPerTapCurrent.value = 0;
      });
      statusController.isOnline.value = false;
    }
  }


  @override
  Widget build(BuildContext context) {
    print('the user telegram id in home tab: ${ userTelegramId.toString()}');
    return GetBuilder<CoinController>(
      builder: (coinController) => StreamBuilder<DocumentSnapshot>(
        stream: FirebaseServices.getUserData(userId: userTelegramId.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomIndicator());
          }
          else if (snapshot.hasData) {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            coinController.coins.value = userData['coins'];
            coinController.earnPerTap.value = userData['tap_per_earn']['value'];
            coinController.earnPerTapCurrent.value = userData['tap_per_earn']['value'];
            coinController.coinPerSecond.value = userData['coin_per_second']['value'];
            coinController.coinPerSecondCurrent.value = userData['coin_per_second']['value'];
            coinController.hpCurrentValue.value = userData['hp']['value'];
            coinController.totalHp.value = userData['hp']['total_hp'];
            coinController.energiesCurrent.value = userData['energies']['value'];
            coinController.totalEnergies.value =  userData['energies']['max_energies'];
            coinController.addEnergiesOffline();
            coinController.makeCoinPerSecondOffline();
            coinController.energyPercentage.value = (coinController.energiesCurrent.value / coinController.totalEnergies.value) * 100;
            // Determine the color based on the energy percentage
            Color iconColor;
            if (coinController.energyPercentage.value > 80) {
              iconColor = Colors.green;
              coinController.iconData.value = Icons.battery_full_outlined;
            }
            else if (coinController.energyPercentage.value > 50) {
              iconColor = Colors.yellow;
              coinController.iconData.value = Icons.battery_6_bar_outlined;
            }
            else if (coinController.energyPercentage.value > 30) {
              iconColor = Colors.orange;
              coinController.iconData.value = Icons.battery_4_bar_outlined;
            }
            else {
              iconColor = Colors.red;
              coinController.iconData.value = Icons.battery_charging_full_outlined;
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
                      if(coinController.energiesCurrent.value > 0){
                        // Handle double tap (earn double coins)
                        coinController.consumeEnergiesOffline(2);
                        coinController.triggerAnimation();
                        coinController.increaseCoinsOffline(2);
                        coinController.showFlyingNumber.value = true;
                        coinController.startPosition.value = Offset(
                          MediaQuery.of(context).size.width / 2,
                          280.0,
                        );
                      }
          },
                    child: GestureDetector(
                      onTap: () {
                        if(coinController.energiesCurrent.value > 0){
                          coinController.triggerAnimation();
                          coinController.increaseCoinsOffline(1);
                          coinController.consumeEnergiesOffline(1);
                          coinController.showFlyingNumber.value = true;
                          coinController.startPosition.value = Offset(
                            MediaQuery.of(context).size.width / 2,
                            280.0,
                          );
                        }
                      },
                      child: ThreeFingerTapDetector(
                        onThreeFingerTap: () {
                         if(coinController.energiesCurrent.value > 0){
                           // Handle double tap (earn double coins)
                           coinController.increaseCoinsOffline(3);
                           coinController.consumeEnergiesOffline(3);
                           coinController.triggerAnimation();
                           coinController.showFlyingNumber.value = true;
                           coinController.startPosition.value = Offset(MediaQuery.of(context).size.width / 2, 280.0,); // This is where the number will start
                         }
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
                                width: 270.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Flying Number
                          Positioned(
                              left: MediaQuery.sizeOf(context).width * 0.00,
                              top: MediaQuery.sizeOf(context).height * 0.016,
                              child: HudViewSmall(
                                onTap: (){

                                  Get.to(()=> AdventureTab());
                                },
                                width: 0.2,
                                fontsize: 8.0,
                                height: 0.1,
                                label: 'Ninja',
                                icon: Image.asset(airPlane, width: 100,),)),
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
                                  Get.to(()=> GameScreen());
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
                                coinController.showFlyingNumber.value = false;
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
                            Obx(
                              ()=> TweenAnimationBuilder<int>(
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
                                Obx(()=> Icon(coinController.iconData.value,color: iconColor,size: 50,)),
                                CustomSized(height: 0.01),
                                Obx(
                                    ()=> AnimatedScale(
                                    duration: const Duration(milliseconds: 300),
                                    scale: coinController.isTapped.value ? 1.2 : 1.0,
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 300),
                                      opacity: coinController.isTapped.value ? 0.8 : 1.0,
                                      child: Text(coinController.energiesCurrent.value <= 0 ? '0':'${coinController.energiesCurrent.value}', style: TextStyle(color: coinController.isTapped.value ?  coinColors : whiteColor)),
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
          }
          else {
            return Text('Something went wrong');
          }
        },
      ),
    );
  }
}




