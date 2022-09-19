import 'package:english_words/english_words.dart';

enum TeamColors { blue, red }

const red = "0xFFF44336";
const blue = "0xFF2196F3";
const black = "0xFF000000";
const green = "0xFF4CAF50";

List kButtonsColorsList = [
  red,
  red,
  red,
  red,
  red,
  red,
  red,
  blue,
  blue,
  blue,
  blue,
  blue,
  blue,
  blue,
  black,
  green,
  green,
  green,
  green,
  green,
];
List kButtonsClickedList = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];
List kButtonsSpymastersClickedList = [
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true,
  true
];
List kWordsList = List.from(nouns);
