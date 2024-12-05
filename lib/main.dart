import 'package:flutter/material.dart';
import 'package:main_project/HomeScreen.dart';
import 'package:main_project/TaskScreen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
   debugShowCheckedModeBanner: false,
   home: HomeScreen(),
    );
  }
}
