// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_names/constants.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../brain.dart';

final _firebaseFirestore = FirebaseFirestore.instance;

class EnterRoom extends StatelessWidget {
  EnterRoom({Key? key}) : super(key: key);
  static String id = "enterRoomId";

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                              Provider.of<Brain>(context).getWordAtIndex(index),
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
                        },
                        child: Text("End Turn", style: TextStyle(fontSize: 25)),
                        style: ElevatedButton.styleFrom(
                            side: BorderSide(width: 2),
                            primary: Colors.white60,
                            onPrimary: Colors.black),
                      ),
                      ElevatedButton(
                        onPressed:
                            Provider.of<Brain>(context).getSpymastersNum() <= 1
                                ? () =>
                                    Provider.of<Brain>(context, listen: false)
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
                            style: TextStyle(fontSize: 50, color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
