import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/GameController.dart';

import 'line_indicator.dart';
import 'on_boarding_page.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final GameController controller = Get.put(GameController());



  @override
  void initState() {
    super.initState();
    controller.initializeTelegramBackButton();
  }

  @override
  void dispose() {
    super.dispose();
    controller.hideoutallButton();
  }

  Future<bool> _handleBackNavigation() async {
    Navigator.pop(context);
    return false;
  }
  int _currentIndex = 0;

  List<Widget> _buildPages() {
    return [
      const OnboardingPage(
        imagePath: airDropInfo,
        title: 'Welcome to Airdrop Game!',
        subtitle: 'Tap on the game to get started.',
        description: 'Experience a new way of playing with our interactive Airdrop game!',
      ),
      const OnboardingPage(
        imagePath: games,
        title: 'Play Games & Win!',
        subtitle: 'Enjoy exciting games like Spin Wheel and Slot Machine.',
        description: 'Choose from multiple fun games and start winning rewards!',
      ),
      const OnboardingPage(
        imagePath: friends,
        title: 'Invite Your Friends',
        subtitle: 'Share the fun and play together.',
        description: 'Invite your friends and compete for exciting rewards!',
      ),
      const OnboardingPage(
        imagePath: comingSoon,
        title: 'Keep Playing!',
        subtitle: 'Airdrop Coming Soon!',
        description: 'Stay tuned for exciting news. Keep playing and winning!',
      ),
    ];
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        body: Stack(
          children: [
            Positioned.fill(
              child: PageView(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                children: _buildPages(),
              ),
            ),
            Positioned(
              top: 130.0,
              left: 0.0,
              right: 0.0,
              child: LineIndicator(
                itemCount: 4,
                currentIndex: _currentIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}