import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/firebase_const.dart';
import 'dart:html' as html;

class CoinController extends GetxController {
  var coins = 0.obs;
  var earnPerTap = 0.obs;
  var hpCurrentValue = 0.obs;
  var coinPerSecond = 0.obs;
  var totalHp = 0.obs;
  var spaceshipLevel = 0.obs;
  int upgradeCost = 50;
  bool _isTimerRunning = false;
  Timer? _timer;
  bool _isTimerRunning1 = false;
  Timer? _timer1;
  var isTapped = false.obs;
  var displayedCoins = 0.obs; // Used for counting-up animation
  var showFlyingNumber = false.obs;
  var lastAddedCoins = 0.obs;
  Rx<Offset> startPosition = Offset.zero.obs; // Position for flying number
  // var referralCode = '';


  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   print('the init functino o coin controller');
  //
  //   listenForReferralCode();
  //
  // }
  //
  // void listenForReferralCode()  {
  //   html.window.onMessage.listen((event) {
  //     if (event.data != null && event.data['referralCode'] != null) {
  //       print('the referral code of other user: $referralCode');
  //        referralCode = event.data['referralCode'];
  //       // referralCode =  '1431684555';
  //       processReferral(  referralCode);
  //     }
  //   });
  // }
  // Function to process referral code
  // Future<void> processReferral(String referralCode) async {
  //   print('process refferak ');
  //   try {
  //     final refUserDoc = fireStore.collection(user).doc(referralCode);
  //     final refUserSnapshot = await refUserDoc.get();
  //
  //     if (refUserSnapshot.exists) {
  //       // If referral ID exists, add current user ID to `invited_users` array
  //       await refUserDoc.update({
  //         'invited_users': FieldValue.arrayUnion([userTelegramId]),
  //         'coins': FieldValue.increment(500), // Deduct 5 coins
  //
  //       });
  //       print("User $userTelegramId added to invited_users of referral ID $referralCode");
  //
  //       Get.snackbar('Done', "User $userTelegramId added to invited_users of referral ID $referralCode");
  //
  //     } else {
  //       print("Referral code $referralCode does not match any user ID. the current user id: $userTelegramId");
  //       Get.snackbar('Error', "Referral code $referralCode does not match any user ID. the current user id: $userTelegramId");
  //
  //
  //     }
  //   } catch (e) {
  //     print('Error processing referral: $e');
  //     Get.snackbar('Error', "Error processing referral: $e");
  //   }
  // }



  // String formatCoins(int coins) {
  //   if (coins >= 1000000000) {
  //     return '${(coins / 1000000000).toStringAsFixed(1)} B'; // Billions
  //   } else if (coins >= 1000000) {
  //     return '${(coins / 1000000).toStringAsFixed(1)} M'; // Millions
  //   } else if (coins >= 1000) {
  //     return '${(coins / 1000).toStringAsFixed(1)} k'; // Thousands
  //   } else {
  //     return coins.toString(); // Less than a thousand
  //   }
  // }

  increaseCoins({required String userId, required BuildContext context, required int values}) async {
    try{
      var data = fireStore.collection(user).doc(userId);
      await data.update({
        'coins':FieldValue.increment(earnPerTap.value*values),
      });
      lastAddedCoins.value = earnPerTap.value; // Example number to display
      triggerAnimation();
      animateCoinCount();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  increaseCoinsInGame({required String userId, required BuildContext context}) async {
    try{
      var data = fireStore.collection(user).doc(userId);
      await data.update({
        'coins':FieldValue.increment(100),
      });
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  consumeEnergies({required String userId, required BuildContext context, required int inrementvalue}) async {
    try {
      if (coins.value >= 0) { // Ensure user has at least 5 coins
        var data = fireStore.collection(user).doc(userId);
        await data.update({
          'energies.value': FieldValue.increment(inrementvalue),
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your energies are low'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  buyHp({required String userId, required BuildContext context}) async {
    try {
      if (coins.value >= 5) { // Ensure user has at least 5 coins
        var data = fireStore.collection(user).doc(userId);
        await data.update({
          'coins': FieldValue.increment(-50), // Deduct 5 coins
          'hp.total_hp': FieldValue.increment(hpCurrentValue.value),
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You need at least 5 coins to buy HP'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  void makeCoinPerSecond({required String userId, required BuildContext context}) async {
    // If the timer is already running, do nothing
    if (_isTimerRunning) return;
    try {
      _isTimerRunning = true; // Set the flag to true so that multiple timers don't get started
      var data = fireStore.collection(user).doc(userId);
      _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
        try {
          var userSnapshot = await data.get();
          var userData = userSnapshot.data() as Map<String, dynamic>;
          coinPerSecond.value = userData['coin_per_second']['value'];
          await data.update({
            'coins': FieldValue.increment(coinPerSecond.value),
          });
        } catch (e) {
          timer.cancel(); // Stop the timer in case of an error
          _isTimerRunning = false; // Reset the flag if the timer stops
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const  SnackBar(
          content: Text('Something went wrong while starting the timer'),
        ),
      );
      _isTimerRunning = false; // Reset the flag in case of an exception
    }
  }

  consumeHpInGame({required String userId, required BuildContext context}) async {
    try {
      var data = fireStore.collection(user).doc(userId);
      await data.update({
        'hp.total_hp': FieldValue.increment(-1),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  void addEnergies({required String userId, required BuildContext context}) async {
    // If the timer is already running, do nothing
    if (_isTimerRunning1) return;
    try {
      _isTimerRunning1 = true; // Set the flag to true to prevent multiple timers
      var data = FirebaseFirestore.instance.collection(user).doc(userId);
      bool hasShownMaxEnergySnackbar = false; // Flag to track Snackbar status
      // Start the timer
      _timer1 = Timer.periodic(Duration(seconds: 6), (timer) async {
        try {
          var userSnapshot = await data.get();
          var userData = userSnapshot.data() as Map<String, dynamic>;
          // Check if current energy is less than maximum allowed energy
          if (userData['energies']['value'] < userData['energies']['max_energies']) {
            await data.update({
              'energies.value': FieldValue.increment(1),
            });
            hasShownMaxEnergySnackbar = false; // Reset Snackbar flag if energy is added
          } else {
            // Stop the timer since max energies reached
            timer.cancel();
            _isTimerRunning1 = false; // Reset the flag
          }
        } catch (e) {
          timer.cancel(); // Stop the timer in case of an error
          _isTimerRunning1 = false; // Reset the flag if the timer stops
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong while updating energies'),
            ),
          );
        }
      });
    } catch (e) {
      _isTimerRunning1 = false; // Reset the flag in case of an exception
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong while starting the timer'),
        ),
      );
    }
  }

  // Method to trigger scaling and fading animation
  void triggerAnimation() {
    isTapped.value = true;
    showFlyingNumber.value = true; // Trigger flying number animation
    // Reset animation state after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      isTapped.value = false;
      showFlyingNumber.value = false; // Trigger flying number animation
    });
  }

  // Method to animate the coin counting-up effect
  void animateCoinCount() {
    displayedCoins.value = coins.value - earnPerTap.value; // Start from previous value
    Future.delayed(const Duration(milliseconds: 500), () {
      displayedCoins.value = coins.value; // Count up to current value
    });
  }



}
