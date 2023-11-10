import 'package:code_names/constants/team_colors_enum.dart';

class Player {
  TeamColors team;
  bool isSpymaster;

  Player(this.team, this.isSpymaster);

  factory Player.fromMap(Map<String, dynamic>? json) => Player(
        teamColorsToEnum[json!["team"]]!,
        json["isSpymaster"],
      );

  Map<String, dynamic> toMap() {
    return {
      "team": teamColorsToString[team],
      "isSpymaster": isSpymaster,
    };
  }
}
