import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/views/all_games/slot_machine_screen.dart';
import 'package:ourtelegrambot/views/all_games/spin_wheel_screen.dart';

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
            TextButton(onPressed: (){
              Get.to(()=> SpinWheelScreen(),);
            }, child: Text('Wheel'),),
            TextButton(onPressed: (){
              Get.to(()=>  const AdventureTab() );
            }, child: Text('Air Plane'),),
            TextButton(onPressed: (){
              Get.to(()=> SlotMachineScreen(),);
            }, child: Text('Slot Machine'),),
          ],
        ),
      ),
    );
  }
}
