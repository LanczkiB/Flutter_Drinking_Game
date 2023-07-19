import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'ui/screen/player_settings.dart';
import 'data/players_dao.dart';
import 'data/tasks_dao.dart';
import 'ui/screen/game.dart';
import 'ui/screen/welcome_page.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    name: 'Better Things',
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlayerDao(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskDao(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
            colorScheme: const ColorScheme(
          primary: Color.fromRGBO(204, 79, 101, 1),
          secondary: Color.fromRGBO(41, 213, 209, 1),
          surface: Colors.transparent,
          background: Color.fromRGBO(217, 163, 163, 1),
          error: Colors.transparent,
          onPrimary: Colors.transparent,
          onSecondary: Colors.transparent,
          onSurface: Colors.transparent,
          onBackground: Color.fromRGBO(217, 163, 163, 1),
          onError: Colors.transparent,
          brightness: Brightness.light,
        )),
        home: Welcome(),
        routes: {
          "/game": (context) => const Game(),
          "/starting": (context) => Welcome(),
          "/playersettings": (context) => const PlayerSettings()
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
