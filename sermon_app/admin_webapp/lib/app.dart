import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth/auth_provider.dart';
import 'auth/login_screen.dart';

class SermonAdminApp extends StatelessWidget {
  const SermonAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Dashboard - Admin',
        theme: ThemeData(
          primarySwatch: Colors.green,
          useMaterial3: true,
        ),
        home: const AdminLoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}