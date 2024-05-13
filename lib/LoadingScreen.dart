import 'dart:async'; // Import the async library
import 'package:attendance_app/loginscreen.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    // Delay the navigation to another screen by 3 seconds
    Timer(const Duration(seconds: 3), () {
      // Push a new screen onto the navigation stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const Loginscreen(), // Replace 'YourNextScreen' with your actual screen
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              strokeWidth: 4.0,
            ),
            SizedBox(height: 16.0),
            Text(
              'Loading...',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
