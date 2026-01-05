import 'package:flutter/material.dart';
import '../models/productos.dart';
import '../config/api.dart';

class ProductoSearchItem extends StatefulWidget {
  final Producto producto;
  final VoidCallback onAdd;

  const ProductoSearchItem({
    super.key,
    required this.producto,
    required this.onAdd,
  });

  @override
  State<ProductoSearchItem> createState() => _ProductoSearchItemState();
}

class _ProductoSearchItemState extends State<ProductoSearchItem> {
  String _baseUrl = '';
  bool _loadingUrl = true;

  @override
  void initState() {
    super.initState();
    _loadBaseUrl();
  }

  Future<void> _loadBaseUrl() async {
    final baseUrl = await ApiConfig.getBaseUrl();
    setState(() {
      _baseUrl = baseUrl;
      _loadingUrl = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF2B2B2B),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: _buildImagen(),
        title: Text(
          widget.producto.nombre ?? 'Sin nombre',
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stock: ${widget.producto.stock ?? 0}',
              style: TextStyle(
                color: (widget.producto.stock ?? 0) > 0 ? Colors.green : Colors.red,
              ),
            ),
            Text(
              '\$${widget.producto.pvp?.toStringAsFixed(2) ?? '0.00'}',
              style: const TextStyle(
                color: Colors.yellow,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle, color: Colors.yellow, size: 32),
          onPressed: (widget.producto.stock ?? 0) > 0 ? widget.onAdd : null,
        ),
      ),
    );
  }

  Widget _buildImagen() {
    final ruta = widget.producto.rutaImagenProductos;

    if (_loadingUrl) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.yellow.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
            ),
          ),
        ),
      );
    }

    if (ruta != null && ruta.isNotEmpty) {
      final imageUrl = ruta.startsWith('http')
          ? ruta
          : '$_baseUrl$ruta';

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
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