import 'package:flutter/material.dart';
import '../models/RegistroDetalleDTO.dart';
import '../services/registros_service.dart';

class HistorialMantenimientosPage extends StatefulWidget {
  const HistorialMantenimientosPage({super.key});

  @override
  State<HistorialMantenimientosPage> createState() =>
      _HistorialMantenimientosPageState();
}

class _HistorialMantenimientosPageState
    extends State<HistorialMantenimientosPage> {
  late Future<List<RegistroDetalleDTO>> futureHistorial;
  List<RegistroDetalleDTO> historialMantenimientos = [];
  bool cargando = true;

  // Variables para la búsqueda
  TextEditingController _searchController = TextEditingController();
  int _idClienteSeleccionado = 0;
  String _nombreClienteSeleccionado = '';
  bool _mostrarHistorial = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _cargarHistorial(int idCliente, String nombreCliente) {
    setState(() {
      cargando = true;
      _idClienteSeleccionado = idCliente;
      _nombreClienteSeleccionado = nombreCliente;
      _mostrarHistorial = true;
      futureHistorial = RegistrosService.obtenerHistorialMantenimientos(idCliente);
    });
  }

  void _limpiarBusqueda() {
    setState(() {
      _searchController.clear();
      _mostrarHistorial = false;
      _idClienteSeleccionado = 0;
      _nombreClienteSeleccionado = '';
      historialMantenimientos = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Historial de Mantenimientos",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: _mostrarHistorial
          ? _buildHistorialView()
          : _buildBuscarClienteView(),
    );
  }

  // =========== VISTA PARA BUSCAR CLIENTE ===========
  Widget _buildBuscarClienteView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Buscar Cliente',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ingresa el ID del cliente para ver su historial de mantenimientos',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),

          // Campo de búsqueda
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                labelText: "ID del Cliente",
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.person_search,
                  color: const Color(0xFFFFD700),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Botón para buscar
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final idText = _searchController.text.trim();

                if (idText.isEmpty) {
                  _mostrarError('Por favor ingresa un ID');
                  return;
                }

                final id = int.tryParse(idText);
                if (id == null || id <= 0) {
                  _mostrarError('El ID debe ser un número válido');
                  return;
                }

                // Cargar con nombre genérico (se obtendrá del backend)
                _cargarHistorial(id, 'Cliente #$id');
              },
              icon: const Icon(Icons.search, color: Colors.black),
              label: const Text(
                'Buscar Historial',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Info adicional
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFFFD700),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Busca por ID del Cliente',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Podrás ver todos los registros de mantenimiento asociados a ese cliente, incluyendo fecha, tipo de servicio, estado y vehículos.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========== VISTA DEL HISTORIAL ===========
  Widget _buildHistorialView() {
    return FutureBuilder<List<RegistroDetalleDTO>>(
      future: futureHistorial,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildCargando();
        } else if (snapshot.hasError) {
          return _buildError(snapshot.error.toString());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildSinDatos();
        }

        historialMantenimientos = snapshot.data!;
        return _buildListaHistorial();
      },
    );
  }

  Widget _buildCargando() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFFFFD700),
            strokeWidth: 3,
          ),
          const SizedBox(height: 20),
          const Text(
            'Cargando historial...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade300,
              size: 64,
            ),
            const SizedBox(height: 20),
            Text(
              'Error al cargar historial',
              style: TextStyle(
                color: Colors.red.shade300,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _limpiarBusqueda,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                  ),
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  label: const Text(
                    'Volver',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSinDatos() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              color: Colors.white54,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'Sin historial de mantenimientos',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No hay registros para el cliente #$_idClienteSeleccionado',
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _limpiarBusqueda,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
              ),
              icon: const Icon(Icons.search, color: Colors.black),
              label: const Text(
                'Buscar otro cliente',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaHistorial() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con información del cliente
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFFD700).withOpacity(0.2),
                  const Color(0xFFFFD700).withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFD700).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFFFD700),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cliente',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _nombreClienteSeleccionado,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: $_idClienteSeleccionado',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${historialMantenimientos.length} registros',
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Botón para buscar otro cliente
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _limpiarBusqueda,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color(0xFFFFD700),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              icon: const Icon(Icons.search, color: Color(0xFFFFD700)),
              label: const Text(
                'Buscar otro cliente',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Lista de mantenimientos
          Text(
            'Historial (Más reciente)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: historialMantenimientos.length,
            itemBuilder: (context, index) {
              final registro = historialMantenimientos[index];
              return _buildTarjetaMantenimiento(registro);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaMantenimiento(RegistroDetalleDTO registro) {
    final fecha = registro.fecha.isNotEmpty
        ? _formatearFecha(registro.fecha)
        : 'Fecha no disponible';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white12,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado: Fecha y tipo
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: const Color(0xFFFFD700),
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            fecha,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (registro.tipoMantenimiento != null &&
                          registro.tipoMantenimiento!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            registro.tipoMantenimiento!,
                            style: const TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                _buildIndicadorEstado(registro.estado),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 16),

            // Información del vehículo
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.two_wheeler,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vehículo',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${registro.marcaMoto ?? 'N/A'} ${registro.modeloMoto ?? ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Observaciones si existen
            if (registro.descripcion != null &&
                registro.descripcion!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white12,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Observaciones',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      registro.descripcion!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIndicadorEstado(int estado) {
    String textoEstado = 'Pendiente';
    Color colorEstado = Colors.orange;
    IconData iconoEstado = Icons.schedule;

    if (estado == 1) {
      textoEstado = 'Completado';
      colorEstado = Colors.green;
      iconoEstado = Icons.check_circle;
    } else if (estado == 0) {
      textoEstado = 'Pendiente';
      colorEstado = Colors.orange;
      iconoEstado = Icons.schedule;
    } else if (estado == 2) {
      textoEstado = 'Cancelado';
      colorEstado = Colors.red;
      iconoEstado = Icons.cancel;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: colorEstado.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorEstado.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconoEstado,
            color: colorEstado,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            textoEstado,
            style: TextStyle(
              color: colorEstado,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatearFecha(String fecha) {
    try {
      final dateTime = DateTime.parse(fecha);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return fecha;
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                mensaje,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}