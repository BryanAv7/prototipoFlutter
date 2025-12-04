import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'RegisterScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Spacer(), // Espacio flexible arriba

                        // Icono moto
                        Center(
                          child: Icon(
                            Icons.motorcycle,
                            color: Colors.grey[400],
                            size: 100,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Texto Login
                        const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Campo correo
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Correo',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[850],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.yellow),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.yellow),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Campo contraseña
                        TextField(
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[850],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.yellow),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.yellow),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Olvidaste contraseña
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Botón Iniciar Sesión
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[700],
                              padding:
                              const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Iniciar Sesión',
                              style:
                              TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Botón Registrarse
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const RegisterScreen()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[700],
                              padding:
                              const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Registrarse',
                              style:
                              TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Texto O continúa con:
                        const Text(
                          'O continúa con:',
                          style: TextStyle(color: Colors.white),
                        ),

                        const SizedBox(height: 10),

                        // Botón Google
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/logoGoogle.png',
                              height: 24,
                              width: 24,
                            ),
                            label: const Text(
                              'Google',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(), // Espacio flexible abajo
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
