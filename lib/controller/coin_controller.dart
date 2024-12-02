import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/firebase_const.dart';
import 'dart:js' as js;


class CoinController extends GetxController {
  var coins = 0.obs;
  var earnPerTap = 0.obs;
  var earnPerTapCurrent = 0.obs;
  var hpCurrentValue = 0.obs;
  var coinPerSecond = 0.obs;
  var coinPerSecondCurrent = 0.obs;
  var energiesCurrent = 0.obs;
  var addedEnergies = 0.obs;
  var iconData = Rx<IconData>(Icons.battery_full_outlined); // Initialize with an IconData
  var consumedEnergies = 0.obs;
  var totalHp = 0.obs;
  var spaceshipLevel = 0.obs;
  var energyPercentage = (0.0).obs;
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
  var referralCode = '';
  var totalEnergies = 0.obs;



  Future<void> regenerateEnergy(String userId) async {
    final userRef = FirebaseFirestore.instance.collection(user).doc(userId);

    try {
      // Fetch the user's document
      final userDoc = await userRef.get();
      if (!userDoc.exists) {
        throw Exception('User document does not exist.');
      }

      // Extract user data
      final data = userDoc.data();
      final int currentEnergy = data?['energies']['value'] ?? 0;
      final int maxEnergies = data?['energies']['max_energies'] ?? 0;
      Timestamp? lastOnlineTimestamp = data?['last_Online'];
      print(data?['last_Online']);

      // If last_Online is missing, set it to the current server timestamp
      if (lastOnlineTimestamp == null) {
        await userRef.update({
          'last_Online': FieldValue.serverTimestamp(),
        });
        print('last_Online was missing. Initialized with current server timestamp.');
        return;
      }

      // Calculate elapsed time since last online
      final DateTime lastOnline = lastOnlineTimestamp.toDate();
      final DateTime now = DateTime.now();
      final int elapsedSeconds = now.difference(lastOnline).inSeconds;

      // Calculate energy to add (+1 every 10 seconds)
      final int energyToAdd = (elapsedSeconds ~/ 10);

      // Update energy value (cap at maxEnergies)
      int updatedEnergy = currentEnergy + energyToAdd;
      if (updatedEnergy > maxEnergies) {
        updatedEnergy = maxEnergies;
      }

      // If no energy needs to be added, return early
      if (updatedEnergy == currentEnergy) {
        print('Energy is already at max or no time has passed to regenerate.');
        return;
      }

      // Update Firestore with the new energy value and current timestamp
      await userRef.update({
        'energies.value': updatedEnergy,
        'last_Online': FieldValue.serverTimestamp(),
      });

      print('Energy updated successfully: $updatedEnergy');
    } catch (e) {
      print('Error updating energy: $e');
    }
  }





  void initializeTelegramBackButton() {
    // Calling the 'showBackButton' function from JavaScript in the index.html
    js.context.callMethod('showBackButton');
  }
  void hideoutallButton() {
    // Calling the 'showBackButton' function from JavaScript in the index.html
    js.context.callMethod('hideAllButtons');
  }

  void _showAlert(String message) {
    // Calling the 'showAlert' function from JavaScript
    js.context.callMethod('showAlert', [message]);
  }


  consumeEnergies({required String userId, required BuildContext context}) async {
    try {
      if(energiesCurrent.value > 0){
        var data = fireStore.collection(user).doc(userId);
        await data.update({
          'energies.value': FieldValue.increment(consumedEnergies.value),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }

  consumeEnergiesOffline( int value){
    if(energiesCurrent.value > 0){
      energiesCurrent.value -=value;
      consumedEnergies.value -=value;
      print('addedEnergies.value ${consumedEnergies.value}');
    }
  }

  increaseCoinsOffline(int values){
    earnPerTap.value += (earnPerTapCurrent.value * values);
    coins.value += (earnPerTapCurrent.value * values);
    lastAddedCoins.value = values;
    triggerAnimation();
    animateCoinCount();
    print('earnPerTap.value ${earnPerTap.value}');
    print('coins.value ${coins.value}');
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

      //else if(energies > 0)
      // Get.snackbar(
      //   'Energies',
      //   'Please wait until the ninja is fully prepared.',
      //   snackPosition: SnackPosition.BOTTOM,
      //   duration: Duration(seconds: 3),
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,);
    }
  }

 Future<void> makeCoinPerSecondOffline() async {
   // If the timer is already running, do nothing
   if (_isTimerRunning) return;
    try{
      _isTimerRunning = true; // Set the flag to true so that multiple timers don't get started
      _timer = Timer.periodic(Duration(seconds: 5), (timer) {
        coinPerSecond.value += coinPerSecondCurrent.value;
        coins.value += coinPerSecondCurrent.value;
      });
    }catch(e){
      _isTimerRunning = false; // Reset the flag if the timer stops
    }
  }

  void makeCoinPerSecond({required String userId, required BuildContext context}) async {
    try {
      var data = fireStore.collection(user).doc(userId);
      await data.update({
        'coins': FieldValue.increment(coinPerSecond.value),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const  SnackBar(
          content: Text('Something went wrong while starting the timer'),
        ),
      );
    }
  }

  void addEnergies({required String userId, required BuildContext context}) async {
    try {
      if (energiesCurrent.value < totalEnergies.value) {
        var data = FirebaseFirestore.instance.collection(user).doc(userId);
        await data.update({
          'energies.value': FieldValue.increment(addedEnergies.value),
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong while starting the timer'),
        ),
      );
    }
  }
  addEnergiesOffline(){
    if (_isTimerRunning1) return;
    _timer1 = Timer.periodic(Duration(seconds: 7), (timer) async {
      try {
        if (energiesCurrent.value < totalEnergies.value) {
          energiesCurrent.value += 1;
          addedEnergies.value +=1;
          print('addedEnergies.value ${addedEnergies.value}');
        } else {
          timer.cancel();
          _isTimerRunning1 = false; // Reset the flag
        }
      } catch (e) {
        timer.cancel(); // Stop the timer in case of an error
        _isTimerRunning1 = false; // Reset the flag if the timer stops
      }
    });
  }


  void triggerAnimation() {
    isTapped.value = true;
    showFlyingNumber.value = true; // Trigger flying number animation
    // Reset animation state after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      isTapped.value = false;
      showFlyingNumber.value = false; // Trigger flying number animation
    });
  }

  void animateCoinCount() {
    displayedCoins.value = coins.value - earnPerTap.value; // Start from previous value
    Future.delayed(const Duration(milliseconds: 500), () {
      displayedCoins.value = coins.value; // Count up to current value
    });
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
