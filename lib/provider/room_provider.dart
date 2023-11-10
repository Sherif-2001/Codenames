import 'dart:async';
import 'dart:math';
import 'package:code_names/models/button.dart';
import 'package:code_names/constants/button_colors_enum.dart';
import 'package:code_names/models/player.dart';
import 'package:code_names/models/room.dart';
import 'package:code_names/models/team.dart';
import 'package:code_names/constants/team_colors_enum.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomProvider extends ChangeNotifier {
  final CollectionReference<Map<String, dynamic>> _mainCollection =
      FirebaseFirestore.instance.collection("Rooms");

  late DocumentReference<Map<String, dynamic>> _roomRef;
  late CollectionReference<Map<String, dynamic>> _playersRef;

  late Room _currentRoom;
  bool _isSpymaster = false;
  TeamColors _myTeam = TeamColors.none;
  String _myId = "";
  int _remainingTime = 0;

  // =========================================================================================

  /// Start the game by creating a new room and check if you [isSpymaster] and your [teamColor]
  void createNewRoom(bool isSpymaster, String teamColor) async {
    final colorsList = kButtonsColors..shuffle();
    final words = (nouns.toList()..shuffle()).toList();
    _isSpymaster = isSpymaster;
    _myTeam = teamColorsToEnum[teamColor]!;
    final isFirstTurn = Random().nextBool();

    _roomRef = _mainCollection.doc();
    _playersRef = _roomRef.collection("Players");
    _currentRoom = Room(
        _roomRef.id,
        List.generate(25,
            (index) => Button(index, words[index], false, colorsList[index])),
        Team(false, isFirstTurn, 10),
        Team(false, !isFirstTurn, 10),
        null);

    await _roomRef.set(_currentRoom.toMap());
    await _playersRef
        .add(Player(_myTeam, _isSpymaster).toMap())
        .then((player) => {_myId = player.id});

    createTimer();

    listenToGameRoom();
  }

  // =========================================================================================

  /// Join the room using [roomKey] and choose wether you [isSpymaster] and your [teamColor]
  void joinRoom(String roomKey, bool isSpymaster, String teamColor,
      Map<String, dynamic>? roomData) async {
    _myTeam = teamColorsToEnum[teamColor]!;
    _roomRef = _mainCollection.doc(roomKey);
    _playersRef = _roomRef.collection("Players");
    _currentRoom = Room.fromMap(roomData);

    await _playersRef.get().then((snapshot) {
      final isSpymasterExist = snapshot.docs.any((element) =>
          element.data()["isSpymaster"] && element.data()["team"] == teamColor);
      _playersRef
          .add(Player(_myTeam, isSpymasterExist ? false : isSpymaster).toMap())
          .then((player) => {_myId = player.id});
      _isSpymaster = isSpymasterExist ? false : isSpymaster;
    });

    createTimer();
    listenToGameRoom();
  }

  // =========================================================================================

  /// End game by deleting the room
  Future exitRoom() async {
    await _playersRef.doc(_myId).delete();
    await _playersRef
        .get()
        .then((snapshot) => {if (snapshot.docs.isEmpty) _roomRef.delete()});
    notifyListeners();
  }

  // =========================================================================================

  /// Change turns of the teams
  void changeTurns() async {
    _currentRoom.redTeam.isTeamTurn = !_currentRoom.redTeam.isTeamTurn;
    _currentRoom.blueTeam.isTeamTurn = !_currentRoom.blueTeam.isTeamTurn;

    updateRoom();
    notifyListeners();
  }

  // =========================================================================================

  /// Click on a button in the grid and check it using [index]
  void onButtonClicked(int index) async {
    if (_currentRoom.buttons[index].isClicked || _isSpymaster || !isMyTurn)
      return;

    _currentRoom.buttons[index].isClicked = true;
    checkButtonClicked(index);

    if (_currentRoom.blueTeam.wordsRemaining == 0) {
      _currentRoom.blueTeam.hasWon = true;
    } else if (_currentRoom.redTeam.wordsRemaining == 0) {
      _currentRoom.redTeam.hasWon = true;
    }

    updateRoom();
    notifyListeners();
  }

  // =========================================================================================

  /// Check the color of the button clicked using [index]
  void checkButtonClicked(int index) {
    switch (_currentRoom.buttons[index].color) {
      case ButtonColors.blue:
        {
          _currentRoom.redTeam.isTeamTurn
              ? changeTurns()
              : _currentRoom.blueTeam.wordsRemaining--;
          break;
        }
      case ButtonColors.red:
        {
          _currentRoom.blueTeam.isTeamTurn
              ? changeTurns()
              : _currentRoom.redTeam.wordsRemaining--;
          break;
        }
      case ButtonColors.black:
        {
          _currentRoom.redTeam.isTeamTurn
              ? _currentRoom.blueTeam.hasWon = true
              : _currentRoom.redTeam.hasWon = true;
          break;
        }
      default:
        {
          changeTurns();
          break;
        }
    }
  }

  // =========================================================================================

  /// Update the room parameters in the database
  void updateRoom() async {
    await _roomRef.update(_currentRoom.toMap());
    notifyListeners();
  }

  // =========================================================================================

  /// Listen to change in parameters in the room
  void listenToGameRoom() {
    _roomRef.snapshots().listen(
      (snapshot) {
        if (snapshot.exists) _currentRoom = Room.fromMap(snapshot.data());
      },
    );
    notifyListeners();
  }

  // =========================================================================================

  void createTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      int elapsedTime =
          DateTime.now().difference(_currentRoom.startDate!).inSeconds;

      _remainingTime = 120 - elapsedTime;

      if (_remainingTime <= 0) {
        changeTurns();
      }

      _roomRef.get().then((room) => !room.exists ? timer.cancel() : null);

      notifyListeners();
    });
  }

  // ======================================== Getters ========================================

  Room get room => _currentRoom;

  TeamColors get team => _myTeam;

  bool get isSpymaster => _isSpymaster;

  int get remainingTime => _remainingTime;

  bool get isMyTurn =>
      (_currentRoom.blueTeam.isTeamTurn && _myTeam == TeamColors.blueTeam) ||
      (_currentRoom.redTeam.isTeamTurn && _myTeam == TeamColors.redTeam);
}
