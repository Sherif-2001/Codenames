import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  const HomeButton(
      {super.key,
      required this.onPress,
      required this.borderColor,
      required this.buttonText});
  final VoidCallback onPress;
  final Color borderColor;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        elevation: 1,
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.black26,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(buttonText, style: const TextStyle(fontSize: 30)),
    );
  }
}
