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
  static getAcademydetails(){
    return fireStore.collection(academyTasks).snapshots();
  }

  static getleaderboarddetails(){
    return fireStore.collection(user).orderBy('coins',descending: true).get();
  }


//FirebaseFirestore.instance
//                           .collection('users')
//                           .doc(userTelegramId.toString())
//                           .snapshots(),


}