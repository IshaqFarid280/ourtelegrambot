import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/const/images_path.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/views/adventure_tab.dart';
import 'package:ourtelegrambot/views/all_games/All_Games.dart';
import 'package:ourtelegrambot/views/avatar_screen.dart';
import 'package:ourtelegrambot/views/earn_taks_screen.dart';
import 'package:ourtelegrambot/views/home_tab.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/views/upgrades_tab.dart';
import 'package:ourtelegrambot/widgets/CustomSized.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const  FirebaseOptions(
        apiKey: "AIzaSyBU4j3TedSqjR2lIlRIIam-kx5PMERfiHg",
        authDomain: "telegrambot-dbb20.firebaseapp.com",
        projectId: "telegrambot-dbb20",
        storageBucket: "telegrambot-dbb20.appspot.com",
        messagingSenderId: "530545209911",
        appId: "1:530545209911:web:226956ff9690294d4c45b2"
    ),
  );
  runApp(ExpeditionToTheMoonApp());
}

class ExpeditionToTheMoonApp extends StatelessWidget {
  const ExpeditionToTheMoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Expedition to the Moon',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home:  HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  TelegramController telegramController = Get.put(TelegramController());

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomeTab(),
      const AllGames(),
      UserAttributesScreen(),
      TaskListScreen(),
      AvatarScreen()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(CoinController());
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 20,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.only(left: 15,right: 15,bottom:5),
        decoration: BoxDecoration(
        ),
        height: MediaQuery.sizeOf(context).height * 0.09,
        width: MediaQuery.sizeOf(context).width * 1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(fillIcons.length, (index){
            return GestureDetector(
              onTap: (){
                _selectedIndex = index;
                setState(() {});
              },
              child: Column(
                children: [
                  Image.asset(index == _selectedIndex ? fillIcons[index] : outlineIcons[index],color:  index == _selectedIndex ? Colors.amberAccent : Colors.white ,height: index == _selectedIndex  ? 25 : 22,width: index == _selectedIndex ? 25 : 22, ),
                  CustomSized(height: 0.002,),
                  Text(title[index],style: TextStyle(fontSize: index == _selectedIndex ? 12 : 10,color: index == _selectedIndex ? Colors.white : Colors.white38  ))
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
