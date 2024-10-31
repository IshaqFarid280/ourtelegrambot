import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
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
            } else if (snapshot.hasData) {
              var userData = snapshot.data!.data() as Map<String, dynamic>;
              coinController.coins.value = userData['coins'];
              coinController.earnPerTap.value = userData['tap_per_earn']['value'];
              coinController.coinPerSecond.value = userData['coin_per_second']['value'];
              coinController.hpCurrentValue.value = userData['hp']['value'];
              coinController.totalHp.value = userData['hp']['total_hp'];
              coinController.addEnergies(userId: userTelegramId.toString(), context: context);
              coinController.makeCoinPerSecond(userId: userTelegramId.toString(), context: context);

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
                    GestureDetector(
                      onTap: () {
                        coinController.increaseCoins(userId: userTelegramId.toString(), context: context);
                        coinController.consumeEnergies(userId: userTelegramId.toString(), context: context);
                        coinController.triggerAnimation();
                        coinController.lastAddedCoins.value = coinController.earnPerTap.value; // Set the value to display
                        coinController.showFlyingNumber.value = true;
                        coinController.startPosition.value = Offset(
                          MediaQuery.of(context).size.width / 2,
                          250.0,
                        ); // This is where the number will start
                      },
                      child: Obx(() => Stack(
                        alignment: Alignment.center, // Center align the children
                        children: [
                          // Background Image
                          AnimatedScale(
                            duration: const Duration(milliseconds: 300),
                            scale: coinController.isTapped.value ? 1.2 : 1.0,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: coinController.isTapped.value ? 0.8 : 1.0,
                              child: Image.asset(
                                userData['avatar'],
                                height: 300.0,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Flying Number
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
                      )),
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
                                    'Coins: ${coinController.formatCoins(value)}',
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
                                  Image.network(energy, height: 40, width: 40, color: whiteColor),
                                  CustomSized(height: 0.01),
                                  Obx(
                                      ()=> AnimatedScale(
                                      duration: const Duration(milliseconds: 300),
                                      scale: coinController.isTapped.value ? 1.2 : 1.0,
                                      child: AnimatedOpacity(
                                        duration: const Duration(milliseconds: 300),
                                        opacity: coinController.isTapped.value ? 0.8 : 1.0,
                                        child: Text('${userData['energies']['value']}', style: TextStyle(color: Colors.white)),
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


class FlyingNumber extends StatefulWidget {
  final int number;
  final Offset startPosition; // New parameter
  final VoidCallback onAnimationComplete;

  const FlyingNumber({
    Key? key,
    required this.number,
    required this.startPosition,
    required this.onAnimationComplete,
  }) : super(key: key);

  @override
  _FlyingNumberState createState() => _FlyingNumberState();
}

class _FlyingNumberState extends State<FlyingNumber> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Adjust the end value here for higher flight
    _animation = Tween<double>(begin: 0, end: -200).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward().whenComplete(() {
      widget.onAnimationComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          left: widget.startPosition.dx - 20, // Center the number horizontally
          top: widget.startPosition.dy + _animation.value, // Move upwards
          child: Opacity(
            opacity: 1 - (_controller.value), // Fade out
            child: Text(
              '+${widget.number}', // Display the number
              style: const TextStyle(fontSize: 30, color: Colors.green, fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }
}

