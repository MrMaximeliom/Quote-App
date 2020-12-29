import 'package:flutter/material.dart';
import 'package:beautiful/ui/pages/loading.dart';
import 'package:beautiful/ui/pages/home.dart';
import 'package:beautiful/ui/pages/liked.dart';

void main() => runApp(MaterialApp(
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.red,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.red,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Loading(),
        '/home': (context) => Home(),
        '/liked': (context) => LikedQuotes(),
      },
    ));
