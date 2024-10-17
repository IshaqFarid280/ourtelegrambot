import 'package:ourtelegrambot/const/firebase_const.dart';

class FirebaseServices {

  static getUserData({required String userId}){
    return fireStore.collection(user).doc(userId).snapshots();
  }

  static showDailyTasks(){
    return fireStore.collection(dailyTasks).snapshots();
  }



}