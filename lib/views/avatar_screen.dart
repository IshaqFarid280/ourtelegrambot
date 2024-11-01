import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
import '../const/colors.dart';
import '../const/firebase_const.dart';
import '../controller/avatar_controller.dart';
import '../serivices/firebase_services.dart';

class AvatarScreen extends StatelessWidget {
  const AvatarScreen({super.key});
  @override
  Widget build(BuildContext context) {
    var avatarController = Get.put(AvatarController());
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseServices.getUserData(userId: userTelegramId.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            var myAvatar = userData['my_avatars'] as List<dynamic>; // Access my_avatars as a list
            return SingleChildScrollView(
              padding: EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        width: MediaQuery.sizeOf(context).width * 0.6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryTextColor,
                          image: DecorationImage(image: AssetImage(userData['avatar'])),
                        ),
                      ),
                      CustomSized(width: 0.02,),
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: List.generate(myAvatar.length, (index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: (){
                                  avatarController.changeAvatarToAlreadyAvaliable(userId: userTelegramId.toString(), avatar: myAvatar[index]);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  height: MediaQuery.sizeOf(context).height * 0.15,
                                  width: MediaQuery.sizeOf(context).width * 0.32,
                                  decoration: BoxDecoration(
                                    color: secondaryTextColor,
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(image: AssetImage(myAvatar[index]), fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomSized(),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: avatar.length,
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4 / 6,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      bool isPurchased = myAvatar.contains(avatar[index]); // Check if the avatar is purchased
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(image: AssetImage(avatar[index])),
                            CustomSized(height: 0.03,),
                            isPurchased
                                ? Text('Already Bought') // Show message if already purchased
                                : avatarController.selectedIndex.value == index
                                ? avatarController.isLoading.value == true
                                ? CircularProgressIndicator()
                                : CustomButton(
                              color: splashColor,
                              imagePath: coin,
                                title: 'Buy ${avatarPrice[index]}', onTap: (){
                              avatarController.changeAvatar(
                                userId: userTelegramId.toString(),
                                avatar: avatar[index],
                                index: index,
                                price: avatarPrice[index],
                              );
                            })
                                : CustomButton(
                                imagePath: coin,
                               color: splashColor,
                                title: '${avatarPrice[index]}', onTap: (){
                              avatarController.changeAvatar(
                                userId: userTelegramId.toString(),
                                avatar: avatar[index],
                                index: index,
                                price: avatarPrice[index],
                              );
                            })
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
