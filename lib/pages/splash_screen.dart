

import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("SplashScren"),
        ),
        body: Center(
          child: ElevatedButton(onPressed: ()=>{
            Navigator.pushNamed(context, "/mainpage")
          },
              child: const Text("Get Started")
          ),
        ),
      ),
    );
  }
}
