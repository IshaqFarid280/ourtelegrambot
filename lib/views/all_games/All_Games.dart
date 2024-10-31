import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/views/all_games/slot_machine_screen.dart';
import 'package:ourtelegrambot/views/all_games/spin_wheel_screen.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';

import '../../const/colors.dart';
import '../adventure_tab.dart';


class AllGames extends StatelessWidget {
  const AllGames({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GamesButton(title: 'Fortune Wheel',imagePath: spinWheel,onTap: (){
              Get.to(()=> SpinWheelScreen(),);
            },),
            CustomSized(height: 0.02,),
            Divider(),
            CustomSized(height: 0.02,),
            GamesButton(title: 'Ninja Adventure',imagePath: airPlane,onTap: (){
              Get.to(()=> AdventureTab(),);
            },),
            CustomSized(height: 0.02,),
            Divider(),
            CustomSized(height: 0.02,),
            GamesButton(title: 'Slot Machine',imagePath: slotMachine,onTap: (){
              Get.to(()=> SlotMachineScreen(),);
            },),
          ],
        ),
      ),
    );
  }
}


class GamesButton extends StatelessWidget {
  const GamesButton({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  final VoidCallback onTap;
  final String imagePath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bottom layer for shadow and glow effect
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: primaryTextColor.withOpacity(0.1), // Slightly darker for depth
              boxShadow: [
                BoxShadow(
                  color: blueColor.withOpacity(0.5), // Glow color
                  spreadRadius: 5,
                  blurRadius: 15,
                  offset: Offset(0, 0), // Centered glow
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.4), // Strong shadow for depth
                  spreadRadius: 6,
                  blurRadius: 20,
                  offset: Offset(6, 6), // Down and right for shadow direction
                ),
              ],
            ),
          ),
          // Top layer for the button itself
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: primaryTextColor, // Your button color
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 10,
                  offset: Offset(2, 2), // Slightly adjusted shadow
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(-1, -1), // Light highlight for depth
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomSized(height: 0.02,),
                smallText(title: title), // Your existing text style
                CustomSized(height: 0.01,),
                Image.asset(
                  imagePath,
                  width: 120,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}







