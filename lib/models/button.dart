import 'package:code_names/constants/button_colors_enum.dart';

class Button {
  int index;
  bool isClicked;
  String word;
  ButtonColors color;

  Button(this.index, this.word, this.isClicked, this.color);

  factory Button.fromMap(Map<String, dynamic>? json) => Button(
        json!["index"],
        json["word"],
        json["isClicked"],
        ButtonColorsToEnum[json["color"]]!,
      );

  Map<String, dynamic> toMap() {
    return {
      "index": index,
      "word": word,
      "isClicked": isClicked,
      "color": ButtonColorsToString[color],
    };
  }
}
