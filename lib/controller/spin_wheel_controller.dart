import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:math';

import '../const/firebase_const.dart';

class SpinWheelController extends GetxController {
  final List<String> items = ['100', '200', '400', '600', '800', '5000'];
  final StreamController<int> selected = StreamController<int>();
  var selectedItem = ''.obs;

  @override
  void onClose() {
    selected.close();
    super.onClose();
  }

  // Update this function to increment the prize amount
  increaseCoinsInGame({required String userId, required BuildContext context}) async {
    try {
      int prizeAmount = int.parse(selectedItem.value);
      var data = fireStore.collection(user).doc(userId);
      await data.update({
        'coins': FieldValue.increment(prizeAmount),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  void spinWheel(String userId, BuildContext context) {
    final randomIndex = getRandomIndexBasedOnWeights();
    selected.add(randomIndex);
    selectedItem.value = items[randomIndex];

    // Call the function to increment coins
    increaseCoinsInGame(userId: userId, context: context);
  }

  int getRandomIndexBasedOnWeights() {
    final List<double> weights = [80.0, 40.0, 40.0, 20.0, 0.5]; // Cumulative weights (percent)
    final List<double> cumulativeWeights = [];
    double totalWeight = 0.0;

    for (var weight in weights) {
      totalWeight += weight;
      cumulativeWeights.add(totalWeight);
    }

    final randomValue = Random().nextDouble() * totalWeight;

    for (int i = 0; i < cumulativeWeights.length; i++) {
      if (randomValue < cumulativeWeights[i]) {
        return i; // Return the index of the selected item
      }
    }

    return 0; // Fallback (should not happen)
  }
}

