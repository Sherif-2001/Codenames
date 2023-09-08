import 'dart:math';
import 'package:code_names/models/button_colors_enum.dart';
import 'package:code_names/models/room.dart';
import 'package:code_names/models/team_colors_enum.dart';
import 'package:english_words/english_words.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _mainCollection = FirebaseFirestore.instance.collection("Rooms");
final _roomKey = _mainCollection.doc().id;
final _roomDoc = _mainCollection.doc(_roomKey);
final _countdownController = CountdownController(autoStart: true);

class RoomProvider extends ChangeNotifier {
  bool _isSpymaster = false;
  Room _room = Room(
    _roomKey,
    TeamColors.values[Random().nextInt(1)],
    (nouns.toList()..shuffle()).take(25).toList(),
    List.generate(25, (index) => false),
    kButtonsColors..shuffle(),
  );

  void startGame() async {
    final _roomDoc = _mainCollection.doc(_room.roomKey);
    _isSpymaster = false;
    _room = Room(
      _roomKey,
      TeamColors.values[Random().nextInt(1)],
      (nouns.toList()..shuffle()).take(25).toList(),
      List.generate(25, (index) => false),
      kButtonsColors..shuffle(),
    );
    await _roomDoc.set(_room.toMap());

    listenToRoomParameters();
    notifyListeners();
  }

  void endGame(context) async {
    await _roomDoc.delete();
    notifyListeners();
  }

  void changeTurn() async {
    _room.teamTurn == TeamColors.blueTeam
        ? _room.teamTurn = TeamColors.redTeam
        : _room.teamTurn = TeamColors.blueTeam;

    _room.timerEnded = true;
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

  void listenToRoomParameters() {
    _roomDoc.snapshots().listen((snapshot) async {
      _room = Room.fromMap(snapshot.data());
      if (_room.timerEnded) {
        _room.timerEnded = false;
        _countdownController.restart();
        await _roomDoc.update(_room.toMap());
      }
      notifyListeners();
    });
  }

  // ==================== Getters =====================

  Room get room => _room;

  bool get isSpymaster => _isSpymaster;

  CountdownController get countdownController => _countdownController;
}
