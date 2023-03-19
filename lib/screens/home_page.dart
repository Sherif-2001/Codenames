import 'package:code_names/provider/enter_room_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'create_room_page.dart';
import 'how_to_play_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../provider/room_provider.dart';
import '../widgets/home_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static String id = "homepageId";

  void showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
        width: 500,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 5),
        backgroundColor: Colors.black54,
        content: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  void saveRoomKeyToClipboard(BuildContext context) async {
    Clipboard.setData(
      ClipboardData(
          text: Provider.of<RoomProvider>(context, listen: false)
              .getRoom()
              .roomKey),
    ).then(
        (_) => showSnackBar(context, "Room Key is copied to your clipboard"));
  }

  void showEnterRoomDialog(BuildContext context, RoomProvider provider) async {
    final keyController = TextEditingController();

    Alert(
      context: context,
      title: "Enter Room Key",
      buttons: [],
      useRootNavigator: true,
      onWillPopActive: true,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: keyController,
            textAlign: TextAlign.center,
            maxLength: 20,
            style: TextStyle(fontSize: 20),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
                borderRadius: BorderRadius.circular(20),
              ),
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          Consumer<EnterRoomProvider>(
            builder: (context, value, child) => ElevatedButton(
              onPressed: () {
                value.enterRoom(context, keyController);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: Text('Join Room', style: TextStyle(fontSize: 25)),
            ),
          ),
        ],
      ),
      style: AlertStyle(
          titleStyle: TextStyle(fontSize: 30, color: Colors.white),
          backgroundColor: Colors.black,
          alertBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.green)),
          animationType: AnimationType.grow,
          animationDuration: Duration(milliseconds: 700)),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) => Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            snapshot.data == ConnectivityResult.none
                ? Icon(Icons.wifi_off)
                : Icon(Icons.wifi)
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.red.shade800, Colors.blue.shade800],
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
                  "CodeNames",
                  style: TextStyle(
                    fontSize: 80,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black, blurRadius: 20)],
                  ),
                ),
                Row(
                  children: [
                    Consumer<RoomProvider>(
                      builder: (context, provider, child) => HomeButton(
                        onPress: () {
                          if (snapshot.data == ConnectivityResult.none) {
                            showSnackBar(
                                context, "Check your internet connection");
                            return;
                          }
                          saveRoomKeyToClipboard(context);
                          Navigator.pushNamed(context, CreateRoom.id);
                          provider.startGame();
                        },
                        buttonText: "Create\nRoom",
                      ),
                    ),
                    SizedBox(width: 20),
                    Consumer<RoomProvider>(
                      builder: (context, provider, child) => HomeButton(
                        onPress: () {
                          if (snapshot.data == ConnectivityResult.none) {
                            showSnackBar(
                                context, "Check your internet connection");
                            return;
                          }
                          showEnterRoomDialog(context, provider);
                        },
                        buttonText: "Enter\nRoom",
                      ),
                    ),
                    SizedBox(width: 20),
                    HomeButton(
                      onPress: () => Navigator.pushNamed(context, HowToPlay.id),
                      buttonText: "How to\nPlay",
                    ),
                    SizedBox(width: 20),
                    HomeButton(
                      onPress: () => SystemNavigator.pop(),
                      buttonText: "Exit\nGame",
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
