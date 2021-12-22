import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weight_tracker/providers/user_provider.dart';
import 'package:weight_tracker/providers/weight_provider.dart';
import 'package:weight_tracker/view/home.dart';
import 'package:weight_tracker/view/login.dart';
void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>UserProvider()),
      ChangeNotifierProvider(create: (_)=>WeightProvider())
    ], 
    child: Main()
  ));
}

class Main extends StatelessWidget {
const Main({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    routes: {
      '/': (context) => Login(),
      '/homepage': (context) => Home(),
    },
  );
  }
}