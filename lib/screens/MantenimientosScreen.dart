import 'package:flutter/material.dart';
import '../models/registro_dto.dart';
import '../services/registros_service.dart';
import 'AgregarMantenimientoPage.dart';
import 'DetalleMantenimientoPage.dart';

class MantenimientosPage extends StatefulWidget {
  const MantenimientosPage({super.key});

  @override
  State<MantenimientosPage> createState() => _MantenimientosPageState();
}

class _MantenimientosPageState extends State<MantenimientosPage> {
  late Future<List<RegistroDTO>> registrosFuture;

  @override
  void initState() {
    super.initState();
    registrosFuture = RegistrosService.listarRegistros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        automaticallyImplyLeading: false,
        title: const Text(
          "Mantenimientos",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // BOTONES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton("Listar", () {
                  setState(() {
                    registrosFuture = RegistrosService.listarRegistros();
                  });
                }),
                _actionButton("+ Agregar", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AgregarMantenimientoPage(),
                    ),
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),

            // LISTA
            Expanded(
              child: FutureBuilder<List<RegistroDTO>>(
                future: registrosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final registros = snapshot.data!;

                  if (registros.isEmpty) {
                    return const Center(
                      child: Text(
                        "No hay mantenimientos",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      return _buildCard(context, registros[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------
  Widget _actionButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFD700),
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }

  // --------------------------------------------------
  Widget _buildCard(BuildContext context, RegistroDTO registro) {
    final bool enProceso = registro.estado == 1;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleMantenimientoPage(
              idRegistro: registro.idRegistro,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2B2B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // IMAGEN
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                registro.rutaImagenMoto,
                width: 120,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.motorcycle,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 10),

            // INFO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${registro.nombreCliente}, ${registro.marcaMoto} - ${registro.modeloMoto}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "Fecha: ${registro.fecha}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),

                  Text(
                    registro.descripcion,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: enProceso ? Colors.green : Colors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        enProceso ? "En Proceso" : "Finalizado",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
