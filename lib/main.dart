import 'package:flutter/material.dart';
import 'package:reelsclone/record.dart';
import 'splash.dart';
import 'vids.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/record': (context) => const RecordPage(),
        '/show': (context) => const Video(),
      },
    );
  }
}
