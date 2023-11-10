import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_names/models/button.dart';
import 'package:code_names/models/team.dart';

class Room {
  String roomKey;
  List buttons;
  Team redTeam;
  Team blueTeam;
  DateTime? startDate;

  Room(this.roomKey, this.buttons, this.blueTeam, this.redTeam, this.startDate);

  factory Room.fromMap(Map<String, dynamic>? json) => Room(
      json!["roomKey"],
      (json["Buttons"].map((json) => Button.fromMap(json))).toList(),
      Team.fromMap(json["BlueTeam"]),
      Team.fromMap(json["RedTeam"]),
      json["startDate"].toDate());

  Map<String, dynamic> toMap() {
    return {
      "roomKey": roomKey,
      "BlueTeam": blueTeam.toMap(),
      "RedTeam": redTeam.toMap(),
      "Buttons": buttons.map((button) => button.toMap()).toList(),
      "startDate": FieldValue.serverTimestamp()
    };
  }
}
