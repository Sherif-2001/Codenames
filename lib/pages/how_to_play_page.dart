import 'package:flutter/material.dart';

class HowToPlay extends StatelessWidget {
  const HowToPlay({Key? key}) : super(key: key);
  static String id = "how_to_play";

  @override
  Widget build(BuildContext context) {
    const String howToPlayText = '''

-\tThe game must be played with at least four players (two teams of two)

-\tEach team chooses one player to be their spymaster

-\tThe spymaster can see the colors of the words and gives on clue (one word & one number) to his team

-\tThen the players should choose the words that match his clue

-\tThe first team to select all the buttons with the correct color wins
        ''';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffDA1212), Color(0xff11468F)],
            stops: [0.5, 0.5],
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          color: Colors.black38,
          child: SingleChildScrollView(
            child: Text(
              howToPlayText,
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
