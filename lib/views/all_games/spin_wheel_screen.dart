import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:confetti/confetti.dart'; // Import confetti package
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/firebase_const.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';
import 'package:ourtelegrambot/widgets/Custom_button.dart';
import 'package:ourtelegrambot/widgets/text_widgets.dart';
import '../../const/colors.dart';
import '../../controller/spin_wheel_controller.dart';
import 'package:assets_audio_player_web/assets_audio_player_web.dart';

class SpinWheelScreen extends StatefulWidget {
  @override
  _SpinWheelScreenState createState() => _SpinWheelScreenState();
}

class _SpinWheelScreenState extends State<SpinWheelScreen> {
  final SpinWheelController controller = Get.put(SpinWheelController());
  late ConfettiController _confettiController;
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer(); // Create an instance of AssetsAudioPlayer

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player
    _confettiController.dispose();
    super.dispose();
  }

  void _spinWheel() async {
    controller.spinWheel(userTelegramId.toString(), context);
    await Future.delayed(Duration(seconds: 3),(){
      _confettiController.play();
      AssetsAudioPlayer.newPlayer().open(
        Audio.network("assets/music/coins.mp3"),
        autoStart: true,
        playSpeed: 20,
        audioFocusStrategy:AudioFocusStrategy.request(),
        showNotification: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomSized(
              height: 0.7,
              width: 0.7,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  FortuneWheel(
                    hapticImpact: HapticImpact.heavy,
                    rotationCount: 5,
                    animateFirst: false,
                    selected: controller.selected.stream,
                    items: [
                      FortuneItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('100', style: TextWidgets.customProfileTextStyle()),
                            CustomSized(width: 0.03),
                            const CircleAvatar(backgroundImage: AssetImage(coin), radius: 20, backgroundColor: Colors.transparent),
                          ],
                        ),
                        style: const FortuneItemStyle(color: secondaryTextColor),
                      ),
                      FortuneItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('200', style: TextWidgets.customProfileTextStyle()),
                            CustomSized(width: 0.03),
                            const CircleAvatar(backgroundImage: AssetImage(coin), radius: 20, backgroundColor: Colors.transparent),
                          ],
                        ),
                        style: const FortuneItemStyle(color: splashColor),
                      ),
                      FortuneItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('400', style: TextWidgets.customProfileTextStyle()),
                            CustomSized(width: 0.03),
                            const CircleAvatar(backgroundImage: AssetImage(coin), radius: 20, backgroundColor: Colors.transparent),
                          ],
                        ),
                        style: const FortuneItemStyle(color: secondaryTextColor),
                      ),
                      FortuneItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('600', style: TextWidgets.customProfileTextStyle()),
                            CustomSized(width: 0.03),
                            const CircleAvatar(backgroundImage: AssetImage(coin), radius: 20, backgroundColor: Colors.transparent),
                          ],
                        ),
                        style: const FortuneItemStyle(color: splashColor),
                      ),
                      FortuneItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('800', style: TextWidgets.customProfileTextStyle()),
                            CustomSized(width: 0.03),
                            const CircleAvatar(backgroundImage: AssetImage(coin), radius: 20, backgroundColor: Colors.transparent),
                          ],
                        ),
                        style: const FortuneItemStyle(color: secondaryTextColor),
                      ),
                      FortuneItem(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('5000', style: TextWidgets.customProfileTextStyle()),
                            CustomSized(width: 0.03),
                            const CircleAvatar(backgroundImage: AssetImage(coin), radius: 20, backgroundColor: Colors.transparent),
                          ],
                        ),
                        style: const FortuneItemStyle(color: splashColor),
                      ),
                    ],
                  ),
                  // Confetti widget positioned in the center
                  ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive, // Blast from center
                    emissionFrequency: 0.03, // How often particles are emitted
                    numberOfParticles: 30, // Number of particles to emit
                    gravity: 0.2, // Particle gravity
                    particleDrag: 0.05, // Apply drag to the particles
                    colors: [
                      coinColors
                    ], // Set colors to null to use the original image colors
                    createParticlePath: (_) {
                      // You could use this to create a custom path if needed
                      return Path()..addOval(Rect.fromCircle(center: Offset(0, 0), radius: 5));
                    },
                    child: Image.asset(
                      coin,
                      width: 30, // Adjust size as needed
                      height: 30,
                    ),
                  ),
                ],
              ),
            ),
            CustomSized(),
            CustomButton(
              title: 'Spin',
              onTap: _spinWheel, // Update to call the new function
            ),
          ],
        ),
      ),
    );
  }
}
