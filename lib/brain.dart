// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'dart:math';
import 'package:code_names/screens/enter_room_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'constants.dart';
import 'screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firebaseFirestore = FirebaseFirestore.instance;
final docGame = _firebaseFirestore.collection("Game");
final _countdownController = CountdownController(autoStart: true);

class Brain extends ChangeNotifier {
  Color _backgroundColor = Colors.white;
  String _roomKey = "";
  int _blueWordsRemained = 7;
  int _redWordsRemained = 7;
  List _tempButtonClickedList = kButtonsClickedList;
  List _tempButtonColorsList = kButtonsColorsList;
  List _tempWordsList = kWordsList;
  int _spymastersNum = 0;
  bool isSpymaster = false;
  bool isConnected = false;

  Color getBackgroundColor() {
    return _backgroundColor;
  }

  int getWordsRemained(TeamColors color) {
    if (color == TeamColors.red) {
      return _redWordsRemained;
    } else if (color == TeamColors.blue) {
      return _blueWordsRemained;
    } else {
      return 0;
    }
  }

  String getRoomKey() {
    return _roomKey;
  }

  String getWordAtIndex(int index) {
    return _tempWordsList[index] ?? "";
  }

  int getColorAtIndex(int index) {
    return int.parse(_tempButtonColorsList[index]);
  }

  bool getButtonClickedAtIndex(int index) {
    return _tempButtonClickedList[index];
  }

  int getSpymastersNum() {
    return _spymastersNum;
  }

  CountdownController getTimerController() {
    return _countdownController;
  }

  bool getInternetStatus() {
    return isConnected;
  }

  void changeTurn() async {
    final snapshot = await docGame.doc(_roomKey).get();

    if (snapshot.data()!["TeamTurn"]) {
      await docGame.doc(_roomKey).update({"TeamTurn": false});
      _backgroundColor = Colors.red;
    } else {
      await docGame.doc(_roomKey).update({"TeamTurn": true});
      _backgroundColor = Colors.blue;
    }
    docGame.doc(_roomKey).update({"TimerEnded": true});

    notifyListeners();
  }

  void onButtonClicked(BuildContext context, int index) async {
    final snapshot = await docGame.doc(_roomKey).get();

    if (!snapshot.data()!["Buttons"]["Clicked"][index] &&
        !_tempButtonClickedList[index]) {
      _tempButtonClickedList[index] = true;
      docGame.doc(_roomKey).update({"Buttons.Clicked": _tempButtonClickedList});

      switch (snapshot.data()!["Buttons"]["Colors"][index]) {
        case blue:
          {
            await docGame
                .doc(_roomKey)
                .update({"BlueWordsRemaining": FieldValue.increment(-1)});
            snapshot.data()!["TeamTurn"] ? null : changeTurn();
            break;
          }
        case red:
          {
            await docGame
                .doc(_roomKey)
                .update({"RedWordsRemaining": FieldValue.increment(-1)});
            snapshot.data()!["TeamTurn"] ? changeTurn() : null;
            break;
          }
        case black:
          {
            snapshot.data()!["TeamTurn"]
                ? docGame.doc(_roomKey).update({"TeamWon": 2})
                : docGame.doc(_roomKey).update({"TeamWon": 1});
            break;
          }
        case green:
          {
            changeTurn();
            break;
          }
      }
    }
    CheckRemainingWords(context);
    notifyListeners();
  }

  void CheckRemainingWords(BuildContext context) async {
    final snapshot = await docGame.doc(_roomKey).get();

    if (snapshot.data()!["BlueWordsRemaining"] == 0) {
      docGame.doc(_roomKey).update({"TeamWon": 1});
    } else if (snapshot.data()!["RedWordsRemaining"] == 0) {
      docGame.doc(_roomKey).update({"TeamWon": 2});
    }
  }

