import 'package:flutter/material.dart';
import 'package:vote_online/pages/home.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'home',
      routes:{
        'home': (_)=> HomePage()
      }
    );
  }
}