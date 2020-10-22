import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vote_online/pages/home.dart';
import 'package:vote_online/pages/status.dart';
import 'package:vote_online/services/socket_service.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) =>SocketService(),)
      ],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: 'home',
        routes:{
          'home': (_)=> HomePage(),
          'status': (_)=>  StatusPage()
        }
      ),
    );
  }
}