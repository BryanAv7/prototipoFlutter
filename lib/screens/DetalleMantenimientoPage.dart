import 'package:flutter/material.dart';
import '../models/RegistroDetalleDTO.dart';
import '../services/registros_service.dart';

class DetalleMantenimientoPage extends StatefulWidget {
  final int idRegistro;

  const DetalleMantenimientoPage({
    super.key,
    required this.idRegistro,
  });

  @override
  State<DetalleMantenimientoPage> createState() =>
      _DetalleMantenimientoPageState();
}

class _DetalleMantenimientoPageState extends State<DetalleMantenimientoPage> {
  late Future<RegistroDetalleDTO> futureDetalle;

  @override
  void initState() {
    super.initState();
    futureDetalle = RegistrosService.obtenerDetalle(widget.idRegistro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        title: const Text(
          "Detalle del Mantenimiento",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<RegistroDetalleDTO>(
        future: futureDetalle,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final d = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              // ================= CLIENTE + ESTADO =================
              _card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d.nombreCliente ?? 'Cliente no registrado',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("Fecha: ${d.fecha}", style: _text()),
                      ],
                    ),
                    _estadoChip(d.estado),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ================= MOTO =================
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Moto"),
                    const SizedBox(height: 6),
                    Text(
                      "${d.marcaMoto ?? 'Marca desconocida'} ${d.modeloMoto ?? ''}",
                      style: _text(),
                    ),

                    if ((d.rutaImagenMoto ?? '').isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            d.rutaImagenMoto!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Text(
                              "Imagen no disponible",
                              style: TextStyle(color: Colors.white54),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ================= MANTENIMIENTO =================
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Mantenimiento"),
                    const SizedBox(height: 6),
                    Text(
                      d.descripcion ?? 'Sin descripción',
                      style: _text(),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Tipo: ${d.tipoMantenimiento ?? 'No definido'}",
                      style: _text(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ================= COSTO TOTAL =================
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionTitle("Costo Total"),
                    const SizedBox(height: 6),
                    Text(
                      d.costoTotal != null
                          ? '\$${d.costoTotal!.toStringAsFixed(2)}'
                          : 'No disponible',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ==================== HELPERS ====================

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2B),
        borderRadius: BorderRadius.circular(14),
      ),
      child: child,
    );
  }

  Widget _estadoChip(int estado) {
    final bool enProceso = estado == 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: enProceso ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        enProceso ? "En proceso" : "Finalizado",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  TextStyle _text() =>
      const TextStyle(color: Colors.white70, fontSize: 14);

  Widget _sectionTitle(String text) => Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  );
}