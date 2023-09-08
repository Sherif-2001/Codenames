import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_names/models/button_colors_enum.dart';
import 'package:code_names/models/room.dart';
import 'package:code_names/models/team_colors_enum.dart';
import 'package:code_names/pages/enter_room_page.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

final _mainCollection = FirebaseFirestore.instance.collection("Rooms");
String _roomKeytemp = "";
var _roomDoc = _mainCollection.doc(_roomKeytemp);

class EnterRoomProvider extends ChangeNotifier {
  bool _isSpymaster = false;
  Room _room = Room(
    "",
    TeamColors.values[Random().nextInt(1)],
    (nouns.toList()..shuffle()).take(25).toList(),
    List.generate(25, (index) => false),
    kButtonsColors..shuffle(),
  );

  void enterRoom(BuildContext context, TextEditingController controller) async {
    final snapshot = await _mainCollection.get();
    final roomsKeys = snapshot.docs.map((doc) => doc.id).toList();
    print(roomsKeys);
    if (roomsKeys.contains(controller.text)) {
      _room.roomKey = controller.text;
      _roomKeytemp = controller.text;
      controller.text = "Entering the room...";
      _isSpymaster = false;
      Navigator.popAndPushNamed(context, EnterRoom.id);
      listenToRoomParameters();
    } else {
      controller.text = "Room not found";
    }
    notifyListeners();
  }

  void listenToRoomParameters() {
    _roomDoc.snapshots().listen((snapshot) async {
      _room = Room.fromMap(snapshot.data());
      notifyListeners();
    });
  }

  void onSpymasterButton() async {
    if (_isSpymaster) {
      _room.spymasterNum--;
      _isSpymaster = false;
    } else if (_room.spymasterNum <= 1 && !_isSpymaster) {
      _room.spymasterNum++;
      _isSpymaster = true;
    }
    await _roomDoc.update(_room.toMap());
    notifyListeners();
  }

  void changeTurn() async {
    _room.teamTurn == TeamColors.blueTeam
        ? _room.teamTurn = TeamColors.redTeam
        : _room.teamTurn = TeamColors.blueTeam;

    await _roomDoc.update(_room.toMap());

    notifyListeners();
  }

  void onButtonClicked(BuildContext context, int index) async {
    if (_room.buttonsClicked[index] || _isSpymaster) return;

    _room.buttonsClicked[index] = true;

    switch (_room.buttonsColors[index]) {
      case ButtonColors.blue:
        {
          _room.blueWordsNum--;
          if (_room.teamTurn == TeamColors.redTeam) changeTurn();
          break;
        }
      case ButtonColors.red:
        {
          _room.redWordsNum--;
          if (_room.teamTurn == TeamColors.blueTeam) changeTurn();
          break;
        }
      case ButtonColors.black:
        {
          _room.teamWon = _room.teamTurn == TeamColors.blueTeam
              ? TeamColors.redTeam
              : TeamColors.blueTeam;
          break;
        }
      case ButtonColors.green:
        {
          changeTurn();
          break;
        }
    }

    if (_room.blueWordsNum == 0) {
      _room.teamWon = TeamColors.blueTeam;
    } else if (_room.redWordsNum == 0) {
      _room.teamWon = TeamColors.redTeam;
    }

    await _roomDoc.update(_room.toMap());
    notifyListeners();
  }

  // ================== Getters ====================

  Room get room => _room;

  bool get isSpymaster => _isSpymaster;
}
