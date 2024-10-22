import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import '../../controller/spin_wheel_controller.dart';

class SpinWheelScreen extends StatelessWidget {
  final SpinWheelController controller = Get.put(SpinWheelController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Fortune Wheel'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSized(
              height: 0.4,
              width: 0.4,
              child: FortuneWheel(
                hapticImpact: HapticImpact.heavy,
                rotationCount: 5,
                curve: Curves.easeInCirc,
                animateFirst: false,
                selected: controller.selected.stream,
                items: [
                  FortuneItem(
                    child: Text('100', style: TextStyle(color: Colors.white)),
                    style: FortuneItemStyle(color: Colors.blue),
                  ),
                  FortuneItem(
                    child: Text('200', style: TextStyle(color: Colors.white)),
                    style: FortuneItemStyle(color: Colors.green),
                  ),
                  FortuneItem(
                    child: Text('400', style: TextStyle(color: Colors.white)),
                    style: FortuneItemStyle(color: Colors.yellow),
                  ),
                  FortuneItem(
                    child: Text('600', style: TextStyle(color: Colors.white)),
                    style: FortuneItemStyle(color: Colors.orange),
                  ),
                  FortuneItem(
                    child: Text('800', style: TextStyle(color: Colors.white)),
                    style: FortuneItemStyle(color: Colors.red),
                  ),
                  FortuneItem(
                    child: Text('5000', style: TextStyle(color: Colors.white)),
                    style: FortuneItemStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.spinWheel(userTelegramId.toString(), context),
              child: Text('Spin the Wheel'),
            ),
          ],
        ),
      ),
    );
  }
}
