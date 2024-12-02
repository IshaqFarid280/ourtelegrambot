import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
import 'package:ourtelegrambot/widgets/custom_indicator.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';
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
            return Center(child: CustomIndicator());
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            var myAvatar = userData['my_avatars'] as List<dynamic>; // Access my_avatars as a list
            var myAvatarnameslist = userData['my_avatars_names'] as List<dynamic>; // Access my_avatars as a list
            return SingleChildScrollView(
              padding: EdgeInsets.all(10),
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.bottomLeft,


                            child: mediumText(title: userData['avatar_name'].toString(), fontSize: 14.0)),
                        alignment: Alignment.center,
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        width: MediaQuery.sizeOf(context).width * 0.7,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryTextColor,
                          image: DecorationImage(image: AssetImage(userData['avatar'])),
                        ),
                      ),
                      CustomSized(width: 0.02,),
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.3,
                        width: MediaQuery.sizeOf(context).width * 0.2,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: List.generate(myAvatar.length, (index) {
                              return InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: (){
                                  avatarController.changeAvatarToAlreadyAvaliable(
                                      userId: userTelegramId.toString(),
                                      avatar: myAvatar[index],
                                    avatarname: userData['avatar_name'].toString(),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 5),
                                  height: MediaQuery.sizeOf(context).height * 0.08,
                                  width: MediaQuery.sizeOf(context).width * 0.15,
                                  decoration: BoxDecoration(
                                    color: secondaryTextColor,
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(image: AssetImage(myAvatar[index]),

                                        fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomSized(height: 0.025,),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: avatar.length,
                    gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio:  3.8 / 5,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                    ),
                    itemBuilder: (context, index) {
                      bool isPurchased = myAvatar.contains(avatar[index]); // Check if the avatar is purchased
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff4B4F4B),
                              primaryTextColor,

                            ],
                          ),
                          // color: secondaryTextColor,
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  mediumText(title: avatarNames[index], fontSize: 14.0),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Image.asset(coin,height: 20,width: 20,),
                                        SizedBox(
                                          width: 0.01,
                                        ),
                                        mediumText(title: '${avatarPrice[index]}', fontSize: 10.0, fontWeight: FontWeight.w300),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(22.0),
                              child: Image(image: AssetImage(avatar[index]),
                                width: MediaQuery.of(context).size.width*0.44,
                                height: MediaQuery.of(context).size.height*0.3,
                                fit: BoxFit.cover,

                              ),
                            ),
                            isPurchased
                                ? Positioned(
                              bottom: 0,
                              left: 7,

                                  child: CustomButton(
                                  color: Color(0xff363A36),
                                  imagePath: null,
                                  title: 'Already Bought ✔',
                                  onTap: (){

                                                              }),
                                )
                                : avatarController.selectedIndex.value == index
                                ? avatarController.isLoading.value == true
                                ? Positioned(
                                bottom: 0, child: CircularProgressIndicator())
                                : Positioned(
                              bottom: 0,
                              left: 7,
                                  child: CustomButton(
                                      color: Color(0xff363A36),
                                                                imagePath: null,
                                  title: 'Buy Item 🛒'
                                  , onTap: (){
                                                                avatarController.changeAvatar(
                                  userId: userTelegramId.toString(),
                                  avatar: avatar[index],
                                  index: index,
                                  price: avatarPrice[index],
                                                                    avatarname: avatarNames[index]
                                                                );
                                                              }),
                                )
                                : Positioned(

                              bottom: 0,
                                  left: 7,
                                  child: CustomButton(
                                  imagePath: null,
                                                                 color: splashColor,
                                  title: 'Buy Item 🛒',
                                  onTap: () {
                                                                avatarController.changeAvatar(
                                  userId: userTelegramId.toString(),
                                  avatar: avatar[index],
                                  index: index,
                                  price: avatarPrice[index],
                                                                  avatarname: avatarNames[index]
                                                                );
                                                              }
                                                              ),
                                ),
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
