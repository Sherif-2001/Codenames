import 'package:code_names/pages/create_join_room_page.dart';
import 'package:code_names/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pages/how_to_play_page.dart';
import 'provider/room_provider.dart';
import 'pages/gameplay_room_page.dart';
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
        // ChangeNotifierProvider(create: (context) => EnterRoomProvider())
      ],
      builder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: "oleoScript"),
        routes: {
          "/": (context) => HomePage(),
          SplashScreen.id: (context) => SplashScreen(),
          HowToPlay.id: (context) => HowToPlay(),
          GameplayRoom.id: (context) => GameplayRoom(),
          CreateJoinRoom.id: (context) => CreateJoinRoom()
        },
        initialRoute: SplashScreen.id,
      ),
    );
  }
}
