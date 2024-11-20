import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/colors.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/views/adventure_tab.dart';
import 'package:ourtelegrambot/views/avatar_screen.dart';
import 'package:ourtelegrambot/views/earn_taks_screen.dart';
import 'package:ourtelegrambot/views/home_tab.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/views/leaderboard_screen.dart';
import 'package:ourtelegrambot/views/upgrades_tab.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';

import 'const/firebase_const.dart';
import 'controller/set_status_controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCCf9VLLqdKOiv_clqw2WHpCvTwCs8ALts",
        authDomain: "newtelegrambot-6b0e4.firebaseapp.com",
        projectId: "newtelegrambot-6b0e4",
        storageBucket: "newtelegrambot-6b0e4.firebasestorage.app",
        messagingSenderId: "363816400266",
        appId: "1:363816400266:web:a3538a4851dc7c54a28473"
    ),
  );
  runApp(ExpeditionToTheMoonApp());
}

class ExpeditionToTheMoonApp extends StatelessWidget {
  const ExpeditionToTheMoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  TelegramController telegramController = Get.put(TelegramController());
  String? referralCode;

  var statusController = Get.put(SetStatusController());


  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _widgetOptions = <Widget>[
      HomeTab(),
      LeaderboardScreen(userid: userTelegramId.toString(),),
      UserAttributesScreen(),
      TaskListScreen(),
      AvatarScreen()
    ];
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed ) {
      statusController.setStatus(isOnline: true);
      statusController.isOnline.value = true;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('is Online  ${statusController.isOnline.value}'),
      //   ),
      // );
    } else {
      statusController.setStatus(isOnline: false);
      statusController.isOnline.value = false;
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('is Online  ${statusController.isOnline.value}'),
      //   ),
      // );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    print("Observer removed");
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Get.put(CoinController());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Card(
        elevation: 10,
        color: primaryTextColor.withOpacity(0.5),
        margin: EdgeInsets.only(left: 15, right: 15, bottom: 20),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              color: primaryTextColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(18)),
          height: MediaQuery.sizeOf(context).height * 0.07,
          // width: MediaQuery.sizeOf(context).width * 0.95,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(fillIcons.length, (index) {
              return GestureDetector(
                onTap: () {
                  _selectedIndex = index;
                  setState(() {});
                },
                child: Column(
                  children: [
                    const CustomSized(
                      height: 0.0102,
                    ),
                      index == 2 ?   AvatarGlow(
                      startDelay: const Duration(milliseconds: 1000),
                      glowColor: whiteColor,
                      glowShape: BoxShape.circle,
                      curve: Curves.fastOutSlowIn,
                      child: Image.asset(
                        fillIcons[index],
                        color: index == _selectedIndex
                            ? coinColors
                            : greyColor,
                        height: index == _selectedIndex ? 22 : 18,
                        width: index == _selectedIndex ? 22 : 22,
                      ),
                    ) : Image.asset(
                        fillIcons[index],
                        color: index == _selectedIndex
                            ? coinColors
                            : greyColor,
                        height: index == _selectedIndex ? 22 : 18,
                        width: index == _selectedIndex ? 22 : 22,
                      ),
                   const  CustomSized(
                      height: 0.001,
                    ),
                    Text(title[index],
                        style: TextStyle(
                            fontSize: index == _selectedIndex ? 11 : 10,
                            color: index == _selectedIndex
                                ? coinColors
                                : greyColor,))
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
