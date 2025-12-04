import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                        // Botón atrás
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Icono moto
                        Center(
                          child: Icon(Icons.motorcycle, color: Colors.grey[400], size: 100),
                        ),

                        const SizedBox(height: 10),

                        // Título
                        const Center(
                          child: Text(
                            'Registro de Usuario',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Contenido scrollable
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Campos
                                _buildTextField('Nombre Completo'),
                                const SizedBox(height: 15),
                                _buildTextField('Nombre Usuario'),
                                const SizedBox(height: 15),
                                _buildTextField(
                                  'Correo Electrónico',
                                  suffixIcon: const Icon(Icons.check_circle, color: Colors.green),
                                ),
                                const SizedBox(height: 15),
                                _buildTextField('Contraseña', obscureText: true),

                                const SizedBox(height: 25),

                                // Botón Registrar
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow[700],
                                      padding: const EdgeInsets.symmetric(vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text(
                                      'REGISTRARSE',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 15),

                                // Texto: ¿Ya tienes una cuenta? Iniciar Sesión
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '¿Ya tienes una cuenta? ',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text(
                                        'Iniciar Sesión',
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
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

  // Función para crear TextFields
  Widget _buildTextField(String hintText, {bool obscureText = false, Widget? suffixIcon}) {
    return TextField(
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[850],
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.yellow),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.yellow),
        ),
      ),
    );
  }
}
