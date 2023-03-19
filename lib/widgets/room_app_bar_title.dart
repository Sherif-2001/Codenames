import 'package:code_names/models/room.dart';
import 'package:code_names/provider/room_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer_count_down/timer_count_down.dart';

class RoomAppBarTitle extends StatelessWidget {
  const RoomAppBarTitle({super.key, required this.room});

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
          children: [Text("Red"), Text(room.redWordsNum.toString())],
        ),
        Column(
          children: [Text("Blue"), Text(room.blueWordsNum.toString())],
        ),
        Consumer<RoomProvider>(
          builder: (context, provider, child) => Countdown(
            seconds: 120,
            controller: provider.getTimerController(),
            onFinished: () {
              provider.changeTurn();
            },
            build: (context, time) {
              return Text("Time Left : ${time.toString()}");
            },
          ),
        )
      ],
    );
  }
}
