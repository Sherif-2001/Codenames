import 'package:code_names/constants/button_colors_enum.dart';
import 'package:code_names/constants/team_colors_enum.dart';
import 'package:code_names/provider/room_provider.dart';
import 'package:code_names/widgets/no_internet_widget.dart';
import 'package:code_names/widgets/room_app_bar_title.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class GameplayRoom extends StatelessWidget {
  GameplayRoom({Key? key}) : super(key: key);
  static String id = "gameplay_room";

  final Map<ButtonColors, Color> colors = {
    ButtonColors.blue: Colors.blue,
    ButtonColors.red: Colors.red,
    ButtonColors.green: Colors.green,
    ButtonColors.black: Colors.black,
  };

  void showGameOver(
      BuildContext context, TeamColors teamWon, RoomProvider provider) {
    Alert(
      context: context,
      buttons: [],
      onWillPopActive: true,
      padding: EdgeInsets.all(20),
      style: AlertStyle(isCloseButton: false),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            teamWon == TeamColors.blueTeam ? "Blue Team Won" : "Red Team Won",
            style: TextStyle(
                fontSize: 50,
                color:
                    teamWon == TeamColors.blueTeam ? Colors.blue : Colors.red),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  teamWon == TeamColors.blueTeam ? Colors.blue : Colors.red,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await provider.exitRoom().then((value) => Navigator.pop(context));
            },
            child: Text(
              "Return Home",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ],
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, provider, child) => WillPopScope(
        onWillPop: () async {
          await provider.exitRoom().then((value) => Navigator.pop(context));
          return false;
        },
        child: Scaffold(
          backgroundColor:
              provider.room.redTeam.isTeamTurn ? Colors.red : Colors.blue,
          appBar: AppBar(
            backgroundColor: Colors.black54,
            elevation: 0,
            centerTitle: true,
            title: RoomAppBarTitle(room: provider.room),
          ),
          body: StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ListView(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          childAspectRatio: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: 25,
                        itemBuilder: (BuildContext context, int index) {
                          return ElevatedButton(
                            onPressed: () {
                              provider.onButtonClicked(index);
                              if (provider.room.blueTeam.hasWon) {
                                showGameOver(
                                    context, TeamColors.blueTeam, provider);
                              } else if (provider.room.redTeam.hasWon) {
                                showGameOver(
                                    context, TeamColors.redTeam, provider);
                              }
                            },
                            style: !provider.isSpymaster
                                ? ElevatedButton.styleFrom(
                                    foregroundColor:
                                        provider.room.buttons[index].isClicked
                                            ? Colors.white
                                            : Colors.black,
                                    elevation: 10,
                                    backgroundColor: provider
                                            .room.buttons[index].isClicked
                                        ? colors[
                                            provider.room.buttons[index].color]
                                        : Colors.white,
                                    side: BorderSide(
                                      color:
                                          provider.room.buttons[index].isClicked
                                              ? Colors.white
                                              : Colors.black,
                                      width: 2,
                                    ),
                                  )
                                : ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    elevation: 10,
                                    backgroundColor: colors[
                                        provider.room.buttons[index].color],
                                    side: BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                            child: FittedBox(
                              child: Text(
                                provider.room.buttons[index].word,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: "",
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed:
                            provider.isMyTurn ? provider.changeTurns : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          side: BorderSide(width: 2),
                          backgroundColor: Colors.white60,
                        ),
                        child: Text(
                          "End Turn",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return NoInternetWidget();
              }
            },
          ),
        ),
      ),
    );
  }
}
