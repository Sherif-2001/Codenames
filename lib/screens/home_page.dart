// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'create_room_page.dart';
import 'how_to_play_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../brain.dart';
import '../custom_widgets/home_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String id = "homepageId";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<Brain>(context, listen: false).checkInternetConnection();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: InternetConnectionChecker().onStatusChange,
        builder: (context, snapshot) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.red.shade800, Colors.blue.shade800],
                          begin: Alignment.centerLeft,
                          stops: [0.5, 0.5],
                          end: Alignment.centerRight)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              ColorizeAnimatedText(
                                'CodeNames',
                                speed: Duration(milliseconds: 500),
                                colors: [
                                  Colors.white,
                                  Colors.white,
                                  Colors.red,
                                  Colors.blue,
                                  Colors.white,
                                  Colors.white,
                                ],
                                textStyle: TextStyle(
                                  fontSize: 80,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 10)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: HomeButton(
                                  borderColor: Colors.red,
                                  buttonText: "Create Room",
                                  onPress: () {
                                    Provider.of<Brain>(context, listen: false)
                                        .startGame(context);
                                    Navigator.pushNamed(context, CreateRoom.id);
                                    Clipboard.setData(ClipboardData(
                                            text: Provider.of<Brain>(context,
                                                    listen: false)
                                                .getRoomKey()))
                                        .then(
                                      (_) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            elevation: 5,
                                            width: 300,
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 5),
                                            backgroundColor: Colors.blueGrey,
                                            content: Text(
                                              "Room Key is copied to your clipboard",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 100),
                              Expanded(
                                child: HomeButton(
                                  borderColor: Colors.blue,
                                  buttonText: "Enter Room",
                                  onPress: () =>
                                      Provider.of<Brain>(context, listen: false)
                                          .onEnterRoomKey(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: HomeButton(
                                  borderColor: Colors.red,
                                  buttonText: "How to Play",
                                  onPress: () => Navigator.pushNamed(
                                      context, HowToPlay.id),
                                ),
                              ),
                              SizedBox(width: 100),
                              Expanded(
                                child: HomeButton(
                                    onPress: () => SystemNavigator.pop(),
                                    borderColor: Colors.blue,
                                    buttonText: "Exit"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: Provider.of<Brain>(context).getInternetStatus(),
                  child: Container(
                    color: Colors.black87,
                    constraints: BoxConstraints.expand(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          color: Colors.white,
                          size: 100,
                        ),
                        Text(
                          "Check your connection",
                          style: TextStyle(fontSize: 50, color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ));
  }
}
