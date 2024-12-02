import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';

class AvatarController extends GetxController {
  var isLoading = false.obs;
  var selectedIndex = (-1).obs;

  // Method to change the avatar
  changeAvatar({required String userId,
    required String avatar,
    required String avatarname,
    required int index,
    required int price
  }) async {
    try {
      isLoading(true);
      selectedIndex.value = index;

      // Get the user's current data
      var userDoc = await fireStore.collection(user).doc(userId).get();
      var userData = userDoc.data() as Map<String, dynamic>;

      // Get the current coin balance
      int currentCoins = userData['coins'] ?? 0;

      // Check if the user has enough coins
      if (currentCoins >= price) {
        // Update avatar and coins in Firestore
        await fireStore.collection(user).doc(userId).update({
          'avatar': avatar,
          'coins': FieldValue.increment(-price),
          'my_avatars': FieldValue.arrayUnion([avatar]),
          'avatar_name':avatarname,
          'my_avatars_names':  FieldValue.arrayUnion([avatarname]),
        });
        // Reset loading state
        isLoading(false);
        selectedIndex.value = -1;
      } else {
        // Show Snackbar if not enough coins
        Get.snackbar(
          'Insufficient Coins',
          'You need ${price - currentCoins} more coins to purchase this avatar.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        // Reset loading state
        isLoading(false);
        selectedIndex.value = -1;
      }
    } catch (e) {
      // Handle errors
      isLoading(false);
      selectedIndex.value = -1;
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }


  changeAvatarToAlreadyAvaliable({required String userId, required String avatar, required String avatarname}) async {
    var userDoc = await fireStore.collection(user).doc(userId).get();
    await fireStore.collection(user).doc(userId).update({
      'avatar': avatar,
      'avatar_name':avatarname,
    });
}
}
