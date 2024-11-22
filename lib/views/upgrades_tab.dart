import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/upgradesCotroller.dart';
import 'package:ourtelegrambot/serivices/bottom_sheets_services.dart';
import 'package:ourtelegrambot/serivices/firebase_services.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/custom_indicator.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';
import '../const/colors.dart';
import '../controller/coin_controller.dart';
import 'how_it_works/on_boarding_screen.dart';

class UserAttributesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var upgradesController = Get.put(UpgradesController());
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseServices.getUserData(userId: userTelegramId.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomIndicator());
          }else if(snapshot.hasData){
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            return  Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    smallText(title: 'Your Coin Balance',fontWeight: FontWeight.w400),
                    CustomSized(height: 0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const  CircleAvatar(backgroundImage: AssetImage(coin),backgroundColor: Colors.transparent,radius: 30,),
                        CustomSized(width: 0.01),
                        Obx(()=> largeText(title:Get.find<CoinController>().coins.toString(),fontWeight: FontWeight.w400,color: coinColors,fontSize: 35)),
                      ],
                    ),
                    CustomSized(height: 0.02,),
                    GestureDetector(
                      onTap: (){
                        Get.to(()=> OnboardingScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 7,),
                        decoration: BoxDecoration(
                          color: secondaryTextColor,
                          borderRadius: BorderRadius.circular(20,),
                        ),
                        child: smallText(title: 'How it works',fontWeight: FontWeight.w400,color: coinColors),
                      ),
                    ),
                    CustomSized(height: 0.05,),
                    Align(
                      alignment: Alignment.centerLeft,
                        child: largeText(title: 'Upgrades')),
                    CustomSized(height: 0.02,),
                    Container(
                      padding:const  EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: splashColor
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: primaryTextColor,
                              backgroundImage: AssetImage(coinPerTap),
                            ),
                            title: mediumText(title: 'Silent Strike Coins',fontSize: 16),
                            subtitle: Row(
                              children: [
                                const  CircleAvatar(backgroundImage: AssetImage(coin),backgroundColor: Colors.transparent,radius: 15,),
                                CustomSized(width: 0.01),
                                smallText(title:'${userData['tap_per_earn']['costs'][userData['tap_per_earn']['level']]}',fontWeight: FontWeight.w400,fontSize: 13,color: coinColors),
                                CustomSized(width: 0.015),
                                const Icon(Icons.circle,size:5,),
                                CustomSized(width: 0.015),
                                smallText(title:'Lvl  ${userData['tap_per_earn']['level'] + 1}',fontWeight: FontWeight.w200),
                                CustomSized(width: 0.015),
                                const Icon(Icons.circle,size:5,),
                                CustomSized(width: 0.015),
                                smallText(title:'Coins  ${userData['tap_per_earn']['value']}',fontWeight: FontWeight.w200),
                              ],
                            ),
                            onTap: () {
                              OpenBottomSheet.openBottomSheet(title: 'Silent Strike Coins', description: 'Earn coins instantly with each tap, using the stealth and precision of a ninja!', onTap: (){
                                upgradesController.upgradeAttribute(userTelegramId.toString(), 'tap_per_earn',context,userData['tap_per_earn']['costs'][userData['tap_per_earn']['level']]);
                              }, imagePath: coinPerTap, context: context,price: userData['tap_per_earn']['costs'][userData['tap_per_earn']['level']].toString());
                            },
                          ),
                          const Divider(),
                          ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: primaryTextColor,
                                backgroundImage: AssetImage(hpNinja),
                              ),
                              title: mediumText(title: 'Hp',fontSize: 16),
                              subtitle: Row(
                                children: [
                                  const  CircleAvatar(backgroundImage: AssetImage(coin),backgroundColor: Colors.transparent,radius: 15,),
                                  CustomSized(width: 0.01),
                                  smallText(title:'${userData['hp']['costs'][userData['hp']['level']]}',fontWeight: FontWeight.w400,fontSize: 13,color: coinColors),
                                  CustomSized(width: 0.015),
                                  const Icon(Icons.circle,size:5,),
                                  CustomSized(width: 0.015),
                                  smallText(title:'Lvl  ${userData['hp']['level']+ 1}',fontWeight: FontWeight.w200),
                                  CustomSized(width: 0.015),
                                  const Icon(Icons.circle,size:5,),
                                  CustomSized(width: 0.015),
                                  smallText(title:'HP ${userData['hp']['value']}',fontWeight: FontWeight.w200),
                                ],
                              ),
                              onTap: () {
                               OpenBottomSheet.openBottomSheet(title: 'Hp', description: 'Your ninja\'s health power – keep it high to stay strong in every battle!', onTap: (){
                                 upgradesController.upgradeAttribute(userTelegramId.toString(), 'hp',context,userData['hp']['costs'][userData['hp']['level']]);
                               }, imagePath: hpNinja, context: context,price: userData['hp']['costs'][userData['hp']['level']].toString());
                              }),
                          const Divider(),
                          ListTile(
                              leading: const CircleAvatar(
                                backgroundColor: primaryTextColor,
                                backgroundImage: AssetImage(coinPerSecond),
                              ),
                              title: mediumText(title: 'Stealth Coin Stream'),
                              subtitle:Row(
                                children: [
                                  const  CircleAvatar(backgroundImage: AssetImage(coin),backgroundColor: Colors.transparent,radius: 15,),
                                  CustomSized(width: 0.01),
                                  smallText(title:'${userData['coin_per_second']['costs'][userData['coin_per_second']['level']]}',fontWeight: FontWeight.w400,fontSize: 13,color: coinColors),
                                  CustomSized(width: 0.015),
                                  const Icon(Icons.circle,size:5,),
                                  CustomSized(width: 0.015),
                                  smallText(title:'Lvl  ${userData['coin_per_second']['level']+ 1}',fontWeight: FontWeight.w200),
                                  CustomSized(width: 0.015),
                                  const Icon(Icons.circle,size:5,),
                                  CustomSized(width: 0.015),
                                  smallText(title:'Coins ${userData['coin_per_second']['value']}',fontWeight: FontWeight.w200),
                                ],
                              ),
                              onTap: () {
                                OpenBottomSheet.openBottomSheet(title: 'Stealth Coin Stream', description: 'Earn coins silently over time, just like a ninja moving in the shadows!', onTap: (){
                                  upgradesController.upgradeAttribute(userTelegramId.toString(), 'coin_per_second',context,userData['coin_per_second']['costs'][userData['coin_per_second']['level']]);
                                }, imagePath: coinPerSecond, context: context,price: userData['coin_per_second']['costs'][userData['coin_per_second']['level']].toString());
                              }),
                          const Divider(),
                          ListTile(
                              leading:  const CircleAvatar(
                                backgroundColor: primaryTextColor,
                                backgroundImage:  AssetImage(ninjaEnergies),
                              ),
                              title: mediumText(title: 'Shadow Energy'),
                              subtitle:Row(
                                children: [
                                  const  CircleAvatar(backgroundImage: AssetImage(coin),backgroundColor: Colors.transparent,radius: 15,),
                                  CustomSized(width: 0.01),
                                  smallText(title:'${userData['energies']['costs'][userData['energies']['level']]}',fontWeight: FontWeight.w400,fontSize: 13,color: coinColors),
                                  CustomSized(width: 0.015),
                                  const Icon(Icons.circle,size:5,),
                                  CustomSized(width: 0.015),
                                  smallText(title:'Lvl ${userData['energies']['level']+ 1}',fontWeight: FontWeight.w200),
                                  CustomSized(width: 0.015),
                                  smallText(title:'/  energies + ${userData['energies']['value']}',fontWeight: FontWeight.w200),
                                ],
                              ),
                              onTap: () {
                                OpenBottomSheet.openBottomSheet(title: 'Shadow Energy', description: 'Harness the quiet strength of a ninja with each point of energy, fueling your journey through stealth and precision!', onTap: (){
                                  upgradesController.upgradeAttribute(userTelegramId.toString(), 'energies',context, userData['energies']['costs'][userData['energies']['level']]);
                                }, imagePath: ninjaEnergies, context: context,price: userData['energies']['costs'][userData['energies']['level']].toString());
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
            );
          }else{
            return Text('Something went wrong');
          }
        },
      ),
    );
  }
}
