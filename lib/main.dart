import 'package:drawing_app/features/draw/models/custom_offset.dart';
import 'package:drawing_app/features/draw/models/stroke.dart';
import 'package:drawing_app/features/draw/presentation/draw_screen.dart';
import 'package:drawing_app/features/home/presentation/home_screen.dart';
import 'package:drawing_app/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // register adapters
  Hive.registerAdapter(CustomOffsetAdapter());
  Hive.registerAdapter(StrokeAdapter());

  await Hive.openBox<Map<dynamic, dynamic>>('drawings');
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
