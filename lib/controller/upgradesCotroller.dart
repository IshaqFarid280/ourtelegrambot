

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/firebase_const.dart';

class UpgradesController extends GetxController {

  // Method to upgrade user attributes
  Future<void> upgradeAttribute(String userId, String attribute,context) async {
    try {
      var userDoc = fireStore.collection(user).doc(userId);
      var userSnapshot = await userDoc.get();
      if (userSnapshot.exists) {
        var userData = userSnapshot.data()!;
        // Get current level and costs for the next level
        int currentLevel = userData[attribute]['level'];
        int nextLevel = currentLevel + 1;
        List<dynamic> costs = userData[attribute]['costs'];
        // Check if next level is valid and user has enough coins
        if (nextLevel <= 20 && userData['coins'] >= costs[nextLevel]) {
          // Update user data
          int newValue = calculateNewValue(attribute, nextLevel);
          await userDoc.update({
            '$attribute.level': nextLevel,
            '$attribute.value': newValue,
            'coins': FieldValue.increment(-costs[nextLevel]), // Deduct coins
          });

        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot upgrade. Either maximum level reached or insufficient coins.'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text('Error upgrading attribute: $e'),
        ),
      );
    }
  }

  // Calculate new value based on attribute and level
  int calculateNewValue(String attribute, int level) {
    switch (attribute) {
      case 'tap_per_earn':
      // For tap_per_earn, the value doubles with each level
        return (level == 1) ? 2 : (calculateNewValue(attribute, level - 1) * 2); // Double the previous value
      case 'hp':
      // For HP, the value increases by 4 for each level
        return (level == 1) ? 4 : (calculateNewValue(attribute, level - 1) + 4); // Add 4 to the previous value
      case 'coin_per_second':
      // For coin_per_second, the value increases by 5 for each level
        return (level == 1) ? 5 : (calculateNewValue(attribute, level - 1) + 5); // Add 5 to the previous value
      default:
        return 1; // Default case
    }
  }

}