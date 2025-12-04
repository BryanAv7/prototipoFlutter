import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        title: const Text(
          'Editar Perfil',
            style: TextStyle(color: Colors.black)
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Foto de portada
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt, size: 36, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        'Añadir foto de portada',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Foto de perfil
              Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[850],
                    ),
                    child: Center(
                      child: Icon(Icons.camera_alt, size: 36, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Añadir foto de perfil',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Sección: Información Personal
              Text(
                'Información Personal',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              // Campo: Nombre Completo
              _buildTextField('Nombre Completo'),
              const SizedBox(height: 15),

              // Campo: Nombre Usuario
              _buildTextField('Nombre Usuario'),
              const SizedBox(height: 15),

              // Campo: Descripción
              _buildTextField('Descripción', maxLines: 3),
              const SizedBox(height: 15),

              // Campo: País
              _buildTextField('País'),
              const SizedBox(height: 15),

              // Campo: Ciudad
              _buildTextField('Ciudad'),
              const SizedBox(height: 30),

              // Botón Guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // guardar cambios
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil guardado')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Guardar',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.yellow),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.yellow),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.yellow, width: 2),
        ),
      ),
    );
  }
}