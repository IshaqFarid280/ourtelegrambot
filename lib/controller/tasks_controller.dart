



import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ourtelegrambot/const/colors.dart';

import '../const/firebase_const.dart';

class TasksController extends GetxController {
  var isloadingIndicator = false.obs; // Observable for loading state


  markTasksCompleted({required String collection,required String userId,
    required int  coinprice, required BuildContext context,required String docId}) async {
    try {
      isloadingIndicator.value = true;
      var data = fireStore.collection(collection).doc(docId);
      await data.update({
        'completed': FieldValue.arrayUnion([
          userId
        ]),
      }).then((value){
        isloadingIndicator.value = false;
        var data = fireStore.collection(user).doc(userId);
        data.update({
          'coins':FieldValue.increment(coinprice),
        });
      });
    } catch (e) {
      isloadingIndicator.value = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }
  markTasksCompletedwithpopNavigation({required String collection,
    required String userId,required int  coinprice, required BuildContext context,
    required String docId}) async {
    try {
      var data = fireStore.collection(collection).doc(docId);
      await data.update({
        'completed': FieldValue.arrayUnion([
          userId
        ]),
      }).then((value){
        var data = fireStore.collection(user).doc(userId);
        data.update({
          'coins':FieldValue.increment(coinprice),
        });
      }).then((value){
        Navigator.pop(context);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }
  buttonverification({required String collection, required String userId,
    required BuildContext context, required String docId}) async {
    try {
      isloadingIndicator.value = true;
      var data = fireStore.collection(collection).doc(docId);
      await data.update({
        'button_navigator': FieldValue.arrayUnion([
          {
            'user_id': userId,
            'status': 'true'
          }
        ])
      });

      isloadingIndicator.value = false;
    }
    on TimeoutException catch(e){
      isloadingIndicator.value = false;
      Get.snackbar('Error', 'Time out Exception. Try Again', backgroundColor: Colors.red.withOpacity(0.8), colorText: whiteColor);
    }
     on SocketException catch(_){
      isloadingIndicator.value = false;
      Get.snackbar('Error', 'Network Connectivity Lost. Try Again', backgroundColor: Colors.red.withOpacity(0.8), colorText: whiteColor);
     }
    catch (e) {
      debugPrint(e.toString());
      isloadingIndicator.value = false;
      Get.snackbar('Error', 'Something went wrong', backgroundColor: Colors.red.withOpacity(0.8), colorText: whiteColor);
    }
  }

  Future<void> removeuserfromnavigator(
      String collection,
      String docId,
      String userId,

      )async{
    var data  = fireStore.collection(collection).doc(docId);
    await data.update({
      'button_navigator': FieldValue.arrayRemove([
  {
    'user_id' : userId,
    'status': 'true'
  }
      ])
    });

  }


  // New method to verify user membership in the Telegram channel
  Future<void> verifyUserMembership({
    required String botToken,
    required String channelId,
    required String userId,
    required int coin,
    required String collection,
    required String docId,
    required BuildContext context,
  }) async {


    final url = Uri.parse(
      'https://api.telegram.org/bot$botToken/getChatMember?chat_id=$channelId&user_id=$userId',
    );

    try {
      isloadingIndicator.value = true;
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['ok'] == true) {
          isloadingIndicator.value = false;
          final String status = data['result']['status'];
          if (['member', 'administrator', 'creator'].contains(status)) {
            await markTasksCompleted(
              collection: collection,
              userId: userId,
              coinprice: coin,
              context: context,
              docId: docId,
            );
            Get.snackbar(
                      'Verified',
                      'User verified and task completed!',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: Duration(seconds: 2),
                      backgroundColor: Colors.green.withOpacity(800),
                      colorText: Colors.white,
                    );

          } else {
            isloadingIndicator.value = false;
            removeuserfromnavigator(collection, docId, userId);
            Get.snackbar(
              'Failed',
              'User is not a member of the channel. Join again',
              snackPosition: SnackPosition.BOTTOM,
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red.withOpacity(800),
              colorText: Colors.white,
            );

          }
        } else {
          isloadingIndicator.value = false;
          Get.snackbar(
            'Failed',
            'Failed to verify user membership',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red.withOpacity(800),
            colorText: Colors.white,
          );

        }
      } else {
        isloadingIndicator.value = false;
        Get.snackbar(
          'Error',
          'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red.withOpacity(800),
          colorText: Colors.white,
        );

      }
    } catch (e, s) {
      isloadingIndicator.value = false;
      print(e.toString);
      print(s.toString);
      Get.snackbar(
        'Error',
        'Unexpected Error Comes',
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red.withOpacity(800),
        colorText: Colors.white,
      );

    }
  }
}