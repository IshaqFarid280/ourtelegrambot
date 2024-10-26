import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/widgets/Rounder_buttons.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher

class EraserGameScreen extends StatefulWidget {
  @override
  _EraserGameScreenState createState() => _EraserGameScreenState();
}

class _EraserGameScreenState extends State<EraserGameScreen> {
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
Title: InfoHawk 
Description: A platform to explore exciting features and tools. 
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
    return Column(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userTelegramId.toString())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasData) {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              controller.name.value = data['user_name'];
              controller.userId.value = data['user_id'];
              return Column(
                children: [
                  Text(
                    'Welcome, ${controller.name.value}!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  RoundedButton(
                    title: 'Send Invite',
                    onTap: () {
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
                    imagePath: 'assets/infohawks.png',
                  ),
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
        Center(
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2.0),
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: shuffledImages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTap(index),
                  child: AnimatedOpacity(
                    opacity: isVisible[index] ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 200),
                    child: Image.asset(shuffledImages[
                        index]), // Using Image.asset for local assets
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
