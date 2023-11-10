import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:code_names/pages/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static String id = "splash_screen";
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
          stops: [0.5, 0.5],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: AnimatedSplashScreen(
        backgroundColor: Colors.transparent,
        splash: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "CodeNames",
                style: TextStyle(fontSize: 70, color: Colors.white),
              ),
              SizedBox(height: 50),
              LinearProgressIndicator(
                backgroundColor: Colors.white,
                color: Colors.blue,
              ),
              SizedBox(height: 50),
              Text(
                "Made by Sherif",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ],
          ),
        ),
        animationDuration: Duration(seconds: 2),
        splashIconSize: 1000,
        duration: 5000,
        nextScreen: HomePage(),
      ),
    );
  }
}
