import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/controller/tasks_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/serivices/firebase_services.dart';
import 'package:ourtelegrambot/widgets/Rounder_buttons.dart';
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
  void shareInviteLink(String inviteLink) {
    final messageText = '''
Check out our web app! 
InfoHawk 
A platform to explore exciting features and tools. 
Join us and start your journey! 
$inviteLink
''';

    final uri = Uri.encodeFull(
        'https://t.me/share/url?url=$inviteLink&text=$messageText');
    launch(uri); // Open the URL in Telegram
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(TelegramController());
    var tasksController = Get.put(TasksController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.25,
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
                          image: AssetImage('assets/ninja.png')
                        )
                      ),
                    ),

                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseServices.getUserData(userId: userTelegramId.toString()),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.06,
                              width: MediaQuery.of(context).size.width * 0.06,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                value: 10.0,
                              ),
                            ),
                          );
                        } else if (snapshot.hasData) {
                          var data = snapshot.data!.data() as Map<String, dynamic>;
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
                                    opacity:  const AlwaysStoppedAnimation(.4),
                                    height: MediaQuery.of(context).size.height * 0.25,
                                    width: MediaQuery.of(context).size.width * 0.6,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 15,

                             child:  Row(
                                children: [
                                  Sized(width: 0.04,),

                                  Container(

                                    decoration: BoxDecoration(

                                        image: DecorationImage(image: AssetImage(
                                            'assets/ninja.png'
                                        )),
                                        shape: BoxShape.circle,
                                        color: whiteColor.withOpacity(0.8)
                                    ),
                                    width: MediaQuery.of(context).size.width*0.1,
                                    height: MediaQuery.of(context).size.height*0.05,
                                  ),
                                  Column(
                                    children: [
                                      mediumText(title:
                                      '${controller.name.value}',
                                          fontSize: 20.0
                                      ),
                                      smallText(title: 'the id', fontSize: 14.0, color: whiteColor.withOpacity(0.7)),
                                    ],
                                  ),
                                ],
                              ),
                              ),
                              Positioned(
                                  top: 50,
                                  left: 5,
                                child:
                                Row(
                                  mainAxisAlignment:  MainAxisAlignment.center,

                                  children: [

                                    InkWell(
                                      onTap: (){
                                        print(controller.name.value);
                                        print(controller.userId.value);
                                        var encodedUsername =
                                        Uri.encodeComponent(controller.name.value);
                                        final inviteLink =
                                            'https://telegrambot-dbb20.web.app/?referrerId=${controller.userId.value}&username=$encodedUsername';
                                        controller.copyToClipboard(inviteLink, context);

                                        // Option 1: Open Telegram share link
                                        shareInviteLink(inviteLink);

                                        // Option 2: Send the invite message to Telegram using the bot
                                        // sendTelegramInvite(controller.userId.value, inviteLink, 'YOUR_BOT_TOKEN_HERE');
                                      },
                                      child: Container(
                                        width: MediaQuery.of(context).size.width*0.7,
                                        height: MediaQuery.of(context).size.height*0.05,

                                        child: Row(
                                          mainAxisAlignment:  MainAxisAlignment.center,
                                          children: [
                                            mediumText(title: 'Send Invite'.toUpperCase(), fontSize: 22.0),
                                            Sized(width: 0.019,),
                                            Icon(Icons.send)

                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8),
                                            color: whiteColor.withOpacity(0.2)
                                        ),
                                      ),
                                    ),
                                    Sized(
                                      width: 0.025,
                                    ),
                                    InkWell(
                                      onTap: (){
                                        var encodedUsername =
                                        Uri.encodeComponent(controller.name.value);
                                        final inviteLink =
                                            'https://telegrambot-dbb20.web.app/?referrerId=${controller.userId.value}&username=$encodedUsername';
                                        controller.copyToClipboard(inviteLink, context);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        child: Icon(Icons.link_rounded, color: whiteColor , size: 36,),

                                        decoration: BoxDecoration(
                                            color: whiteColor.withOpacity(0.2),
                                            shape: BoxShape.circle
                                        ),
                                      ),
                                    ),

                                  ],
                                )
                              )



                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error fetching user data. Please try again.'),
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
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseServices.showDailyTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final tasks = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      var taskName = task['task_name'];
                      var url = task['url'];
                      bool isCompleted = (task['completed'] as List<dynamic>).contains(userTelegramId.toString());
                      return ListTile(
                        title: Text(taskName,),
                        trailing: isCompleted == true
                            ? Icon(Icons.check)
                            : IconButton(
                          icon: Icon(Icons.open_in_browser),
                          onPressed: () async {
                            final Uri taskUrl = Uri.parse(url);
                            // Check if URL can be launched
                            if (await canLaunchUrl(taskUrl)) {
                              await launchUrl(
                                taskUrl,
                                mode: LaunchMode.externalApplication,
                              ).then((value) {
                                tasksController.markTasksCompleted(
                                    userId: userTelegramId.toString(),
                                    context: context,
                                    docId: task.id
                                );
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('opned $url')),
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
                } else {
                  return Center(child: Text('No tasks found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
