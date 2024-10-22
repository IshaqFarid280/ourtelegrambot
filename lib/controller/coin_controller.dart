import 'dart:async';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../const/firebase_const.dart';

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



  String formatCoins(int coins) {
    if (coins >= 1000000000) {
      return '${(coins / 1000000000).toStringAsFixed(5)} B'; // Billions
    } else if (coins >= 1000000) {
      return '${(coins / 1000000).toStringAsFixed(5)} M'; // Millions
    } else if (coins >= 1000) {
      return '${(coins / 1000).toStringAsFixed(5)} k'; // Thousands
    } else {
      return coins.toString(); // Less than a thousand
    }
  }


  increaseCoins({required String userId, required BuildContext context}) async {
   try{
     var data = fireStore.collection(user).doc(userId);
     await data.update({
       'coins':FieldValue.increment(earnPerTap.value),
     });
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

  consumeEnergies({required String userId, required BuildContext context}) async {
    try {
      if (coins.value >= 0) { // Ensure user has at least 5 coins
        var data = fireStore.collection(user).doc(userId);
        await data.update({
          'energies.value': FieldValue.increment(-1),
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



}
