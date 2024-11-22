import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../const/firebase_const.dart';


class SetStatusController extends GetxController {

  var isOnline = false.obs;

  Future<void> setStatus({required bool isOnline}) async {
    try {
      var data = fireStore.collection(user).doc(userTelegramId);
      await data.update({
        'is_online': isOnline,
        'last_Online':FieldValue.serverTimestamp(),
      });
      update();
    } catch (e) {
      print("Error updating status: $e");
    }
  }

}