import 'package:flutter/material.dart';
import '../models/detalle_ui.dart';
import '../config/api.dart';

class DetalleItemCard extends StatelessWidget {
  final DetalleUI detalle;
  final VoidCallback onDelete;
  final ValueChanged<int> onCantidadChanged;

  const DetalleItemCard({
    super.key,
    required this.detalle,
    required this.onDelete,
    required this.onCantidadChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2B2B2B),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.yellow, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                // Imagen o ícono
                _buildImagen(),
                const SizedBox(width: 12),

                // Info del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        detalle.nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        detalle.esProducto ? 'Producto' : 'Concepto manual',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Controles de cantidad
                Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline,
                              color: Colors.red, size: 24),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            if (detalle.cantidad > 1) {
                              onCantidadChanged(detalle.cantidad - 1);
                            }
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '${detalle.cantidad}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.green, size: 24),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            onCantidadChanged(detalle.cantidad + 1);
                          },
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: Colors.red, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 8),

            // Fila de precios (ahora abajo)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Precio: \$${detalle.precioUnitario.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontSize: 13,
                  ),
                ),
                Text(
                  'Subtotal: \$${detalle.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagen() {
    final ruta = detalle.imagenUrl;

    if (detalle.esProducto && ruta != null && ruta.isNotEmpty) {
      final imageUrl = ruta.startsWith('http')
          ? ruta
          : '${ApiConfig.baseUrl}$ruta';

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildIconoDefault(),
        ),
      );
    }

    return _buildIconoDefault();
  }

  Widget _buildIconoDefault() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        detalle.esProducto ? Icons.inventory_2 : Icons.build,
        color: Colors.yellow,
        size: 30,
      ),
    );
  }
}