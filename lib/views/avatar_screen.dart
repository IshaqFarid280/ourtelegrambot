import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
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
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: MediaQuery.sizeOf(context).height * 0.4,
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: secondaryTextColor,
                          image: DecorationImage(image: AssetImage(userData['avatar'])),
                        ),
                      ),
                      Container(
                        height: MediaQuery.sizeOf(context).height * 0.4,
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: List.generate(myAvatar.length, (index) {
                              return InkWell(
                                onTap: (){
                                  avatarController.changeAvatarToAlreadyAvaliable(userId: userTelegramId.toString(), avatar: myAvatar[index]);
                                },
                                child: Container(
                                  height: MediaQuery.sizeOf(context).height * 0.1,
                                  width: MediaQuery.sizeOf(context).width * 0.2,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
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
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: avatar.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4 / 6,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      bool isPurchased = myAvatar.contains(avatar[index]); // Check if the avatar is purchased
                      return Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image(image: AssetImage(avatar[index])),
                            CustomSized(),
                            isPurchased
                                ? Text('Already Bought') // Show message if already purchased
                                : avatarController.selectedIndex.value == index
                                ? avatarController.isLoading.value == true
                                ? CircularProgressIndicator()
                                : TextButton(
                              onPressed: () {
                                avatarController.changeAvatar(
                                  userId: userTelegramId.toString(),
                                  avatar: avatar[index],
                                  index: index,
                                  price: avatarPrice[index],
                                );
                              },
                              child: Text('Buy ${avatarPrice[index]}'),
                            )
                                : TextButton(
                              onPressed: () {
                                avatarController.changeAvatar(
                                  userId: userTelegramId.toString(),
                                  avatar: avatar[index],
                                  index: index,
                                  price: avatarPrice[index],
                                );
                              },
                              child: Text('Buy ${avatarPrice[index]}'),
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
