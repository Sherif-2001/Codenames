import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'screens/enter_room_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/how_to_play_page.dart';
import 'brain.dart';
import 'screens/create_room_page.dart';
import 'screens/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Brain>(
      create: (context) => Brain(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (context) => const SplashScreen(),
          HomePage.id: (context) => const HomePage(),
          HowToPlay.id: (context) => const HowToPlay(),
          CreateRoom.id: (context) => const CreateRoom(),
          EnterRoom.id: (context) => const EnterRoom()
        },
        theme: ThemeData(fontFamily: "oleoScript"),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String id = "splashScreenId";
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.red.shade800, Colors.blue.shade800],
              stops: const [0.5, 0.5],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
      child: AnimatedSplashScreen(
          backgroundColor: Colors.transparent,
          splash: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("CodeNames",
                  style: TextStyle(fontSize: 70, color: Colors.white)),
              SizedBox(height: 50),
              LinearProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.blue,
              ),
              SizedBox(height: 50),
              Text("Made by Sherif",
                  style: TextStyle(fontSize: 30, color: Colors.white)),
            ],
          ),
          animationDuration: const Duration(seconds: 2),
          splashIconSize: 1000,
          duration: 5000,
          nextScreen: const HomePage()),
    );
  }
}
