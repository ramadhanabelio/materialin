import 'package:flutter/material.dart';
import 'screens/user/login.dart';

void main() {
  runApp(const MaterialinApp());
}

class MaterialinApp extends StatelessWidget {
  const MaterialinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Materialin',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
