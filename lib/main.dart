import 'package:flutter/material.dart';
import 'screens/usuarios_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mantenimiento de Motos',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const UsuariosScreen(),
    );
  }
}
