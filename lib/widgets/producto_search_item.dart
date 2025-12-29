import 'package:flutter/material.dart';
import '../models/productos.dart';
import '../config/api.dart';

class ProductoSearchItem extends StatelessWidget {
  final Producto producto;
  final VoidCallback onAdd;

  const ProductoSearchItem({
    super.key,
    required this.producto,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2B2B2B),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildImagen(),
        title: Text(
          producto.nombre ?? 'Sin nombre',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stock: ${producto.stock ?? 0}',
              style: TextStyle(
                color: (producto.stock ?? 0) > 0 ? Colors.green : Colors.red,
              ),
            ),
            Text(
              '\$${producto.pvp?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.yellow, size: 32),
          onPressed: (producto.stock ?? 0) > 0 ? onAdd : null,
        ),
      ),
    );
  }

  Widget _buildImagen() {
    if (producto.rutaImagenProductos != null &&
        producto.rutaImagenProductos!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          '${ApiConfig.baseUrl}${producto.rutaImagenProductos}',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildIconoDefault(),
        ),
      );
    }
    return _buildIconoDefault();
  }

  Widget _buildIconoDefault() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.yellow.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.inventory_2, color: Colors.yellow),
    );
  }
}