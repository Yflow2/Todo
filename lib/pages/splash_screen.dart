import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/splash.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Align(
                alignment: Alignment.bottomCenter, // Aligns the button at the bottom
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60.0), // Adjust distance from the bottom
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/mainpage");
                    },
                    child: const Text("Let's get started",style: TextStyle(
                      color: Colors.black
                    ),),
                  ),
                ),
              ),
            ),
            const SafeArea(child: Padding(
              padding: EdgeInsets.all(30.0),
              child: Text("TODO IT",style: TextStyle(fontSize: 85,color: Colors.white,fontWeight: FontWeight.bold),),
            ))
          ],
        ),
      ),
    );
  }
}
