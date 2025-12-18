import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/moto.dart';
import '../models/usuario.dart';
import '../services/moto_service.dart';

class AddMotorcycleScreen extends StatefulWidget {
  final Usuario usuario;

  const AddMotorcycleScreen({super.key, required this.usuario});

  @override
  State<AddMotorcycleScreen> createState() => _AddMotorcycleScreenState();
}

class _AddMotorcycleScreenState extends State<AddMotorcycleScreen> {
  late TextEditingController marcaController;
  late TextEditingController modeloController;
  late TextEditingController placaController;
  late TextEditingController kilometrajeController;
  late TextEditingController cilindrajeController;
  late TextEditingController anioController;

  String? selectedTipoMoto;
  final List<String> tiposMoto = [
    'Scooters',
    'Naked',
    'Deportiva',
    'Scrambler',
    'Utilitarios',
    'Otro'
  ];

  File? nuevaImagen;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    marcaController = TextEditingController();
    modeloController = TextEditingController();
    placaController = TextEditingController();
    kilometrajeController = TextEditingController();
    cilindrajeController = TextEditingController();
    anioController = TextEditingController();
  }

  @override
  void dispose() {
    marcaController.dispose();
    modeloController.dispose();
    placaController.dispose();
    kilometrajeController.dispose();
    cilindrajeController.dispose();
    anioController.dispose();
    super.dispose();
  }

  // Seleccionar imagen principal de la moto
  Future<void> seleccionarImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() => nuevaImagen = File(imagen.path));
    }
  }

  // 📷 Cámara para placa (SIN lógica todavía)
  Future<void> abrirCamaraPlaca() async {
    await _picker.pickImage(source: ImageSource.camera);
  }

  Future<void> _saveMoto() async {
    if (marcaController.text.isEmpty ||
        modeloController.text.isEmpty ||
        placaController.text.isEmpty ||
        selectedTipoMoto == null ||
        anioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Por favor, completa los campos obligatorios.')),
      );
      return;
    }

    int? anio, kilometraje, cilindraje;
    try {
      anio = int.parse(anioController.text.trim());
      kilometraje = int.parse(kilometrajeController.text.trim());
      cilindraje = int.parse(
        RegExp(r'\d+')
            .stringMatch(cilindrajeController.text.trim()) ??
            '',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
            Text('Año, kilometraje y cilindraje deben ser números válidos.')),
      );
      return;
    }

    String rutaImagen = '';
    if (nuevaImagen != null) {
      final uploadedImage =
      await MotoService.uploadMotoImage(nuevaImagen!);
      if (uploadedImage != null) {
        rutaImagen = uploadedImage;
      }
    }

    final moto = Moto(
      id_moto: null,
      placa: placaController.text.trim(),
      anio: anio,
      marca: marcaController.text.trim(),
      modelo: modeloController.text.trim(),
      tipoMoto: selectedTipoMoto!,
      kilometraje: kilometraje,
      cilindraje: cilindraje,
      id_usuario: widget.usuario.idUsuario!,
      ruta_imagenMotos: rutaImagen,
    );

    bool success = await MotoService.crearMoto(moto);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Moto registrada con éxito')),
      );
      Navigator.pop(context, moto);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al registrar la moto.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title:
        const Text('Añadir Vehículo', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.yellow[700],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la moto
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: seleccionarImagen,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[850],
                      backgroundImage:
                      nuevaImagen != null ? FileImage(nuevaImagen!) : null,
                      child: nuevaImagen == null
                          ? const Icon(Icons.camera_alt,
                          color: Colors.grey, size: 36)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text('Toca la imagen para seleccionar',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildTextField('Marca', controller: marcaController),
            const SizedBox(height: 15),
            _buildTextField('Modelo', controller: modeloController),
            const SizedBox(height: 15),

            // Campo placa + Foto detección
            TextField(
              controller: placaController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Placa',
                labelStyle: const TextStyle(color: Colors.grey),
                hintText: 'Ej: ABC-123',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[850],
                suffixIcon: IconButton(
                  icon:
                  const Icon(Icons.camera_alt, color: Colors.yellow),
                  onPressed: abrirCamaraPlaca,
                  tooltip: 'Tomar foto de la placa',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.yellow),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.yellow),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                  const BorderSide(color: Colors.yellow, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 15),
            _buildTextField('Kilometraje',
                controller: kilometrajeController,
                hint: 'Ej: 15000',
                keyboardType: TextInputType.number),
            const SizedBox(height: 15),

            _buildDropdownField(
              label: 'Tipo',
              value: selectedTipoMoto,
              onChanged: (value) =>
                  setState(() => selectedTipoMoto = value),
              items: tiposMoto,
            ),

            const SizedBox(height: 15),
            _buildTextField('Año',
                controller: anioController,
                hint: 'Ej: 2022',
                keyboardType: TextInputType.number),
            const SizedBox(height: 15),
            _buildTextField('Cilindraje',
                controller: cilindrajeController, hint: 'Ej: 650'),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveMoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Guardar',
                    style:
                    TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, {
        required TextEditingController controller,
        String? hint,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.yellow),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.yellow),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
          const BorderSide(color: Colors.yellow, width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required ValueChanged<String?> onChanged,
    required List<String> items,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.yellow),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.yellow),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
          const BorderSide(color: Colors.yellow, width: 2),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text('Selecciona tipo',
              style: TextStyle(color: Colors.grey)),
          isExpanded: true,
          style:
          const TextStyle(color: Colors.white, fontSize: 16),
          dropdownColor: Colors.grey[850],
          items: items
              .map((tipo) =>
              DropdownMenuItem(value: tipo, child: Text(tipo)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
