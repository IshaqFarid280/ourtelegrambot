import 'package:ourtelegrambot/const/firebase_const.dart';

class FirebaseServices {

  static getUserData({required String userId}){
    return fireStore.collection(user).doc(userId).snapshots();
  }

  static showDailyTasks(){
    return fireStore.collection(dailyTasks).snapshots();
  }
  static showAllTasks(){
    return fireStore.collection(allTasks).snapshots();
  }
  static showSocialTasks(){
    return fireStore.collection(socialTasks).snapshots();
  }
  static showFrensTasks(){
    return fireStore.collection(frensTasks).snapshots();
  }
  static getAcademydetails(){
    return fireStore.collection(academyTasks).snapshots();
  }

  static getleaderboarddetails({required String userId}){
    return fireStore.collection(user).get();
  }


//FirebaseFirestore.instance
//                           .collection('users')
//                           .doc(userTelegramId.toString())
//                           .snapshots(),


}