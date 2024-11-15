import 'dart:convert';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:js' as js;
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'dart:html' as html;

class TelegramController extends GetxController {
  Map<String, dynamic>? telegramData;

  @override
  void onInit() {
    super.onInit();
    getTelegramData();
  }
  var name = ''.obs;
  var userId = ''.obs;

  var referralCode = '';

  void listenForReferralCode() {
    html.window.onMessage.listen((event) {
      if (event.data != null && event.data['referralCode'] != null) {
        // referralCode = event.data['referralCode'];
        referralCode = '1431684555';
        print('Received referral code: $referralCode');

        // Show toast notification for debugging
        Get.snackbar(
          'Referral Code',
          'Received: $referralCode',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        print('No referral code received');
        Get.snackbar(
          'Referral Code',
          'No referral code received',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    });
  }


  void copyToClipboard(String link, BuildContext context) {
    try {
      if (kIsWeb) {
        FlutterClipboard.copy(link).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Referral link copied to clipboard!'),
              duration: Duration(seconds: 1),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to copy referral link on web'),
              duration: Duration(seconds: 1),
            ),
          );
        });
      } else {
        Clipboard.setData(ClipboardData(text: link)).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Referral link copied to clipboard!'),
              duration: Duration(seconds: 1),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to copy referral link on mobile'),
              duration: Duration(seconds: 1),
            ),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Exception while copying referral link'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
  void getTelegramData() {
    telegramData = initTelegramWebApp();
    if (telegramData != null) {
      listenForReferralCode();
      debugPrint('Telegram Data: $telegramData');
      var userId = telegramData?['user']?['id'].toString();
      var username = telegramData?['user']?['username'] ?? 'Unknown';
      if (userId != null) {
        userTelegramId = userId ;
        print(userTelegramId);
        saveUserData(userId: userId, userName: username);
      }
      // userId = userId ;
    } else {
      userTelegramId = '6080705595';
      saveUserData(userId: userTelegramId.toString(), userName: 'Ishaqfarid1');
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
    var data = fireStore.collection(user).doc(userId);
    await data.set({
      'avatar':'assets/10.png',
      'my_avatars':FieldValue.arrayUnion(['assets/10.png']),
      'user_name': userName,
      'user_id': userId,
      'coins': 5000,
      'lastSpinTime':FieldValue.serverTimestamp(),
      'invited_users' : [],
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
      },
      "energies": {
        "level": 1,                   // Represents the user's current level
        "value": 500,                 // Represents the current energy value
        "max_energies": 500,
        "costs": [
          0,                            // Cost for level 0
          1000,                         // Cost for level 1
          5000,                         // Cost for level 2
          10000,                        // Cost for level 3
          20000,                        // Cost for level 4
          40000,                        // Cost for level 5
          80000,                        // Cost for level 6
          120000,                       // Cost for level 7
          160000,                       // Cost for level 8
          220000,                       // Cost for level 9
          240000,                       // Cost for level 10
          250000,                       // Cost for level 11
          270000,                       // Cost for level 12
          290000,                       // Cost for level 13
          295000,                       // Cost for level 14
          300000,                       // Cost for level 15
          300000,                       // Cost for level 16
          300000,                       // Cost for level 17
          300000,                       // Cost for level 18
          300000,                       // Cost for level 19
          300000                        // Cost for level 20
        ],
      },
    });

    // If referrer exists, add 20 bonus to their account
    print('the referal code is: ${referralCode}');
    if (referralCode != null && referralCode.isNotEmpty) {
      DocumentReference referrerDocRef = fireStore.collection(user).doc(referralCode);
      await fireStore.runTransaction((transaction) async {
        DocumentSnapshot referrerDoc = await transaction.get(referrerDocRef);
        if (referrerDoc.exists) {
          List<dynamic> referrals = referrerDoc.get('invited_users') ?? [];
          if (!referrals.contains(userId)) {
            referrals.add(userId);
            transaction.update(referrerDocRef, {
              'invited_users': referrals,
              'coins': FieldValue.increment(500),
            });

            // Toast for successful referral
            Get.snackbar(
              'Referral Bonus',
              '500 coins added for referral!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          }
        }
      });
    } else {
      // Toast for empty referral code
      Get.snackbar(
        'Referral Bonus',
        'No referral code available.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

  }
}
//   'invited_users': FieldValue.arrayUnion([userTelegramId]),
//           'coins': FieldValue.increment(500), // Deduct 5 coins