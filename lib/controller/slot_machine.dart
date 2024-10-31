import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slot_machine/slot_machine.dart';
import 'package:get/get.dart';
import '../const/firebase_const.dart';

class MySlotMachineController extends GetxController {
  late SlotMachineController _slotMachineController;
  var remainingPlays = 3.obs; // Observable to track remaining free plays
  var userCoins = 0.obs; // Observable to track user coins
  var extraAttempt = false.obs; // Observable to track if an extra attempt is purchased

  List<int> finalSlotValues = [0, 0, 0]; // Store final values for each slot
  int stopCount = 0; // Track how many slots have been stopped

  // Initialize the slot machine controller
  void init(SlotMachineController controller) {
    _slotMachineController = controller;
  }

  // Fetch user data to check free plays and coins
  Future<void> fetchUserData(String userId) async {
    try {
      var userDoc = await fireStore.collection(user).doc(userId).get();
      if (userDoc.exists) {
        var data = userDoc.data()!;
        int playCount = data['playCount'] ?? 0;
        Timestamp lastPlayTime = data['lastPlayTime'] ?? Timestamp(0, 0);
        int coins = data['coins'] ?? 0;
        userCoins.value = coins; // Update coins observable

        final currentTime = Timestamp.now();
        final differenceInHours = currentTime.toDate().difference(lastPlayTime.toDate()).inHours;

        // Reset playCount if 24 hours have passed
        if (differenceInHours >= 24) {
          playCount = 0;
          await fireStore.collection(user).doc(userId).update({
            'playCount': playCount,
            'lastPlayTime': Timestamp.now(),
          });
        }

        // Update remaining plays observable
        remainingPlays.value = 3 - playCount;
      }
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  // Function to start the slot machine
  Future<void> start({required String userId, required BuildContext context}) async {
    if (remainingPlays.value <= 0 && !extraAttempt.value) {
      _showPurchaseDialog(context, userId);
      return;
    }

    try {
      var userDoc = await fireStore.collection(user).doc(userId).get();
      if (userDoc.exists) {
        int hitRollItemIndex = 0; // Adjust as necessary

        _slotMachineController.start(hitRollItemIndex: hitRollItemIndex);
        var data = userDoc.data()!;
        int playCount = data['playCount'] ?? 0;
        if (playCount < 3) {
          playCount++;
          remainingPlays.value = 3 - playCount; // Update remaining plays
          await fireStore.collection(user).doc(userId).update({
            'playCount': playCount,
            'lastPlayTime': Timestamp.now(),
          });
        } else if (extraAttempt.value) {
          extraAttempt.value = false;
          remainingPlays.value = 0; // Reset remaining plays to 0
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  // Stop the specified reel and update the final slot values
  void stop(int index,context) {
    _slotMachineController.stop(reelIndex: index);
    finalSlotValues[index] = _getCurrentSlotValue(index); // Get the value of the stopped slot
    stopCount++;

    // If all slots have stopped, evaluate results
    if (stopCount == 3) {
      evaluateResults(context);
    }
  }

  // Get the current value of the slot based on its index
  int _getCurrentSlotValue(int index) {
    // Implement logic to retrieve the displayed value for the specified slot index.
    // Adjust this according to your package's way to get slot values.
    switch (index) {
      case 0: return 1000; // Replace with actual retrieval logic
      case 1: return 2000; // Replace with actual retrieval logic
      case 2: return 4000; // Replace with actual retrieval logic
      case 3: return 6000; // Replace with actual retrieval logic
      case 4: return 8000; // Replace with actual retrieval logic
      case 5: return 10000; // Replace with actual retrieval logic
      default: return 0;
    }
  }

  // Evaluate the results after all slots have stopped
  void evaluateResults(context) {
    if (finalSlotValues[0] == finalSlotValues[1] && finalSlotValues[1] == finalSlotValues[2]) {
      int prizeValue = finalSlotValues[0]; // Use the value of one of the matching slots

      final userId = userTelegramId.toString();
      increaseCoinsInGame(
        userId: userId,
        context: context, // You may want to pass context properly
        prizeValue: prizeValue,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No matching slots!')),
      );
    }
    // Reset for the next round
    stopCount = 0;
    finalSlotValues = [0, 0, 0]; // Reset the values for the next round
  }

  // Increment prize amount when user wins
  Future<void> increaseCoinsInGame({required String userId, required BuildContext context, required int prizeValue}) async {
    try {
      var data = fireStore.collection(user).doc(userId);
      await data.update({
        'coins': FieldValue.increment(prizeValue),
      });
      userCoins.value += prizeValue; // Update observable
    } catch (e) {
      print('Error updating coins: $e');
    }
  }

  // Show dialog to purchase an extra attempt
  void _showPurchaseDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Purchase Extra Attempt'),
          content: Text('Would you like to purchase an extra attempt for 100 coins?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                purchaseExtraAttempt(userId);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Purchase'),
            ),
          ],
        );
      },
    );
  }

  // Purchase an extra attempt
  Future<void> purchaseExtraAttempt(String userId) async {
    if (userCoins.value >= 500) {
      try {
        userCoins.value -= 500; // Deduct the cost from user coins
        extraAttempt.value = true; // Enable the extra attempt
        await fireStore.collection(user).doc(userId).update({
          'coins': FieldValue.increment(-500),
        });
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Extra attempt purchased!')),
        );
      } catch (e) {
        print('Error purchasing extra attempt: $e');
      }
    } else {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        const SnackBar(content: Text('Not enough coins!')),
      );
    }
  }

  // Check if the resultIndexes represent a winning combination
  bool isWinningCombination(List<int> resultIndexes) {
    // Check if all elements in resultIndexes are the same
    if (resultIndexes.isEmpty) return false;

    int firstValue = resultIndexes[0];
    for (int i = 1; i < resultIndexes.length; i++) {
      if (resultIndexes[i] != firstValue) {
        return false;
      }
    }
    return true;
  }
}
