import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import '../const/firebase_const.dart';

class UpgradesController extends GetxController {

  var coins = Get.find<CoinController>().coins ;

  Future<void> upgradeAttribute(String userId, String attribute, BuildContext context) async {
    try {
      var userDoc = fireStore.collection(user).doc(userId);
      var userSnapshot = await userDoc.get();
      // Check if the user document exists
      if (userSnapshot.exists) {
        var userData = userSnapshot.data()!;
        int currentLevel = userData[attribute]['level'];
        int nextLevel = currentLevel + 1;
        List<dynamic> costs = userData[attribute]['costs'];
        // Check if next level is valid and the user has enough coins
        if (nextLevel <= 20 && nextLevel < costs.length && userData['coins'] >= costs[nextLevel]) {
          // Calculate the new value for the attribute at the next level
          int newValue = calculateNewValue(attribute, nextLevel);
          // Data to be updated in Firestore
          Map<String, dynamic> updateData = {
            '$attribute.level': nextLevel,  // Update level
            '$attribute.value': newValue,  // Update value
            'coins': FieldValue.increment(-costs[nextLevel]), // Deduct coins
          };
          // Special case for 'energies': also update 'max_energies'
          if (attribute == 'energies') {
            updateData['$attribute.max_energies'] = newValue;  // Sync max_energies with value
          }
          // Perform the update in Firestore
          await userDoc.update(updateData);
          coins.value = userData['coins'];
          Navigator.pop(context);
        } else {
          // If next level is invalid or insufficient coins
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cannot upgrade. Maximum level reached or insufficient coins.'),
            ),
          );
        }
      } else {
        // If the user document does not exist
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User not found.'),
          ),
        );
      }
    } catch (e) {
      // Handle any errors during the upgrade process
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error upgrading attribute: $e'),
        ),
      );
    }
  }

  // Calculate new value based on the attribute and level
  int calculateNewValue(String attribute, int level) {
    switch (attribute) {
      case 'tap_per_earn':
      // For 'tap_per_earn', the value doubles with each level
        return (level == 1) ? 2 : (calculateNewValue(attribute, level - 1) * 2);
      case 'hp':
      // For 'hp', the value increases by 4 with each level
        return (level == 1) ? 4 : (calculateNewValue(attribute, level - 1) + 4);
      case 'coin_per_second':
      // For 'coin_per_second', the value increases by 5 with each level
        return (level == 1) ? 5 : (calculateNewValue(attribute, level - 1) + 5);
      case 'energies':
      // For 'energies', the value increases by 250 with each level
        return (level == 1) ? 250 : (calculateNewValue(attribute, level - 1) + 250);
      default:
      // Default case for other attributes
        return 1;
    }
  }
}
