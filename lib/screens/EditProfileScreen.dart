import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';
import '../utils/token_manager.dart';
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
  File? nuevaImagen;
  bool isUploadingImage = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nombreUsuarioController =
        TextEditingController(text: widget.usuario.nombreUsuario);
    descripcionController =
        TextEditingController(text: widget.usuario.descripcion);
    paisController = TextEditingController(text: widget.usuario.pais);
    ciudadController = TextEditingController(text: widget.usuario.ciudad);
  }

  @override
  void dispose() {
    nombreUsuarioController.dispose();
    descripcionController.dispose();
    paisController.dispose();
    ciudadController.dispose();
    super.dispose();
  }

  Future<void> seleccionarImagen() async {
    final XFile? imagen =
    await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        nuevaImagen = File(imagen.path);
      });
    }
  }

  Future<String?> subirImagen(File file) async {
    setState(() {
      isUploadingImage = true;
    });

    try {
      final response = await UsuarioService.uploadImage(file);

      if (response != null && response.url.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.mensaje)),
        );
        return response.url;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al subir imagen: respuesta vacía'),
            backgroundColor: Colors.red,
          ),
        );
        return null;
      }
    } catch (e) {
      print('Error al subir imagen: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al subir imagen: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } finally {
      setState(() {
        isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title:
        const Text('Editar Perfil', style: TextStyle(color: Colors.black)),
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
            // Avatar con indicador de carga
            Stack(
              children: [
                GestureDetector(
                  onTap: isUploadingImage ? null : seleccionarImagen,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[850],
                    backgroundImage: nuevaImagen != null
                        ? FileImage(nuevaImagen!)
                        : (widget.usuario.rutaImagen != null &&
                        widget.usuario.rutaImagen!.isNotEmpty
                        ? NetworkImage(widget.usuario.rutaImagen!)
                    as ImageProvider
                        : null),
                    child: (nuevaImagen == null &&
                        (widget.usuario.rutaImagen == null ||
                            widget.usuario.rutaImagen!.isEmpty))
                        ? const Icon(Icons.camera_alt,
                        color: Colors.grey, size: 36)
                        : null,
                  ),
                ),
                // Indicador de carga
                if (isUploadingImage)
                  Positioned.fill(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.black45,
                      child: const CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.yellow),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              isUploadingImage
                  ? 'Subiendo imagen...'
                  : 'Toca la foto para cambiar',
              style: TextStyle(
                color: isUploadingImage ? Colors.yellow[700] : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 30),

            // Nombre Usuario
            TextField(
              controller: nombreUsuarioController,
              enabled: !isUploadingImage,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nombre Usuario',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Descripción
            TextField(
              controller: descripcionController,
              enabled: !isUploadingImage,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Descripción',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // País
            TextField(
              controller: paisController,
              enabled: !isUploadingImage,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'País',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // Ciudad
            TextField(
              controller: ciudadController,
              enabled: !isUploadingImage,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Ciudad',
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Botón Guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isUploadingImage
                    ? null
                    : () async {
                  String rutaImagenActualizada =
                      widget.usuario.rutaImagen ?? '';

                  // Si hay imagen nueva, subirla a Supabase
                  if (nuevaImagen != null) {
                    final urlSubida = await subirImagen(nuevaImagen!);
                    if (urlSubida != null) {
                      rutaImagenActualizada = urlSubida;
                    } else {
                      // No continuar si falla el upload
                      return;
                    }
                  }

                  // Crear usuario actualizado
                  final usuarioActualizado = Usuario(
                    idUsuario: widget.usuario.idUsuario,
                    nombreUsuario: nombreUsuarioController.text,
                    descripcion: descripcionController.text,
                    pais: paisController.text,
                    ciudad: ciudadController.text,
                    rutaImagen: rutaImagenActualizada,
                    nombreCompleto: widget.usuario.nombreCompleto,
                  );

                  // Actualizar en base de datos
                  final ok = await UsuarioService
                      .updateUsuario(usuarioActualizado);

                  if (ok) {
                    // Guardar en token manager
                    await TokenManager.saveUserJson(
                        usuarioActualizado.toJson());

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Perfil actualizado exitosamente'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      Navigator.pop(context, usuarioActualizado);
                    }
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error al actualizar perfil'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  disabledBackgroundColor: Colors.grey[600],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save, color: Colors.black),
                label: Text(
                  isUploadingImage ? 'Subiendo...' : 'Guardar Cambios',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}