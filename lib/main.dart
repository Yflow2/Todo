
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restapi/pages/splash_screen.dart';
import 'package:restapi/pages/task_menu.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,DeviceOrientation.portraitDown
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/mainpage' :(context) => const TaskMenu(),
     },
    );
  }
}




