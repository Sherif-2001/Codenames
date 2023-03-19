import 'package:code_names/models/button_colors_enum.dart';
import 'package:code_names/models/team_colors_enum.dart';

List kButtonsColors = [
  ButtonColors.red,
  ButtonColors.red,
  ButtonColors.red,
  ButtonColors.red,
  ButtonColors.red,
  ButtonColors.red,
  ButtonColors.red,
  ButtonColors.red,
  ButtonColors.red,
  ButtonColors.red,
  ButtonColors.blue,
  ButtonColors.blue,
  ButtonColors.blue,
  ButtonColors.blue,
  ButtonColors.blue,
  ButtonColors.blue,
  ButtonColors.blue,
  ButtonColors.blue,
  ButtonColors.blue,
  ButtonColors.blue,
  ButtonColors.green,
  ButtonColors.green,
  ButtonColors.green,
  ButtonColors.green,
  ButtonColors.black
];

class Room {
  String roomKey;
  int blueWordsNum;
  int redWordsNum;
  int spymasterNum;
  bool timerEnded;
  TeamColors teamTurn;
  TeamColors teamWon;
  List words;
  List buttonsClicked;
  List buttonsColors;

  Room(
    this.roomKey,
    this.teamTurn,
    this.words,
    this.buttonsClicked,
    this.buttonsColors, {
    this.timerEnded = false,
    this.blueWordsNum = 10,
    this.redWordsNum = 10,
    this.spymasterNum = 0,
    this.teamWon = TeamColors.none,
  });

  factory Room.fromMap(Map<String, dynamic>? json) => Room(
        json!["roomKey"],
        teamColorsToEnum[json["TeamTurn"]]!,
        json["Words"],
        json["ButtonsClicked"],
        (json["ButtonsColors"].map((e) => ButtonColorsToEnum[e])).toList(),
        blueWordsNum: json["BlueWords"],
        redWordsNum: json["RedWords"],
        spymasterNum: json["Spymasters"],
        timerEnded: json["TimerEnded"],
        teamWon: teamColorsToEnum[json["TeamWon"]]!,
      );

  Map<String, dynamic> toMap() {
    return {
      "roomKey": roomKey,
      "BlueWords": blueWordsNum,
      "RedWords": redWordsNum,
      "Spymasters": spymasterNum,
      "TimerEnded": timerEnded,
      "TeamTurn": teamColorsToString[teamTurn],
      "TeamWon": teamColorsToString[teamWon],
      "Words": words,
      "ButtonsClicked": buttonsClicked,
      "ButtonsColors":
          (buttonsColors.map((e) => ButtonColorsToString[e])).toList(),
    };
  }
}
