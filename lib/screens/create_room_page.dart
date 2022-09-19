// ignore_for_file: prefer_const_constructors

import 'package:code_names/constants.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../brain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timer_count_down/timer_count_down.dart';

final _firebaseFirestore = FirebaseFirestore.instance;

class CreateRoom extends StatelessWidget {
  CreateRoom({Key? key}) : super(key: key);
  static String id = "createRoomId";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _firebaseFirestore
            .collection("Game")
            .doc(Provider.of<Brain>(context, listen: false).getRoomKey())
            .delete();
        return true;
      },
      child: StreamBuilder(
          stream: _firebaseFirestore
              .collection("Game")
              .doc(Provider.of<Brain>(context).getRoomKey())
              .snapshots(),
          builder: (context, snapshot) {
            return Scaffold(
              backgroundColor: Provider.of<Brain>(context).getBackgroundColor(),
              appBar: AppBar(
                backgroundColor: Colors.black54,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Room Key : \t${Provider.of<Brain>(context).getRoomKey()}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                        "Red:${Provider.of<Brain>(context).getWordsRemained(TeamColors.red)}",
                        style: TextStyle(fontSize: 20)),
                    Text(
                      "Blue:${Provider.of<Brain>(context).getWordsRemained(TeamColors.blue)}",
                      style: TextStyle(fontSize: 20),
                    ),
                    Countdown(
                      seconds: 120,
                      controller: Provider.of<Brain>(context, listen: false)
                          .getTimerController(),
                      onFinished: () {
                        Provider.of<Brain>(context, listen: false).changeTurn();
                        Provider.of<Brain>(context, listen: false)
                            .getTimerController()
                            .restart();
                      },
                      build: (context, time) {
                        return Text("Time Left : ${time.toString()}");
                      },
                    )
                  ],
                ),
              ),
              body: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  childAspectRatio: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: 20,
                          itemBuilder: (BuildContext context, int index) {
                            return ElevatedButton(
                              onPressed: () {
                                Provider.of<Brain>(context, listen: false)
                                    .onButtonClicked(context, index);
                              },
                              child: Text(
                                Provider.of<Brain>(context)
                                    .getWordAtIndex(index),
                                style: TextStyle(fontSize: 15, fontFamily: ""),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 10,
                                primary: Provider.of<Brain>(context)
                                        .getButtonClickedAtIndex(index)
                                    ? Color(Provider.of<Brain>(context)
                                        .getColorAtIndex(index))
                                    : Colors.white,
                                onPrimary: Provider.of<Brain>(context)
                                        .getButtonClickedAtIndex(index)
                                    ? Colors.white
                                    : Colors.black,
                                side: BorderSide(
                                    color: Provider.of<Brain>(context)
                                            .getButtonClickedAtIndex(index)
                                        ? Colors.white
                                        : Colors.black,
                                    width: 2),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () => {
                            Provider.of<Brain>(context, listen: false)
                                .changeTurn(),
                            Provider.of<Brain>(context, listen: false)
                                .getTimerController()
                                .restart()
                          },
                          child:
                              Text("End Turn", style: TextStyle(fontSize: 25)),
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 2),
                              primary: Colors.white60,
                              onPrimary: Colors.black),
                        ),
                        ElevatedButton(
                          onPressed: Provider.of<Brain>(context)
                                      .getSpymastersNum() <=
                                  1
                              ? () => Provider.of<Brain>(context, listen: false)
                                  .spymasterButton()
                              : null,
                          child:
                              Text("Spymaster", style: TextStyle(fontSize: 25)),
                          style: ElevatedButton.styleFrom(
                              side: BorderSide(width: 2),
                              primary: Colors.white60,
                              onPrimary: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  StreamBuilder(
                    stream: InternetConnectionChecker().onStatusChange,
                    builder: (context, snapshot) => Visibility(
                      visible: Provider.of<Brain>(context).getInternetStatus(),
                      child: Container(
                        color: Colors.black87,
                        constraints: BoxConstraints.expand(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wifi_off,
                              color: Colors.white,
                              size: 100,
                            ),
                            Text(
                              "Check your connection",
                              style:
                                  TextStyle(fontSize: 50, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
