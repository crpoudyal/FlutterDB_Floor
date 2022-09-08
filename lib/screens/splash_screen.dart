import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterdb/screens/HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds : 4), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children:const <Widget> [
          Text("This is splash screen"),
        ],
      ),
    );
  }
}
