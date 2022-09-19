import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  HomeButton({this.onPress, this.borderColor, this.buttonText});
  final onPress;
  final borderColor;
  final buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(buttonText, style: TextStyle(fontSize: 30)),
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: EdgeInsets.all(10),
        primary: Colors.black26,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
