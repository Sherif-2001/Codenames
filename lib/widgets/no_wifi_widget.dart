import 'package:flutter/material.dart';

class NoWifiWidget extends StatelessWidget {
  const NoWifiWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, color: Colors.white, size: 100),
          Text(
            "Check your connection",
            style: TextStyle(fontSize: 50, color: Colors.white),
          )
        ],
      ),
    );
  }
}
