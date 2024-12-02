import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';
import 'dart:js' as js;
import '../const/firebase_const.dart';

class GameController extends GetxController {


  void initializeTelegramBackButton() {
    // Calling the 'showBackButton' function from JavaScript in the index.html
    js.context.callMethod('showBackButton');
  }
  void hideoutallButton() {
    // Calling the 'showBackButton' function from JavaScript in the index.html
    js.context.callMethod('hideAllButtons');
  }
  RxList<dynamic> pictures = const [
    coin,
    coin,
    coin,
    coin,
    coin,
    coin,
    coin,
    // Icon(Icons.cancel_outlined, size: 50, color: Colors.red),
    // Icon(Icons.cancel_outlined, size: 50, color: Colors.red),
    // Icon(Icons.cancel_outlined, size: 50, color: Colors.red),
    // Icon(Icons.cancel_outlined, size: 50, color: Colors.red),
    Icon(Icons.cancel_outlined, size: 50, color: Colors.red),
    Icon(Icons.cancel_outlined, size: 50, color: Colors.red),
  ].obs;

  RxList<int> selectedPictures = <int>[].obs;
  RxInt tapCount = 3.obs;
  RxBool gameOver = false.obs;
  RxInt coins = 0.obs;
  RxList<bool> isRevealed = List<bool>.generate(9, (index) => false).obs;

  @override
  void onInit() {
    super.onInit();
    _fetchUserCoins();
    _shufflePictures();
  }

  Future<void> _fetchUserCoins() async {
    final userDoc = await fireStore.collection(user).doc(userTelegramId).get();
    coins.value = userDoc.data()?['coins'] ?? 0;
  }

  Future<void> _updateUserCoins(int amount) async {
    coins.value += amount;
    await fireStore.collection(user).doc(userTelegramId).update({
      'coins': coins.value,
    });
  }

  void _shufflePictures() {
    pictures.shuffle();
  }

  void selectPicture(int index) {
    if (selectedPictures.contains(index) || gameOver.value || tapCount.value <= 0) return;
    selectedPictures.add(index);
    isRevealed[index] = true;
    tapCount.value--;

    if (tapCount.value == 0) {
      _checkMatch();
    }
  }

  Future<void> _checkMatch() async {
    if (selectedPictures.every((index) => pictures[index] is String) &&
        selectedPictures.map((index) => pictures[index]).toSet().length == 1) {
      // All three pictures are the same and are coins (not icons)
      await _updateUserCoins(500);
    }
    gameOver.value = true;
  }

  void resetGame() {
    if (coins.value >= 500) {
      _showPurchaseDialog();
    } else {
      Get.snackbar(
        "Insufficient Coins",
        "You need at least 500 coins to play again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
        colorText: whiteColor,
      );
    }
  }

  void _showPurchaseDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: primaryTextColor,
        title: smallText(title: "Play Again?",fontWeight: FontWeight.w700, fontSize: 14.0 ),
        content: smallText(title: "Would you like to spend 500 coins to play again?",fontWeight: FontWeight.w400, fontSize: 13.0),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: smallText(title: "Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (coins.value >= 500) {
                _updateUserCoins(-500); // Deduct coins
                _restartGame(); // Reset game state
                Get.back(); // Close the dialog
              } else {
                Get.snackbar(
                  "Insufficient Coins",
                  "You don't have enough coins.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: redColor,
                  colorText: whiteColor,
                );
              }
            },
            child: smallText(title: "Buy",color: coinColors),
          ),
        ],
      ),
    );
  }

  void _restartGame() {
    tapCount.value = 3;
    selectedPictures.clear();
    gameOver.value = false;
    isRevealed.value = List<bool>.generate(9, (index) => false);
    _shufflePictures();
  }

  Future<bool> canPlayGame() async {
    final userDoc = await fireStore.collection(user).doc(userTelegramId).get();
    final lastPlayed = userDoc.data()?['lastPlayed']?.toDate();
    if (lastPlayed != null) {
      final now = DateTime.now();
      if (now.difference(lastPlayed).inHours < 24) {
        return false;
      }
    }
    await fireStore.collection(user).doc(userTelegramId).update({
      'lastPlayed': FieldValue.serverTimestamp(),
    });
    return true;
  }
}
