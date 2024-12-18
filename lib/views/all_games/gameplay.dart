// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:get/get.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  final CoinController coinController = Get.find();

  double birdY = 0;
  double initialPosition = 0;
  bool gameStarted = false;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;
  // int score = 0;

  double obstacleX = 2;
  double obstacleSize = 50;

  late Timer timer;

  void startGame() {
    gameStarted = true;
    time = 0;
    initialPosition = birdY;

    // Collision threshold to define proximity needed for a collision
    const double collisionThresholdY = 0.1; // Adjust for vertical proximity
    const double collisionThresholdX = 0.15; // Adjust for horizontal proximity

    timer = Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.04;
      height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialPosition - height;

        // Move obstacle back to the right if it passes the left edge
        if (obstacleX < -1.5) {
          obstacleX += 3;
          obstacleSize = Random().nextDouble() * 100 + 20;
          coinController.coins.value += 100;
          coinController.increaseCoinsInGame(userId: userTelegramId.toString(), context: context);
        } else {
          obstacleX -= 0.05;
        }

        // Calculate distances between bird and obstacle
        double horizontalDistance = (0 - obstacleX).abs(); // X-axis distance
        double verticalDistance = (birdY - (-0.4)).abs();  // Y-axis distance

        // Detect collision based on proximity in both axes
        bool hasCollidedWithObstacle = horizontalDistance < collisionThresholdX &&
            verticalDistance < (obstacleSize / 200) + collisionThresholdY;

        // Check for game boundaries or collision
        if (birdY > 1 || birdY < -1 || hasCollidedWithObstacle) {
          timer.cancel();
          showGameOverDialog();
        }
      });
    });
  }


  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Game Over"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  resetGame();
                },
                child: const Text("Play Again"))
          ],
        );
      },
    );
  }

  void resetGame() {
    Navigator.of(context).pop();
    setState(() {
      birdY = 0;
      gameStarted = false;
      time = 0;
      // score = 0;
      coinController.totalHp.value -= 1;
      obstacleX = 2;
      obstacleSize = 50;
      coinController.consumeHpInGame(userId: userTelegramId.toString(), context: context);
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPosition = birdY;
    });
  }

  Future<bool> _handleBackNavigation() async {
    Navigator.pop(context);
    return false;
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: GetBuilder<CoinController>(builder: (coinController) {
        return GestureDetector(
          onTap: () {
            if (gameStarted) {
              jump();
            } else {
              startGame();
            }
          },
          child: Scaffold(
            body: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.blue,
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          alignment: Alignment(0, birdY),
                          duration: const Duration(milliseconds: 0),
                          color: Colors.black,
                          child: const MyBird(),
                        ),
                        Container(
                          alignment: const Alignment(0, -0.3),
                          child: gameStarted
                              ? const Text(
                                  "",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                )
                              : const Text(
                                  "Tap To Play",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                        ),
                        AnimatedContainer(
                          alignment: Alignment(obstacleX, -0.4),
                          duration: const Duration(milliseconds: 0),
                          child: MyObstacle(
                            size: obstacleSize,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.monetization_on,
                                          color: Colors.amber),
                                      const SizedBox(width: 8),
                                      Text(
                                        coinController.coins.value.toString(),
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.favorite,
                                          color: Colors.red),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "HP ",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        coinController.totalHp.value
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 15,
                  color: Colors.green,
                ),
                Expanded(
                  child: Container(
                    color: Colors.brown,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class MyBird extends StatelessWidget {
  const MyBird({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 50,
        height: 50,
        // decoration: BoxDecoration(
        //   color: Colors.yellow,
        //   shape: BoxShape.circle,
        // ),
        child: Image.asset(
          ninjaGame,
        ));
  }
}

class MyObstacle extends StatelessWidget {
  final double size;

  MyObstacle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage(obstacle),fit: BoxFit.cover,),
        shape: BoxShape.circle,
      ),
    );
  }
}
