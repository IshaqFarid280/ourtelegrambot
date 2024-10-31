import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/views/all_games/slot_machine_screen.dart';
import 'package:ourtelegrambot/views/all_games/spin_wheel_screen.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';

import '../../const/colors.dart';
import '../adventure_tab.dart';


class AllGames extends StatelessWidget {
  const AllGames({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GamesButton(title: 'Fortune Wheel',imagePath: spinWheel,onTap: (){
              Get.to(()=> SpinWheelScreen(),);
            },),
            GamesButton(title: 'Ninja Adventure',imagePath: airPlane,onTap: (){
              Get.to(()=> AdventureTab(),);
            },),
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
    required this.onTap
  });
  final VoidCallback onTap;
  final String imagePath ;
  final String title ;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.2,
          width: MediaQuery.sizeOf(context).width * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:primaryTextColor,
          ),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomSized(height: 0.02,),
              Text(title),
              CustomSized(height: 0.02,),
              Image.asset(imagePath,height: 80,width: 80,),
            ],
          ),
        ),
      ),
    );
  }
}
