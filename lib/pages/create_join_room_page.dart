import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_names/pages/gameplay_room_page.dart';
import 'package:code_names/provider/room_provider.dart';
import 'package:code_names/services/deep_link_handler.dart';
import 'package:code_names/services/internet_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CreateJoinRoom extends StatefulWidget {
  const CreateJoinRoom({super.key});

  static String id = "create_join_room";

  @override
  State<CreateJoinRoom> createState() => _CreateJoinRoomState();
}

class _CreateJoinRoomState extends State<CreateJoinRoom> {
  bool _isSpymasterChecked = false;
  String teamsColorsGroup = "blue";
  final interntHandler = InterntHandler();
  final deepLinkHandler = DeepLinkHandler();
  final TextEditingController roomKeyController = TextEditingController();

  void showSnackBar(BuildContext context, String title, String message) {
    final newSnackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.blueGrey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: ListTile(
        leading: Icon(
          Icons.signal_wifi_connected_no_internet_4_rounded,
          color: Colors.white,
          size: 30,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        subtitle: Text(
          message,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(newSnackBar);
  }

  /// Enter the room created and copy the room key to the clipboard
  void enterRoom(RoomProvider provider) {
    provider.createNewRoom(_isSpymasterChecked, teamsColorsGroup);
    Clipboard.setData(ClipboardData(text: provider.room.roomKey));
    Navigator.pushReplacementNamed(context, GameplayRoom.id);
  }

  /// Check if the room to join exists then join it
  void joinRoom(RoomProvider provider, String roomKey) async {
    await FirebaseFirestore.instance
        .collection("Rooms")
        .doc(roomKey)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        provider.joinRoom(roomKeyController.text, _isSpymasterChecked,
            teamsColorsGroup, snapshot.data());
        Navigator.pushReplacementNamed(context, GameplayRoom.id);
      } else {
        showSnackBar(
            context, "No Room Found", "There is no room with the given key");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    deepLinkHandler.initUniLinks();
  }

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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
          decoration: BoxDecoration(
              color: Colors.black45, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: roomKeyController,
                textAlign: TextAlign.center,
                maxLength: 20,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: "Enter Room Key",
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Spymaster",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      Checkbox(
                        value: _isSpymasterChecked,
                        onChanged: (value) {
                          setState(() {
                            _isSpymasterChecked = value!;
                          });
                        },
                        activeColor: Colors.green,
                      )
                    ],
                  ),
                  Container(
                    height: 80,
                    child: VerticalDivider(
                      color: Colors.white,
                      thickness: 2,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        "Blue Team",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      Radio(
                        groupValue: teamsColorsGroup,
                        value: "blue",
                        onChanged: (value) {
                          setState(() {
                            teamsColorsGroup = value.toString();
                          });
                        },
                        activeColor: Colors.blue,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Red Team",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                      Radio(
                        groupValue: teamsColorsGroup,
                        value: "red",
                        onChanged: (value) {
                          setState(() {
                            teamsColorsGroup = value.toString();
                          });
                        },
                        activeColor: Colors.red,
                      )
                    ],
                  )
                ],
              ),
              Consumer<RoomProvider>(builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: () async {
                    bool isConnected = await interntHandler.checkConnectivity();
                    if (!isConnected) {
                      showSnackBar(context, "No Internet Connection",
                          'Please check your internet connection!');
                    } else {
                      if (roomKeyController.text.isEmpty) {
                        enterRoom(provider);
                      } else {
                        joinRoom(provider, roomKeyController.text);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: Text(
                    "Create / Join Room",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
