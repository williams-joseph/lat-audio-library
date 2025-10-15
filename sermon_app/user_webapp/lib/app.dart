import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

class SermonUserApp extends StatelessWidget {
  const SermonUserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sermon Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SplashScreen(), 
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Scaffold(
          body: SafeArea(
            child: child!,
          ),
        );
      },
    );
  }
}