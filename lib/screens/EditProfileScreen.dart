import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final Usuario usuario;

  const EditProfileScreen({super.key, required this.usuario});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nombreUsuarioController;
  late TextEditingController descripcionController;
  late TextEditingController paisController;
  late TextEditingController ciudadController;
  File? nuevaImagen; // Archivo temporal de la imagen seleccionada

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nombreUsuarioController = TextEditingController(text: widget.usuario.nombreUsuario);
    descripcionController = TextEditingController(text: widget.usuario.descripcion);
    paisController = TextEditingController(text: widget.usuario.pais);
    ciudadController = TextEditingController(text: widget.usuario.ciudad);
  }

  Future<void> seleccionarImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        nuevaImagen = File(imagen.path);
      });
    }
  }

  Future<String?> subirImagen(File file) async {
    try {
      // Llamada al servicio que sube la imagen al backend
      String url = await UsuarioService.uploadImage(file);
      return url;
    } catch (e) {
      print("Error al subir imagen: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Editar Perfil', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- Foto de perfil ---
            GestureDetector(
              onTap: seleccionarImagen,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[850],
                backgroundImage: nuevaImagen != null
                    ? FileImage(nuevaImagen!)
                    : (widget.usuario.rutaImagen != null &&
                    widget.usuario.rutaImagen!.isNotEmpty
                    ? NetworkImage(widget.usuario.rutaImagen!) as ImageProvider
                    : null),
                child: (nuevaImagen == null &&
                    (widget.usuario.rutaImagen == null ||
                        widget.usuario.rutaImagen!.isEmpty))
                    ? const Icon(Icons.camera_alt, color: Colors.grey, size: 36)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Toca la foto para cambiar',
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 30),

            // --- Campos de información ---
            TextField(
              controller: nombreUsuarioController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nombre Usuario',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: descripcionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: paisController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'País',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: ciudadController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Ciudad',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
              ),
            ),
            const SizedBox(height: 30),

            // --- Botón guardar ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  String rutaImagenActualizada = widget.usuario.rutaImagen ?? '';
                  if (nuevaImagen != null) {
                    final urlSubida = await subirImagen(nuevaImagen!);
                    if (urlSubida != null) {
                      rutaImagenActualizada = urlSubida;
                    }
                  }

                  final usuarioActualizado = Usuario(
                    idUsuario: widget.usuario.idUsuario,
                    nombreUsuario: nombreUsuarioController.text,
                    descripcion: descripcionController.text,
                    pais: paisController.text,
                    ciudad: ciudadController.text,
                    rutaImagen: rutaImagenActualizada,
                    nombreCompleto: widget.usuario.nombreCompleto,
                  );

                  bool ok = await UsuarioService.updateUsuario(usuarioActualizado);
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil actualizado')),
                    );
                    Navigator.pop(context, usuarioActualizado);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error al actualizar')),
                    );
                  }
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
    );
  }
}