  void startGame(BuildContext context) async {
    isSpymaster = false;
    _roomKey = docGame.doc().id;
    await docGame.doc(_roomKey).set({
      "TeamTurn": Random().nextBool(),
      "BlueWordsRemaining": 7,
      "RedWordsRemaining": 7,
      "TeamWon": 0,
      "Spymasters": 0,
      "TimerEnded": false,
      "Buttons": {
        "Colors": kButtonsColorsList..shuffle(),
        "Clicked": kButtonsClickedList,
        "Words": kWordsList..shuffle(),
      }
    });
    final snapshot = await docGame.doc(_roomKey).get();
    _tempButtonClickedList = snapshot.data()!["Buttons"]["Clicked"];
    _tempWordsList = snapshot.data()!["Buttons"]["Words"];

    GameStatsStreamListener(context);
    notifyListeners();
  }

  void onTeamWin(BuildContext context, TeamColors teamWon) {
    Alert(
      context: context,
      title: teamWon == TeamColors.blue ? "Blue Team Won" : "Red Team Won",
      buttons: [
        DialogButton(
          color: teamWon == TeamColors.blue ? Colors.blue : Colors.red,
          onPressed: () => {
            Navigator.pushReplacementNamed(context, HomePage.id),
            docGame.doc(_roomKey).delete()
          },
          child: Text(
            "Return Home",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
      onWillPopActive: true,
      useRootNavigator: true,
      style: AlertStyle(
        isCloseButton: false,
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: teamWon == TeamColors.blue ? Colors.blue : Colors.red,
            width: 2,
          ),
        ),
        titleStyle: TextStyle(
          fontSize: 30,
          color: teamWon == TeamColors.blue ? Colors.blue : Colors.red,
        ),
      ),
    ).show();
    notifyListeners();
  }

  void spymasterButton() {
    if (!isSpymaster) {
      docGame.doc(_roomKey).update({"Spymasters": FieldValue.increment(1)});
    } else {
      docGame.doc(_roomKey).update({"Spymasters": FieldValue.increment(-1)});
    }
    isSpymaster = !isSpymaster;

    notifyListeners();
  }

  void GameStatsStreamListener(BuildContext context) async {
    docGame.doc(_roomKey).snapshots().listen((event) {
      _blueWordsRemained = event.data()!["BlueWordsRemaining"];
      _redWordsRemained = event.data()!["RedWordsRemaining"];
      _spymastersNum = event.data()!["Spymasters"];
      _tempWordsList = event.data()!["Buttons"]["Words"];
      _tempButtonClickedList = isSpymaster
          ? kButtonsSpymastersClickedList
          : event.data()!["Buttons"]["Clicked"];
      _backgroundColor = event.data()!["TeamTurn"] ? Colors.blue : Colors.red;
      _tempButtonColorsList = event.data()!["Buttons"]["Colors"];
      if (event.data()!["TeamWon"] == 1) {
        onTeamWin(context, TeamColors.blue);
      } else if (event.data()!["TeamWon"] == 2) {
        onTeamWin(context, TeamColors.red);
      }
      if (event.data()!["TimerEnded"]) {
        _countdownController.restart();
        docGame.doc(_roomKey).update({"TimerEnded": false});
      }
    });
    notifyListeners();
  }

  void onEnterRoomKey(BuildContext context) async {
    final keyController = TextEditingController();
    final snapshot = await docGame.get();

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
          ElevatedButton(
            onPressed: () async {
              for (var doc in snapshot.docs) {
                if (doc.id == keyController.text) {
                  _roomKey = doc.id;
                  Navigator.pop(context);
                  GameStatsStreamListener(context);
                  Navigator.pushNamed(context, EnterRoom.id);
                }
              }
              keyController.text = "Room not found";
            },
            style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text('Join Room', style: TextStyle(fontSize: 25)),
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
    notifyListeners();
  }

  void checkInternetConnection() {
    InternetConnectionChecker().onStatusChange.listen((status) {
      status == InternetConnectionStatus.connected
          ? isConnected = false
          : isConnected = true;
    });
    notifyListeners();
  }
}
