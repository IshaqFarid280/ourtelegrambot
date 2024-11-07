



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
  buttonverification({
    required String collection,
    required String userId,
    required BuildContext context,
    required String docId}) async {
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



}