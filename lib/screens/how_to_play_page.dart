import 'package:flutter/material.dart';

class HowToPlay extends StatelessWidget {
  const HowToPlay({Key? key}) : super(key: key);
  static String id = "howToPlayId";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.red.shade800, Colors.blue.shade800],
              begin: Alignment.centerLeft,
              stops: const [0.5, 0.5],
              end: Alignment.centerRight),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: const [
              Text(
                "⚪\tFirst, You need at least four players (two teams of two).",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    backgroundColor: Colors.black12),
              ),
              SizedBox(height: 20),
              Text(
                "⚪\tEach team chooses one player to be their spymaster.",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    backgroundColor: Colors.black12),
              ),
              SizedBox(height: 20),
              Text(
                "⚪\tThe spymaster should tell his team a clue (one word & one number)",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    backgroundColor: Colors.black12),
              ),
              SizedBox(height: 20),
              Text(
                "⚪\tThen the players should choose the words that match his clue",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    backgroundColor: Colors.black12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
