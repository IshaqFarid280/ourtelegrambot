import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/hud_view.dart';
import 'package:get/get.dart';
import 'package:shake_detector/shake_detector.dart';

import '../const/firebase_const.dart';
import '../serivices/firebase_services.dart';

class HomeTab extends GetView<CoinController> {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinController>(
      builder: (coinController) => ShakeDetectWrap(
        onShake: () {
          coinController.increaseCoins(userId: userTelegramId.toString(), context: context);
        },
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseServices.getUserData(userId: userTelegramId.toString()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            else if(snapshot.hasData)
            {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              coinController.coins.value = userData['coins'];
              coinController.earnPerTap.value = userData['tap_per_earn']['value'];
              coinController.coinPerSecond.value = userData['coin_per_second']['value'];
              coinController.hpCurrentValue.value = userData['hp']['value'];
              coinController.totalHp.value = userData['hp']['total_hp'];
              coinController.addEnergies(userId: userTelegramId.toString(), context: context,);
              coinController.makeCoinPerSecond(userId: userTelegramId.toString(), context: context);
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                               HudView(
                                label: 'Earn Per tap: ${userData['tap_per_earn']['value']}',
                                icon: Image.asset(coin,height: 30,width: 30,),
                              ),
                              const SizedBox(width: 8.0),
                              HudView(
                                label: 'HP ${userData['hp']['total_hp']}',
                                icon: Image.asset(health,height: 30,width: 30,),
                              ),
                              const SizedBox(width: 8.0),
                               HudView(
                                label: 'Coin per sec: ${userData['coin_per_second']['value']}',
                                icon: Image.asset(coin,height: 30,width: 30,),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    CustomSized(height: 0.1,),
                    GestureDetector(
                      onTap: () {
                        coinController.increaseCoins(userId: userTelegramId.toString(), context: context);
                        coinController.consumeEnergies(userId: userTelegramId.toString(), context: context);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        height: 300.0,
                        curve: Curves.easeInOut,
                        child: Image.asset(
                          userData['avatar'],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    CustomSized(height: 0.05,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(coin,height: 40,width: 40,),
                              CustomSized(height: 0,width: 0.02,),
                              Text(
                                'Coins: ${coinController.formatCoins(coinController.coins.value)}',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                          CustomSized(height: 0.05,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                    Image.network(energy,height: 40,width: 40),
                                    Text('${userData['energies']['value']}',style: TextStyle(color: Colors.white),),
                                ],
                              ),
                              CustomSized(width: 0.2,height: 0,),
                              ElevatedButton(
                                onPressed: () {
                                  coinController.buyHp(userId: userTelegramId.toString(), context: context);
                                },
                                child: Text(
                                    '${'Buy HP (-${coinController.upgradeCost}'} coins)'),
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
            else{
              return Text('Something went wrong');
            }
          },
        ),
      ),
    );
  }
}
