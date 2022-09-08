import 'package:flutter/material.dart';
import 'package:flutterdb/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Floor DB',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}


