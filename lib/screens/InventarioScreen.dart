import 'package:flutter/material.dart';
import '../models/productos.dart';
import '../services/productos_service.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  List<Producto> productos = [];
  List<Producto> productosFiltrados = [];
  bool isLoading = true;
  int? categoriaSeleccionada;

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    setState(() {
      isLoading = true;
    });

    final productosObtenidos = await ProductoService.listarProductos();

    setState(() {
      productos = productosObtenidos;
      productosFiltrados = productosObtenidos;
      isLoading = false;
    });
  }

  void _filtrarProductos(String query) {
    setState(() {
      if (query.isEmpty) {
        _aplicarFiltros();
      } else {
        productosFiltrados = productos.where((producto) {
          final nombre = producto.nombre?.toLowerCase() ?? '';
          final codigo = producto.codigoPersonal?.toLowerCase() ?? '';
          final busqueda = query.toLowerCase();

          // Filtrar por búsqueda Y categoría
          bool coincideBusqueda = nombre.contains(busqueda) || codigo.contains(busqueda);
          bool coincideCategoria = categoriaSeleccionada == null ||
              producto.idCategoria == categoriaSeleccionada;

          return coincideBusqueda && coincideCategoria;
        }).toList();
      }
    });
  }

  void _filtrarPorCategoria(int? idCategoria) {
    setState(() {
      categoriaSeleccionada = idCategoria;
      _aplicarFiltros();
    });
  }

  void _aplicarFiltros() {
    if (categoriaSeleccionada == null) {
      productosFiltrados = productos;
    } else {
      productosFiltrados = productos.where((producto) {
        return producto.idCategoria == categoriaSeleccionada;
      }).toList();
    }
  }

  // ----Estados del Producto ----
  Color _getStockColor(int? stock) {
    if (stock == null) return Colors.grey;
    if (stock <= 5) return Colors.red;
    if (stock <= 15) return Colors.yellow[700]!;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        title: const Text(
          'Gestión de Inventario',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Barra de búsqueda
          Container(
            color: Colors.grey[850],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              onChanged: _filtrarProductos,
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),

          // Filtrar por categorías
          Container(
            color: Colors.grey[850],
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoriaChip('Todas', null),
                const SizedBox(width: 8),
                _buildCategoriaChip('Repuestos', 1),
                const SizedBox(width: 8),
                _buildCategoriaChip('Aceites', 2),
                const SizedBox(width: 8),
                _buildCategoriaChip('Filtros', 3),
                const SizedBox(width: 8),
                _buildCategoriaChip('Accesorios', 4),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Lista de productos con scroll
          Expanded(
            child: isLoading
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.yellow,
              ),
            )
                : productosFiltrados.isEmpty
                ? const Center(
              child: Text(
                'No hay productos registrados',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: productosFiltrados.length,
              itemBuilder: (context, index) {
                final producto = productosFiltrados[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildProductCard(producto),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriaChip(String label, int? idCategoria) {
    bool isSelected = categoriaSeleccionada == idCategoria;

    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (selected) {
        _filtrarPorCategoria(idCategoria);
      },
      backgroundColor: Colors.grey[800],
      selectedColor: Colors.yellow[700],
      checkmarkColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? Colors.yellow[700]! : Colors.grey[600]!,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildProductCard(Producto producto) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStockColor(producto.stock),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto (sin foto por ahora)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(
                Icons.inventory_2,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Información del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  producto.nombre ?? 'Sin nombre',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Código del producto',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                  ),
                ),
                Text(
                  producto.codigoPersonal ?? 'Sin código',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Costo:',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '\$${producto.costo?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PVP:',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '\$${producto.pvp?.toStringAsFixed(2) ?? '0.00'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Stock:',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            '${producto.stock ?? 0} unidades',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Fecha:',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            producto.fechaRegistro ?? 'Sin fecha',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}