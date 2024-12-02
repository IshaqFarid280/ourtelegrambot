import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/serivices/firebase_services.dart';
import 'package:ourtelegrambot/widgets/custom_indicator.dart';
import 'package:ourtelegrambot/widgets/custom_sizedBox.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';

class LeaderboardScreen extends StatelessWidget {
  final String userid;

  const LeaderboardScreen({super.key, required this.userid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: mediumText(title: 'Leaderboard', fontSize: 14.0),
      ),
      body: StreamBuilder<QuerySnapshot>(
       stream : FirebaseServices.getleaderboarddetails(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No users found'));
          } else {
            // Get all user documents
            var userDocs = snapshot.data!.docs;
            return ListView.builder(
              itemCount: userDocs.length,
              itemBuilder: (context, index) {
               var data = userDocs[index];
               print('Names : coins : ${data['coins']} ${data['user_name']}');
                String formatCoins(int coins) {
                  if (coins >= 1000000000) {
                    return '${(coins / 1000000000).toStringAsFixed(1)} B'; // Billions
                  } else if (coins >= 1000000) {
                    return '${(coins / 1000000).toStringAsFixed(1)} M'; // Millions
                  } else if (coins >= 1000) {
                    return '${(coins / 1000).toStringAsFixed(1)} k'; // Thousands
                  } else {
                    return coins.toString(); // Less than a thousand
                  }
                }
                return index <= 2 ? Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: ListTile(
                    style: ListTileStyle.drawer,
                    tileColor: primaryTextColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                    ),
                    title: Row(
                      children: [
                        index == 0  ? Image.asset(first,width:40,) : index == 1 ?  Image.asset(second,width:40) :  Image.asset(third,width:40),
                        Sized(width: 0.01),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: 40, // Adjust width for desired zoom level
                            height: 40, // Adjust height for desired zoom level
                            decoration: BoxDecoration(
                                color: secondaryTextColor,
                                image: DecorationImage(
                                    image: NetworkImage(
                                      data['avatar'] ?? '',
                                    )
                                )
                            ),

                          ),
                        ),
                        Sized(width: 0.05),
                        mediumText(title: data['user_name'] ?? 'User Name',fontSize: 15,fontWeight:FontWeight.w400 ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(coin, width: 30, height: 40,),
                        mediumText(title: '${formatCoins(data['coins'] ?? data['coins'])}', color: yellowColor, fontSize: 12.0 ),
                      ],
                    ),
                  ),
                ): Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: ListTile(
                    tileColor: primaryTextColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),
                    title: Row(
                      children: [
                        smallText(title: '${index + 1}. '),
                        Sized(width: 0.01),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: 40, // Adjust width for desired zoom level
                            height: 40, // Adjust height for desired zoom level
                            decoration: BoxDecoration(
                              color: secondaryTextColor,
                              image: DecorationImage(
                                image: NetworkImage(
                                  data['avatar'] ?? '',
                                )
                              )
                            ),

                          ),
                        ),
                        Sized(width: 0.05),
                        mediumText(title: data['user_name'] ?? 'User Name',fontSize: 15,fontWeight:FontWeight.w400 ),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(coin, width: 30, height: 40,),
                        mediumText(title: formatCoins(data['coins'] ?? data['coins']), color: yellowColor, fontSize: 12.0 ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
