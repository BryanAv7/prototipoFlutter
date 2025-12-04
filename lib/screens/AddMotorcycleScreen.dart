import 'package:flutter/material.dart';

class AddMotorcycleScreen extends StatelessWidget {
  const AddMotorcycleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        title: const Text(
          'Añadir Vehículo',
          style: TextStyle(color: Colors.black),
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
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.yellow, width: 2),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_a_photo, color: Colors.grey, size: 36),
                      const SizedBox(height: 8),
                      const Text(
                        'Añadir foto',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              _buildFormField('Marca:', controller: TextEditingController()),
              const SizedBox(height: 15),

              _buildDropdownField(
                label: 'Modelo:',
                placeholder: 'Selecciona un modelo',
              ),
              const SizedBox(height: 15),

              _buildFormField('Placa:', controller: TextEditingController(), hint: 'Ej: ABC-123'),
              const SizedBox(height: 15),

              _buildFormField('Kilometraje:', controller: TextEditingController(), hint: 'Ej: 15000'),
              const SizedBox(height: 15),

              _buildDropdownField(
                label: 'Tipo:',
                placeholder: 'Selecciona tipo',
              ),
              const SizedBox(height: 15),

              _buildDropdownField(
                label: 'Año:',
                placeholder: 'Selecciona año',
              ),
              const SizedBox(height: 15),

              _buildFormField('Cilindraje:', controller: TextEditingController(), hint: 'Ej: 650 cc'),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add, color: Colors.black, size: 20),
                  label: const Text(
                    '+ Guardar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String label, {required TextEditingController controller, String? hint}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 5,
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
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
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({required String label, required String placeholder}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 5,
          child: DropdownButtonFormField<String>(
            value: null,
            hint: Text(placeholder, style: const TextStyle(color: Colors.grey)),
            onChanged: (String? value) {},
            decoration: InputDecoration(
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
            items: const [],
          ),
        ),
      ],
    );
  }
}