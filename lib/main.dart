import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ourtelegrambot/controller/coin_controller.dart';
import 'package:ourtelegrambot/controller/telegram_controller.dart';
import 'package:ourtelegrambot/views/adventure_tab.dart';
import 'package:ourtelegrambot/views/home_tab.dart';
import 'package:get/get.dart';
import 'package:ourtelegrambot/views/upgrades_tab.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
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
      const AdventureTab(),
      UserAttributesScreen(),
      const Text('Earn Tab - Coming Soon'),
      const Text('Friend Tab - Coming Soon'),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.garage),
            label: 'Garage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flight_takeoff),
            label: 'Adventure',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upgrade),
            label: 'Improve',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Earn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Friends',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
