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

class TelegramController extends GetxController {
  Map<String, dynamic>? telegramData;

  @override
  void onInit() {
    super.onInit();

        getTelegramData();


  }

  var name = ''.obs;
  var userId = ''.obs;
  var inviteduserCount = 0.obs; // Changed from List<dynamic> to int

  // void listenForReferralCode() {
  //   html.window.onMessage.listen((event) {
  //     if (event.data != null && event.data['referralCode'] != null) {
  //       referralCode = event.data['referralCode'];
  //       // referralCode = '1431684555';
  //       print('Received referral code: $referralCode');
  //
  //       // Show toast notification for debugging
  //       Get.snackbar(
  //         'Referral Code',
  //         'Received: $referralCode',
  //         snackPosition: SnackPosition.BOTTOM,
  //         duration: Duration(seconds: 3),
  //         backgroundColor: Colors.green,
  //         colorText: Colors.white,
  //       );
  //     } else {
  //       print('No referral code received');
  //       Get.snackbar(
  //         'Referral Code',
  //         'No referral code received',
  //         snackPosition: SnackPosition.BOTTOM,
  //         duration: Duration(seconds: 3),
  //         backgroundColor: Colors.red,
  //         colorText: Colors.white,
  //       );
  //     }
  //   });
  // }
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
    print('getTelegramData hiting }');
    telegramData = initTelegramWebApp();
    if (telegramData != null) {
      debugPrint('Telegram Data: $telegramData');
      var userId = telegramData?['user']?['id'].toString();
      var refferid = telegramData?['start_param']?.toString();
      var username = telegramData?['user']?['username'] ?? 'Unknown';
      var userprofileimagen = telegramData?['user']?['photo_url'];
      if (userId != null ) {
        userTelegramId = userId ;
        referid = refferid;
        userprofileiamge = userprofileimagen ;
        update();
        print('the user telegram id: ${userTelegramId}');
        print('the user referid before string: ${referid}');
        print('the user profile image id: ${userprofileiamge}');
        print('user referid after hiting string : ${referid?.toString}');
        saveUserData(userId: userId, userName: username, referralCodes: referid!);
      }
      // userId = userId ;
    } else {
      print('Before else hiting: ${referid?.toString}');
      userTelegramId = '1111111111111';
      saveUserData(userId: userTelegramId.toString(), userName: 'Ishaqfarid1', referralCodes: referid.toString());
    }

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
  Future<void> saveUserData({required String userId, required String userName,
    required  String  referralCodes}) async {
    print('print th in saveuserdata fucntion: ${referralCodes}');
    DateTime now = DateTime.now();
    DateTime yesterday = now.subtract(Duration(days: 1));
    Timestamp customTimestamp = Timestamp.fromDate(yesterday);
    var data = fireStore.collection(user).doc(userId);
    try {
      // Reference to the user's document
      DocumentReference userDocRef = fireStore.collection(user).doc(userId);

      // Check if the user document exists
      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        print('User already exists. Skipping saveUserData.');
        return; // Exit the function if user already exists
      }

      await data.set({
        'lastPlayed':customTimestamp,
        'is_online':false,
        'avatar': 'assets/10.png',
        'my_avatars': FieldValue.arrayUnion(['assets/10.png']),
        'user_name': userName,
        'user_id': userId,
        'coins': 5000000,
        'lastSpinTime': customTimestamp,
        'invited_users': [],
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
          'total_hp': 0,
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
          "level": 1,
          "value": 500,
          "max_energies": 500,
          "costs": [
            0, 1000, 5000, 10000, 20000, 40000, 80000, 120000, 160000, 220000,
            240000, 250000, 270000, 290000, 295000, 300000, 300000, 300000,
            300000, 300000, 300000
          ],
        },
      });
      if (referralCodes != userId) {
        try {
          DocumentReference referrerDocRef = fireStore.collection(user).doc(referralCodes);

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
                print('500 coins added for referral!');

              }
            }
          });
              } catch (e) {
          // Catch any errors and show them in a Snackbar
          print('Error during referral process: $e');
        }
      }
    } catch (e) {
      // Log or handle the error if there's a failure in the transaction or data saving process
      print('Failed to save user data: $e');
    }
  }



}
//   'invited_users': FieldValue.arrayUnion([userTelegramId]),
//           'coins': FieldValue.increment(500), // Deduct 5 coins