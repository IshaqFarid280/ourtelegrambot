import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/controller/upgradesCotroller.dart';
import 'package:ourtelegrambot/serivices/firebase_services.dart';

class UserAttributesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var upgradesController = Get.put(UpgradesController());
    return Scaffold(
      appBar: AppBar(title: Text('User Attributes')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseServices.getUserData(userId: userTelegramId.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }else if(snapshot.hasData){
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            return ListView(
              children: [
                ListTile(
                  title: Text('Tap Per Earn'),
                  subtitle: Text('Level: ${userData['tap_per_earn']['level']}'),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${userData['tap_per_earn']['value']}'),
                      Text(
                          'Cost: ${userData['tap_per_earn']['costs'][userData['tap_per_earn']['level']]}'),
                    ],
                  ),
                  onTap: () {
                    upgradesController.upgradeAttribute(userTelegramId.toString(), 'tap_per_earn',context);
                  },
                ),
                Divider(),
                ListTile(
                    title: Text('HP'),
                    subtitle: Text('Level: ${userData['hp']['level']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${userData['hp']['value']}'),
                        Text(
                            'Cost: ${userData['hp']['costs'][userData['hp']['level']]}'),
                      ],
                    ),
                    onTap: () {
                      upgradesController.upgradeAttribute(userTelegramId.toString(), 'hp',context);
                    }),
                Divider(),
                ListTile(
                    title: Text('Coins Per Second'),
                    subtitle:
                    Text('Level: ${userData['coin_per_second']['level']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${userData['coin_per_second']['value']}'),
                        Text(
                            'Cost: ${userData['coin_per_second']['costs'][userData['coin_per_second']['level']]}'),
                      ],
                    ),
                    onTap: () {
                      upgradesController.upgradeAttribute(userTelegramId.toString(), 'coin_per_second',context);
                    }),
                Divider(),
                ListTile(
                    title: Text('Energies'),
                    subtitle:
                    Text('Level: ${userData['energies']['level']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${userData['energies']['value']}'),
                        Text(
                            'Cost: ${userData['energies']['costs'][userData['energies']['level']]}'),
                      ],
                    ),
                    onTap: () {
                      upgradesController.upgradeAttribute(userTelegramId.toString(), 'energies',context);
                    }),
              ],
            );
          }else{
            return Text('Something went wrong');
          }
        },
      ),
    );
  }
}
