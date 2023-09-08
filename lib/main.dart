import 'package:code_names/provider/enter_room_provider.dart';
import 'package:code_names/pages/splash_page.dart';
import 'pages/enter_room_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pages/how_to_play_page.dart';
import 'provider/room_provider.dart';
import 'pages/create_room_page.dart';
import 'pages/home_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RoomProvider()),
        ChangeNotifierProvider(create: (context) => EnterRoomProvider())
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "oleoScript"),
        routes: {
          SplashScreen.id: (context) => SplashScreen(),
          HomePage.id: (context) => HomePage(),
          HowToPlay.id: (context) => HowToPlay(),
          CreateRoom.id: (context) => CreateRoom(),
          EnterRoom.id: (context) => EnterRoom()
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
