



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/firebase_const.dart';

class TasksController extends GetxController {


  markTasksCompleted({required String userId,required BuildContext context,required String docId}) async {
    try {
      var data = fireStore.collection(dailyTasks).doc(docId);
      await data.update({
        'completed': FieldValue.arrayUnion([
          userId
        ]),
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