
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'mainsplachscreen.dart';

class newSplashScreen extends StatefulWidget {
  const newSplashScreen({Key? key}) : super(key: key);

  @override
  _newSplashScreenState createState() => _newSplashScreenState();
}

class _newSplashScreenState extends State<newSplashScreen> {
  @override
  Widget build(BuildContext context) {
    // Delaying navigation in the body using Future.delayed
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Splascmain()), // Replace with your desired screen
      );
    });

    return Scaffold(
      backgroundColor: Colors.blue, // You can change the background color
      body: Center(
        child: Text(
          'Welcome to Regel',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Customize text color
          ),
        ),
      ),
    );
  }
}