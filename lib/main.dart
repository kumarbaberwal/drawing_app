import 'package:drawing_app/features/draw/presentation/draw_screen.dart';
import 'package:drawing_app/features/home/presentation/home_screen.dart';
import 'package:drawing_app/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: false,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => HomeScreen(),
        '/draw': (context) => DrawScreen(),
      },
    );
  }
}
