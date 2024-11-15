import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/controller/tasks_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/serivices/firebase_services.dart';
import 'package:ourtelegrambot/views/code_verification_view/code_verification_screen.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
import 'package:ourtelegrambot/widgets/Rounder_buttons.dart';
import 'package:ourtelegrambot/widgets/custom_indicator.dart';
import 'package:ourtelegrambot/widgets/custom_sizedBox.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskListScreen extends StatefulWidget {
  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  static const int gridSize = 4;

  final List<String> images = [
    'assets/infohawks.png',
    'assets/infohawks.png',
    'assets/infohawks.png',
    'assets/infohawks.png',
    'assets/infohawks.png',
    'assets/infohawks.png',
    'assets/infohawks.png',
    'assets/infohawks.png',
  ];
  List<String> shuffledImages = [];
  List<bool> isVisible = [];
  @override
  void initState() {
    super.initState();
    _shuffleImages();
  }

  void _shuffleImages() {
    shuffledImages = List.from(images)..shuffle(Random());
    isVisible = List.generate(shuffledImages.length, (index) => true);
  }

  void _onTap(int index) {
    setState(() {
      isVisible[index] = false;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isVisible[index] = true;
        _shuffleImages();
      });
    });
  }

  void shareInviteLink(String inviteLink , String userid , String appName,) {
    // Create a message including the app name, description, and a link
    final messageText = '''$appName''';

    final uri = Uri.encodeFull(
        // 'https://t.me/share/url?url=$inviteLink&text=$messageText');
        'https://t.me/share/url?url=$inviteLink&text=$messageText');
  launch(uri);
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TelegramController());
    var tasksController = Get.put(TasksController());
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: whiteColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage('assets/ninja.png'))),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseServices.getUserData(
                            userId: userTelegramId.toString()),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CustomIndicator()
                            );
                          } else if (snapshot.hasData) {
                            var data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            controller.name.value = data['user_name'];
                            controller.userId.value = data['user_id'];
                            return Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(pi),
                                    child: Image.asset(
                                      'assets/karatekid1.png',
                                      fit: BoxFit.cover,
                                      opacity: const AlwaysStoppedAnimation(.4),
                                      height: MediaQuery.of(context).size.height *
                                          0.25,
                                      width:
                                          MediaQuery.of(context).size.width * 0.6,
                                    ),
                                  ),
                                ),

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Sized(
                                      height: 0.02,
                                    ),
                                    Row(
                                      children: [
                                        Sized(
                                          width: 0.04,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage('assets/ninja.png'),),
                                              shape: BoxShape.circle,
                                              color: coinColors),
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.1,
                                          height:
                                              MediaQuery.of(context).size.height *
                                                  0.05,
                                        ),
                                        Sized(
                                          width: 0.04,
                                        ),
                                        Column(
                                          children: [
                                            mediumText(
                                                title: '${controller.name.value}',
                                                fontSize: 20.0),
                                            smallText(
                                                title: 'id',
                                                fontSize: 14.0,
                                                color:
                                                    whiteColor.withOpacity(0.7)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Sized(
                                      height: 0.07,
                                    ),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Sized(
                                          width: 0.025,
                                        ),
                                        InkWell(
                                          onTap: () {


             var encodedUsername =
               Uri.encodeComponent(controller.userId.value);
             //https://t.me/InfoHawkbot/BountyHunter?startapp
                                            //http://t.me/InfoHawkbot/BountyHunter?startapp  Info_Hawk
                final inviteLink =
                 'http://t.me/InfoHawkbot/Info_Hawk?startapp=$encodedUsername';
                    controller.copyToClipboard(
                        inviteLink, context);
                        shareInviteLink(inviteLink, controller.userId.value,  'Buckle up for big Adventure');
                        print('the encoded user id: ${encodedUsername}');
                             },
                                          child: Container(

                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.05,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                mediumText(
                                                    title: 'Send Invite'
                                                        .toUpperCase(),
                                                    fontSize: 18.0),
                                                Sized(
                                                  width: 0.019,
                                                ),
                                                Icon(Icons.send)
                                              ],
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color:
                                                    primaryTextColor),
                                          ),
                                        ),
                                        Sized(
                                          width: 0.025,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            var encodedUsername =
                                                Uri.encodeComponent(
                                                    controller.name.value);
                                            final inviteLink =
                                                'https://t.me/InfoHawkbot/BountyHunter?startapp';
                                            controller.copyToClipboard(
                                                inviteLink, context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(
                                              Icons.link_rounded,
                                              color: whiteColor,
                                              size: 28,
                                            ),
                                            decoration: BoxDecoration(
                                                color: primaryTextColor,
                                                shape: BoxShape.circle),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  'Error fetching user data. Please try again.'),
                            );
                          } else {
                            return Center(
                              child: Text(
                                'Please visit admin to resolve the issue.',
                                style: TextStyle(fontSize: 16, color: Colors.red),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),

           const TabBar(
              labelColor:coinColors,
              dividerColor: primaryTextColor,
                indicatorColor: coinColors,

                tabs: [
              Tab(text: "Daily",),
              Tab(text: "Basic",),
              Tab(text: "Social",),
              Tab(text: "Academy",),
              Tab(text: "Groups",),
            ]),
            Expanded(
              child: TabBarView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseServices.showDailyTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CustomIndicator());
                      }
                      else if (snapshot.hasData) {
                        final tasks = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            var task = tasks[index];
                            var taskName = task['task_name'];
                            var buttonTextName = task['button_text'];
                            var price = task['price'].toString();
                            var url = task['url'];
                            var imageurl = task['image_url'];
                            bool isCompleted = (task['completed'] as List<dynamic>)
                                .contains(controller.userId.value);

                            return ListTile(
                                leading: CircleAvatar(

                                    child: Image.network(imageurl, fit: BoxFit.cover, errorBuilder: (context, _, s){
                                      return Icon(Icons.image);
                                    }, ), ),
                                title: mediumText(title: taskName, fontSize: 16.0),
                                subtitle: Row(
                                  children: [
                                    Container(

                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage('assets/coin.png')
                                          )
                                      ),
                                      width: MediaQuery.of(context).size.width*0.065,
                                      height: MediaQuery.of(context).size.height*0.045,
                                    ),
                                    mediumText(title: price, fontSize: 12.0),
                                  ],
                                ),
                                trailing: isCompleted
                                    ? Icon(Icons.check)
                                    : CustomButton(
                                  width: 0.18,
                                  height: 0.06,

                                  title: buttonTextName,


                                  onTap: () async {
                                    final Uri taskUrl = Uri.parse(url);
                                    if (await canLaunchUrl(taskUrl)) {
                                      await launchUrl(taskUrl,
                                          mode: LaunchMode.externalApplication);
                                      tasksController.markTasksCompleted(
                                          collection: dailyTasks,
                                          userId: controller.userId.value,
                                          context: context,
                                          coinprice:task['price'],
                                          docId: task.id);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Could not open $url')),
                                      );
                                    }
                                  },)
                            );
                          },
                        );
                      }
                      else {
                        return Center(child: Text('No daily tasks found'));
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseServices.showAllTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CustomIndicator());
                      }
                      else if (snapshot.hasData) {
                        final tasks = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            var task = tasks[index];
                            var taskName = task['task_name'];
                            var buttonTextName = task['button_text'];
                            var price = task['price'].toString();
                            var url = task['url'];
                            var imageurl = task['image_url'];
                            bool isCompleted = (task['completed'] as List<dynamic>)
                                .contains(controller.userId.value);

                            return ListTile(
                                leading: CircleAvatar(

                                    child: Image.network(imageurl)),
                                title: mediumText(title: taskName, fontSize: 16.0),
                                subtitle: Row(
                                  children: [
                                    Container(

                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage('assets/coin.png')
                                          )
                                      ),
                                      width: MediaQuery.of(context).size.width*0.065,
                                      height: MediaQuery.of(context).size.height*0.045,
                                    ),
                                    mediumText(title: price, fontSize: 12.0),
                                  ],
                                ),
                                trailing: isCompleted
                                    ? Icon(Icons.check)
                                    : CustomButton(
                                  width: 0.18,
                                  height: 0.06,

                                  title: buttonTextName,


                                  onTap: () async {
                                    final Uri taskUrl = Uri.parse(url);
                                    if (await canLaunchUrl(taskUrl)) {
                                      await launchUrl(taskUrl,
                                          mode: LaunchMode.externalApplication);
                                      tasksController.markTasksCompleted(
                                        collection: allTasks,
                                          userId: controller.userId.value,
                                          context: context,
                                          coinprice:task['price'],
                                          docId: task.id);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Could not open $url')),
                                      );
                                    }
                                  },)
                            );
                          },
                        );
                      }
                      else {
                        return Center(child: Text('No tasks found'));
                      }
                    },
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseServices.showSocialTasks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CustomIndicator());
                      } else if (snapshot.hasData) {
                        final tasks = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            var task = tasks[index];
                            var taskName = task['task_name'];
                            var buttonTextName = task['button_text'];
                            var price = task['price'].toString();
                            var url = task['url'];
                            var imageurl = task['image_url'];
                            bool isCompleted = (task['completed'] as List<dynamic>)
                                .contains(controller.userId.value);

                            return ListTile(
                              leading: CircleAvatar(

                                  child: Image.network(imageurl)),
                              title: mediumText(title: taskName, fontSize: 16.0),
                              subtitle: Row(
                                children: [
                                  Container(

                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/coin.png')
                                      )
                                    ),
                                    width: MediaQuery.of(context).size.width*0.065,
                                    height: MediaQuery.of(context).size.height*0.045,
                                  ),
                                  mediumText(title: price, fontSize: 12.0),
                                ],
                              ),
                              trailing: isCompleted
                                  ? Icon(Icons.check)
                                  : CustomButton(
                                width: 0.18,
                                height: 0.06,

                                title: buttonTextName,


                                onTap: () async {
                                final Uri taskUrl = Uri.parse(url);
                                if (await canLaunchUrl(taskUrl)) {
                                  await launchUrl(taskUrl,
                                      mode: LaunchMode.externalApplication);
                                  tasksController.markTasksCompleted(
                                      collection: socialTasks,
                                      userId: controller.userId.value,
                                      context: context,
                                      coinprice:task['price'],
                                      docId: task.id);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Could not open $url')),
                                  );
                                }
                              },)
                            );
                          },
                        );
                      } else {
                        return Center(child: Text('No tasks found'));
                      }
                    },
                  ),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseServices.getAcademydetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomIndicator());
          }
          else if (snapshot.hasData) {
            final tasks = snapshot.data!.docs;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                var taskName = task['task_name'];
                var buttonTextName = task['button_text'];
                var price = task['price'].toString();
                var url = task['url'];
                var code = task['code'];
                var urllauncherNavigator = task['button_navigator'];
                var imageurl = task['image_url'];

                bool isCompleted = (task['completed'] as List<dynamic>)
                    .contains(controller.userId.value);

                // Check if the current user has already navigated (status is 'navigated')
                bool hasNavigated = urllauncherNavigator.any((entry) =>
                entry['user_id'] == controller.userId.value && entry['status'] == 'true');

                return ListTile(
                  leading: CircleAvatar(
                      child: Image.network(imageurl)),
                  title: mediumText(title: taskName, fontSize: 16.0),
                  subtitle: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/coin.png')
                            )
                        ),
                        width: MediaQuery.of(context).size.width * 0.065,
                        height: MediaQuery.of(context).size.height * 0.045,
                      ),
                      mediumText(title: price, fontSize: 12.0),
                    ],
                  ),
                  trailing: isCompleted
                      ? Icon(Icons.check)
                      : (hasNavigated)
                      ? CustomButton(
                      title: 'Verify',
                      width: 0.18,
                      height: 0.06,
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             VerificationScreen(
                        //                 coinprice: task['price'],
                        //                 title: taskName,
                        //                 code: code,
                        //                 docid: task.id,
                        //                 url: url)));

                        tasksController.verifyUserMembership(
                            botToken: '7397643566:AAHJ52kYZTgM3BWUzHNKRp7V0c_O51XZd58',
                            channelId: '@ishaqhehe',
                            userId: controller.userId.value,
                            coin: task['price'],
                            collection: academyTasks,
                            docId: task.id,
                            context: context
                        );
                      })
                      : CustomButton(
                    width: 0.18,
                    height: 0.06,
                    title: buttonTextName,
                    onTap: () async {
                      final Uri taskUrl = Uri.parse(url);
                      if (await canLaunchUrl(taskUrl)) {
                        await launchUrl(taskUrl, mode: LaunchMode.externalApplication);
                        tasksController.buttonverification(
                            userId: controller.userId.value,
                            collection: academyTasks,
                            context: context,
                            docId: task.id
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not open $url')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
          else {
            return Center(child: Text('No tasks found'));
          }
        },
      ),
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseServices.getAcademydetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomIndicator());
          }
          else if (snapshot.hasData) {
            final tasks = snapshot.data!.docs;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                var task = tasks[index];
                var taskName = task['task_name'];
                var buttonTextName = task['button_text'];
                var price = task['price'].toString();
                var url = task['url'];
                var code = task['code'];
                var urllauncherNavigator = task['button_navigator'];
                var imageurl = task['image_url'];

                bool isCompleted = (task['completed'] as List<dynamic>)
                    .contains(controller.userId.value);

                // Check if the current user has already navigated (status is 'navigated')
                bool hasNavigated = urllauncherNavigator.any((entry) =>
                entry['user_id'] == controller.userId.value && entry['status'] == 'true');

                return ListTile(
                  leading: CircleAvatar(
                      child: Image.network(imageurl)),
                  title: mediumText(title: taskName, fontSize: 16.0),
                  subtitle: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/coin.png')
                            )
                        ),
                        width: MediaQuery.of(context).size.width * 0.065,
                        height: MediaQuery.of(context).size.height * 0.045,
                      ),
                      mediumText(title: price, fontSize: 12.0),
                    ],
                  ),
                  trailing: isCompleted
                      ? Icon(Icons.check)
                      : (hasNavigated)
                      ? CustomButton(
                      title: 'Verify',
                      width: 0.18,
                      height: 0.06,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VerificationScreen(
                                        coinprice: task['price'],
                                        title: taskName,
                                        code: code,
                                        docid: task.id,
                                        url: url)));
                      })
                      : CustomButton(
                    width: 0.18,
                    height: 0.06,
                    title: buttonTextName,
                    onTap: () async {
                      final Uri taskUrl = Uri.parse(url);
                      if (await canLaunchUrl(taskUrl)) {
                        await launchUrl(taskUrl, mode: LaunchMode.externalApplication);
                        tasksController.buttonverification(
                            userId: controller.userId.value,
                            collection: academyTasks,
                            context: context,
                            docId: task.id
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not open $url')),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }
          else {
            return Center(child: Text('No tasks found'));
          }
        },
      )

      ],
              ),
            ),


          ],
        ),
      ),
    );
  }
}