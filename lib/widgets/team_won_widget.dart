import 'package:code_names/models/team_colors_enum.dart';
import 'package:flutter/material.dart';

class TeamWonWidget extends StatelessWidget {
  const TeamWonWidget(
      {super.key, required this.onPress, required this.teamWon});

  final VoidCallback onPress;
  final TeamColors teamWon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.red.shade800, Colors.blue.shade800],
            begin: Alignment.centerLeft,
            stops: [0.5, 0.5],
            end: Alignment.centerRight),
      ),
      constraints: BoxConstraints.expand(),
      child: Container(
        color: Colors.black45,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              teamWon == TeamColors.blueTeam ? "Blue Team Won" : "Red Team Won",
              style: TextStyle(
                  fontSize: 50,
                  color: teamWon == TeamColors.blueTeam
                      ? Colors.blue
                      : Colors.red),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    teamWon == TeamColors.blueTeam ? Colors.blue : Colors.red,
              ),
              onPressed: onPress,
              child: Text(
                "Return Home",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
