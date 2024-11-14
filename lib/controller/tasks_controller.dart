



import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../const/firebase_const.dart';

class TasksController extends GetxController {


  markTasksCompleted({required String collection,required String userId,required int  coinprice, required BuildContext context,required String docId}) async {
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
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
  }
  markTasksCompletedwithpopNavigation({required String collection,required String userId,required int  coinprice, required BuildContext context,required String docId}) async {
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
  buttonverification({required String collection, required String userId, required BuildContext context, required String docId}) async {
    try {
      var data = fireStore.collection(collection).doc(docId);
      await data.update({
        'button_navigator': FieldValue.arrayUnion([
          {
            'user_id': userId,
            'status': 'true'
          }
        ])
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
        ),
      );
    }
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
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['ok'] == true) {
          final String status = data['result']['status'];
          // If the user is a member, update Firestore
          if (['member', 'administrator', 'creator'].contains(status)) {
            await markTasksCompleted(
              collection: collection,
              userId: userId,
              coinprice: coin,
              context: context,
              docId: docId,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User verified and task completed!')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User is not a member of the channel')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to verify user membership')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e, s) {
      print(e.toString);
      print(s.toString);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()} + ${s.toString()}')),
      );
    }
  }


}