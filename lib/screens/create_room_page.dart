import 'package:code_names/models/button_colors_enum.dart';
import 'package:code_names/models/team_colors_enum.dart';
import 'package:code_names/widgets/no_wifi_widget.dart';
import 'package:code_names/widgets/room_app_bar_title.dart';
import 'package:code_names/widgets/team_won_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/room_provider.dart';

class CreateRoom extends StatelessWidget {
  CreateRoom({Key? key}) : super(key: key);
  static String id = "createRoomId";

  final Map<ButtonColors, Color> colors = {
    ButtonColors.blue: Colors.blue,
    ButtonColors.red: Colors.red,
    ButtonColors.green: Colors.green,
    ButtonColors.black: Colors.black,
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<RoomProvider>(
      builder: (context, provider, child) => WillPopScope(
        onWillPop: () async {
          provider.endGame(context);
          return false;
        },
        child: provider.getRoom().teamWon != TeamColors.none
            ? Scaffold(
                body: TeamWonWidget(
                    onPress: () {
                      provider.endGame(context);
                      Navigator.pop(context);
                    },
                    teamWon: provider.getRoom().teamWon),
              )
            : Scaffold(
                backgroundColor:
                    provider.getRoom().teamTurn == TeamColors.redTeam
                        ? Colors.red
                        : Colors.blue,
                appBar: AppBar(
                  backgroundColor: Colors.black54,
                  elevation: 0,
                  centerTitle: true,
                  title: RoomAppBarTitle(room: provider.getRoom()),
                ),
                body: StreamBuilder<ConnectivityResult>(
                  stream: Connectivity().onConnectivityChanged,
                  builder: (context, snapshot) => snapshot.data ==
                          ConnectivityResult.none
                      ? NoWifiWidget()
                      : Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListView(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: 25,
                                itemBuilder: (BuildContext context, int index) {
                                  return ElevatedButton(
                                    onPressed: () => provider.onButtonClicked(
                                        context, index),
                                    style: !provider.getIsSpymaster()
                                        ? ElevatedButton.styleFrom(
                                            foregroundColor: provider
                                                    .getRoom()
                                                    .buttonsClicked[index]
                                                ? Colors.white
                                                : Colors.black,
                                            elevation: 10,
                                            backgroundColor: provider
                                                    .getRoom()
                                                    .buttonsClicked[index]
                                                ? colors[provider
                                                    .getRoom()
                                                    .buttonsColors[index]]
                                                : Colors.white,
                                            side: BorderSide(
                                              color: provider
                                                      .getRoom()
                                                      .buttonsClicked[index]
                                                  ? Colors.white
                                                  : Colors.black,
                                              width: 2,
                                            ),
                                          )
                                        : ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            elevation: 10,
                                            backgroundColor: colors[provider
                                                .getRoom()
                                                .buttonsColors[index]],
                                            side: BorderSide(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                          ),
                                    child: Text(
                                      provider.getRoom().words[index],
                                      style: TextStyle(
                                          fontSize: 15, fontFamily: ""),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: provider.changeTurn,
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
                              ElevatedButton(
                                onPressed: provider.onSpymasterButton,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: BorderSide(width: 2),
                                  backgroundColor: Colors.white60,
                                ),
                                child: Text(
                                  "Spymaster",
                                  style: TextStyle(fontSize: 25),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
      ),
    );
  }
}
