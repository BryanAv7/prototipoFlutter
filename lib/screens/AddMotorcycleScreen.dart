import 'package:flutter/material.dart';
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

  Future<void> _saveMoto() async {
    // Validación mínima
    if (marcaController.text.isEmpty ||
        modeloController.text.isEmpty ||
        placaController.text.isEmpty ||
        selectedTipoMoto == null ||
        anioController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa los campos obligatorios.')),
      );
      return;
    }

    int? anio, kilometraje, cilindraje;

    try {
      anio = int.parse(anioController.text.trim());
      kilometraje = int.parse(kilometrajeController.text.trim());
      cilindraje = int.parse(RegExp(r'\d+').stringMatch(cilindrajeController.text.trim()) ?? '');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Año, kilometraje y cilindraje deben ser números válidos.')),
      );
      return;
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
      ruta_imagenMotos: '', // Vacio
    );

    bool success = await MotoService.crearMoto(moto);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Moto registrada con éxito')),
      );
      Navigator.pop(context, moto);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Error al registrar la moto.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Añadir Vehículo', style: TextStyle(color: Colors.black)),
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
            // --- Campos ---
            _buildTextField('Marca', controller: marcaController),
            const SizedBox(height: 15),

            _buildTextField('Modelo', controller: modeloController),
            const SizedBox(height: 15),

            _buildTextField('Placa', controller: placaController, hint: 'Ej: ABC-123'),
            const SizedBox(height: 15),

            _buildTextField('Kilometraje', controller: kilometrajeController, hint: 'Ej: 15000', keyboardType: TextInputType.number),
            const SizedBox(height: 15),

            // --- Tipo de Moto ---
            _buildDropdownField(
              label: 'Tipo',
              value: selectedTipoMoto,
              onChanged: (value) => setState(() => selectedTipoMoto = value),
              items: tiposMoto,
            ),
            const SizedBox(height: 15),

            _buildTextField('Año', controller: anioController, hint: 'Ej: 2022', keyboardType: TextInputType.number),
            const SizedBox(height: 15),

            _buildTextField('Cilindraje', controller: cilindrajeController, hint: 'Ej: 650'),
            const SizedBox(height: 30),

            // --- Botón Guardar ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveMoto,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Guardar', style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, {
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text('Selecciona tipo', style: TextStyle(color: Colors.grey)),
          isExpanded: true,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          dropdownColor: Colors.grey[850],
          items: items.map((tipo) {
            return DropdownMenuItem(
              value: tipo,
              child: Text(tipo),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}