import 'package:code_names/pages/create_join_room_page.dart';
import 'how_to_play_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/home_button.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  static String id = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xffDA1212), Color(0xff11468F)],
              begin: Alignment.centerLeft,
              stops: [0.5, 0.5],
              end: Alignment.centerRight),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Codenames",
                style: TextStyle(
                  fontSize: 80,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, blurRadius: 20)],
                ),
              ),
              Row(
                children: [
                  HomeButton(
                    onPress: () {
                      Navigator.pushNamed(context, CreateJoinRoom.id);
                    },
                    buttonText: "Start Game",
                  ),
                  SizedBox(width: 20),
                  HomeButton(
                    onPress: () => Navigator.pushNamed(context, HowToPlay.id),
                    buttonText: "How to Play",
                  ),
                  SizedBox(width: 20),
                  HomeButton(
                    onPress: () => SystemNavigator.pop(),
                    buttonText: "Exit",
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
