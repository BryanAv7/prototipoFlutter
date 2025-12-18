import 'dart:io';
import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/moto.dart';
import '../services/moto_service.dart';
import 'package:image_picker/image_picker.dart';

class ViewMotorcycleScreen extends StatefulWidget {
  final Usuario usuario;
  final Moto moto;

  const ViewMotorcycleScreen({super.key, required this.usuario, required this.moto});

  @override
  State<ViewMotorcycleScreen> createState() => _ViewMotorcycleScreenState();
}

class _ViewMotorcycleScreenState extends State<ViewMotorcycleScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController marcaController;
  late TextEditingController modeloController;
  late TextEditingController placaController;
  late TextEditingController anioController;
  late TextEditingController kilometrajeController;
  late TextEditingController cilindrajeController;

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    marcaController = TextEditingController(text: widget.moto.marca ?? '');
    modeloController = TextEditingController(text: widget.moto.modelo ?? '');
    placaController = TextEditingController(text: widget.moto.placa ?? '');
    anioController = TextEditingController(text: widget.moto.anio?.toString() ?? '');
    kilometrajeController = TextEditingController(text: widget.moto.kilometraje?.toString() ?? '');
    cilindrajeController = TextEditingController(text: widget.moto.cilindraje?.toString() ?? '');
  }

  @override
  void dispose() {
    marcaController.dispose();
    modeloController.dispose();
    placaController.dispose();
    anioController.dispose();
    kilometrajeController.dispose();
    cilindrajeController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> updateMoto() async {
    if (!_formKey.currentState!.validate()) return;

    String? uploadedUrl = widget.moto.ruta_imagenMotos;

    // Si seleccionó una nueva imagen, subirla
    if (selectedImage != null) {
      final url = await MotoService.uploadMotoImage(selectedImage!);
      if (url != null) uploadedUrl = url;
    }

    // Actualizar campos de la moto
    final updatedMoto = Moto(
      id_moto: widget.moto.id_moto,
      placa: placaController.text,
      anio: int.tryParse(anioController.text),
      marca: marcaController.text,
      modelo: modeloController.text,
      tipoMoto: widget.moto.tipoMoto,
      kilometraje: int.tryParse(kilometrajeController.text),
      cilindraje: int.tryParse(cilindrajeController.text),
      id_usuario: widget.usuario.idUsuario,
      ruta_imagenMotos: uploadedUrl,
    );

    final result = await MotoService.actualizarMotoAndGet(updatedMoto);

    if (result != null) {
      Navigator.pop(context, true); // volver y recargar la lista
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar la moto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: const Text('Editar Motocicleta', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- Imagen de la moto centrada ---
              Center(
                child: GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[850],
                    backgroundImage: selectedImage != null
                        ? FileImage(selectedImage!)
                        : (widget.moto.ruta_imagenMotos != null && widget.moto.ruta_imagenMotos!.isNotEmpty)
                        ? NetworkImage(widget.moto.ruta_imagenMotos!) as ImageProvider
                        : null,
                    child: (selectedImage == null &&
                        (widget.moto.ruta_imagenMotos == null || widget.moto.ruta_imagenMotos!.isEmpty))
                        ? const Icon(Icons.camera_alt, color: Colors.grey, size: 36)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text('Toca la imagen para cambiar', style: TextStyle(color: Colors.grey)),

              const SizedBox(height: 20),

              _buildTextField('Marca', controller: marcaController),
              const SizedBox(height: 15),
              _buildTextField('Modelo', controller: modeloController),
              const SizedBox(height: 15),
              _buildTextField('Placa', controller: placaController, enabled: true), // habilitada
              const SizedBox(height: 15),
              _buildTextField('Kilometraje', controller: kilometrajeController, keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              _buildTextField('Año', controller: anioController, keyboardType: TextInputType.number),
              const SizedBox(height: 15),
              _buildTextField('Cilindraje', controller: cilindrajeController, keyboardType: TextInputType.number),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: updateMoto,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.motorcycle, color: Colors.black, size: 20),
                  label: const Text(
                    'Actualizar Motocicleta',
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

  Widget _buildTextField(String label,
      {required TextEditingController controller,
        TextInputType keyboardType = TextInputType.text,
        bool enabled = true}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      style: const TextStyle(color: Colors.white),
      validator: (value) {
        if (!enabled) return null; // si está bloqueado, no validar
        if (value == null || value.isEmpty) return 'Este campo es obligatorio';
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
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
