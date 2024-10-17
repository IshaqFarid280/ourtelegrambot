import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:js' as js;
import 'package:ourtelegrambot/const/firebase_const.dart';

class TelegramController extends GetxController {
  Map<String, dynamic>? telegramData;

  @override
  void onInit() {
    super.onInit();
    getTelegramData();
  }

  void getTelegramData() {
    telegramData = initTelegramWebApp();
    if (telegramData != null) {
      debugPrint('Telegram Data: $telegramData');
      var userId = telegramData?['user']?['id'].toString();
      var username = telegramData?['user']?['username'] ?? 'Unknown';
      if (userId != null) {
        userTelegramId = userId ;
        print(userTelegramId);
        saveUserData(userId: userId, userName: username);
      }
      userId = userId ;
    } else {
      userTelegramId = '6080705595';
      print(userTelegramId);
      debugPrint('Telegram data is null.');
    }
    update();
  }



  // Function to initialize the Telegram WebApp
  static Map<String, dynamic>? initTelegramWebApp() {
    final result = js.context.callMethod('initTelegramWebApp');
    debugPrint("result: $result");
    if (result != null) {
      // Convert JsObject to JSON string and then parse it to a Map
      String jsonString = js.context['JSON'].callMethod('stringify', [result]);
      return jsonDecode(jsonString);
    }

    return null;
  }

  // Function to send data back to Telegram
  static void sendTelegramData(String data) {
    js.context.callMethod('sendTelegramData', [data]);
  }

  // Function to control the MainButton in Telegram
  static void setMainButton(String text, bool isVisible) {
    js.context.callMethod('setMainButton', [text, isVisible]);
  }

  // Method to save initial user data
  Future<void> saveUserData({required String userId, required String userName}) async {
    var data = fireStore.collection('users').doc(userId);
    await data.set({
      'user_name': userName,
      'user_id': userId,
      'coins': 500,
      'energies':500,
      'tap_per_earn': {
        'level': 1,
        'value': 1,
        'costs': [
          0, 1000, 3000, 6000, 12000, 24000, 48000, 96000, 150000, 180000,
          190000, 195000, 198000, 199000, 200000, 200000, 200000, 200000,
          200000, 200000, 200000
        ]
      },
      'hp': {
        'level': 1,
        'value': 1,
        'total_hp':0,
        'costs': [
          0, 1000, 5000, 10000, 20000, 40000, 80000, 120000, 180000, 220000,
          230000, 240000, 245000, 250000, 250000, 250000, 250000, 250000,
          250000, 250000, 250000
        ]
      },
      'coin_per_second': {
        'level': 1,
        'value': 1,
        'costs': [
          0, 1000, 5000, 10000, 20000, 40000, 80000, 120000, 160000, 220000,
          240000, 250000, 270000, 290000, 295000, 300000, 300000, 300000,
          300000, 300000, 300000
        ]
      }
    });
  }
}
