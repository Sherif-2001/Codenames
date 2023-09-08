import 'package:flutter/material.dart';

class HowToPlay extends StatelessWidget {
  const HowToPlay({Key? key}) : super(key: key);
  static String id = "howToPlayId";

  @override
  Widget build(BuildContext context) {
    const String howToPlayText = '''

-\tThe game must be played with at least four players (two teams of two).

-\tEach team chooses one player to be their spymaster.

-\tThe spymaster can see the colors of the words and gives on clue (one word & one number) to his team.

-\tThen the players should choose the words that match his clue
        ''';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade800, Colors.blue.shade800],
            stops: [0.5, 0.5],
          ),
        ),
        child: SingleChildScrollView(
          child: Text(
            howToPlayText,
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
