import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  HomeButton({this.onPress, this.buttonText});
  final onPress;
  final buttonText;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          backgroundColor: Colors.black26,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          side: BorderSide(color: Colors.white, width: 2),
        ),
        child: Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
      ),
    );
  }
}
