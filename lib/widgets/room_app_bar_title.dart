import 'package:code_names/constants/team_colors_enum.dart';
import 'package:code_names/models/room.dart';
import 'package:code_names/provider/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomAppBarTitle extends StatelessWidget {
  RoomAppBarTitle({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Room Key : \t${room.roomKey}",
          style: TextStyle(fontSize: 20),
        ),
        Column(
          children: [
            Text("Red"),
            Text(room.redTeam.wordsRemaining.toString()),
          ],
        ),
        Column(
          children: [
            Text("Blue"),
            Text(room.blueTeam.wordsRemaining.toString())
          ],
        ),
        Column(
          children: [
            Text("My Team"),
            Consumer<RoomProvider>(
              builder: (context, provider, child) => Text(
                teamColorsToString[provider.team]!.toUpperCase(),
                style: TextStyle(
                    color: provider.team == TeamColors.blueTeam
                        ? Colors.blue
                        : Colors.red),
              ),
            )
          ],
        ),
        Consumer<RoomProvider>(
            builder: (context, provider, child) =>
                Text("Time Left : ${provider.remainingTime}"))
      ],
    );
  }
}
