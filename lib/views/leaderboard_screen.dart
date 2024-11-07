import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/serivices/firebase_services.dart';
import 'package:ourtelegrambot/widgets/custom_sizedBox.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';

class LeaderboardScreen extends StatelessWidget {
  final String userid;

  const LeaderboardScreen({super.key, required this.userid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: FutureBuilder(
        future: FirebaseServices.getleaderboarddetails(userId: userid),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                // Get the user data for the current document
                var userData = userDocs[index].data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                  child: ListTile(
                    tileColor: whiteColor.withOpacity(0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                    ),



                    title: Row(
                      children: [
                        // Display the leaderboard rank (index + 1)

                        smallText(title: '${index + 1}. '),
                        Sized(width: 0.01),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            width: 40, // Adjust width for desired zoom level
                            height: 40, // Adjust height for desired zoom level
                            decoration: BoxDecoration(
                              color: whiteColor.withOpacity(0.3),
                              image: DecorationImage(
                                image: NetworkImage(
                                  userData['avatar'] ?? '',
                                )
                              )
                            ),

                          ),
                        ),
                        Sized(width: 0.01),
                        mediumText(title: userData['user_name'] ?? 'User Name'),
                      ],
                    ),

                    trailing: Sized(
                      width: 0.2,
                      height: 0.06,
                      child: Row(
                        children: [
                          Image.asset(coin, width: 30, height: 40,),
                          mediumText(title: '${userData['coins'] ?? 0}', color: yellowColor, fontSize: 12.0 ),
                        ],
                      ),
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
