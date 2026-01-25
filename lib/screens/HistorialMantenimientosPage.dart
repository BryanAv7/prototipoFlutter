import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/RegistroDetalleDTO.dart';
import '../models/DetalleFacturaDTO.dart';
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

  // ✅ Variable para OCR
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _cargarHistorial(String nombreCliente) {
    setState(() {
      cargando = true;
      _nombreClienteSeleccionado = nombreCliente;
      _mostrarHistorial = true;
      futureHistorial = RegistrosService.buscarHistorialPorNombre(nombreCliente);
    });
  }

  void _limpiarBusqueda() {
    setState(() {
      _searchController.clear();
      _mostrarHistorial = false;
      _nombreClienteSeleccionado = '';
      historialMantenimientos = [];
    });
  }

  // ✅ NUEVO - Modal para seleccionar fuente de imagen
  void _buscarPorPlacaOCR() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Escanear Placa',
                  style: TextStyle(
                    color: Colors.yellow[700],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.yellow),
                title: const Text('Tomar foto',
                    style: TextStyle(color: Colors.white)),
                subtitle: const Text('Usa la cámara para escanear la placa',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  _procesarImagenPlacaOCR(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.yellow),
                title: const Text('Elegir de galería',
                    style: TextStyle(color: Colors.white)),
                subtitle: const Text('Selecciona una foto existente',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                onTap: () {
                  Navigator.pop(context);
                  _procesarImagenPlacaOCR(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.close, color: Colors.red),
                title: const Text('Cancelar',
                    style: TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Procesar imagen con OCR
  Future<void> _procesarImagenPlacaOCR(ImageSource source) async {
    final XFile? imagen = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (imagen == null) return;

    final imageBytes = await imagen.readAsBytes();

    // Loader con mensaje
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFFFFD700)),
              const SizedBox(height: 16),
              const Text(
                'Escaneando placa...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Obtener el historial por placa
      final historial =
      await RegistrosService.buscarHistorialPorPlacaOCR(imageBytes);

      // Extraer el nombre del cliente del primer registro si existe
      String nombreCliente = 'Búsqueda por Placa (OCR)';
      if (historial.isNotEmpty && historial.first.nombreCliente != null) {
        nombreCliente = historial.first.nombreCliente!;
      }

      setState(() {
        cargando = true;
        _nombreClienteSeleccionado = nombreCliente;
        _mostrarHistorial = true;
        futureHistorial = Future.value(historial);
      });

      Navigator.pop(context); // cerrar loader
    } catch (e) {
      Navigator.pop(context); // cerrar loader
      _mostrarError('Error al procesar la imagen: $e');
    }
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
            fontWeight: FontWeight.normal,
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
            'Ingrese el nombre del cliente o tome/seleccione una foto de la placa para ver su Historial de Mantenimientos.',
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
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                labelText: "Nombre del Cliente",
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

          // Botones
          Row(
            children: [
              // Botón para buscar por nombre
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    final nombreText = _searchController.text.trim();

                    if (nombreText.isEmpty) {
                      _mostrarError('Por favor ingresa un nombre');
                      return;
                    }

                    if (nombreText.length < 2) {
                      _mostrarError('El nombre debe tener al menos 2 caracteres');
                      return;
                    }

                    _cargarHistorial(nombreText);
                  },
                  icon: const Icon(Icons.search, color: Colors.black),
                  label: const Text(
                    'Buscar',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Botón para escanear placa con OCR
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _buscarPorPlacaOCR,
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text(
                    'Placa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
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
              'No hay registros para el cliente #$_nombreClienteSeleccionado',
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
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          iconColor: const Color(0xFFFFD700),
          collapsedIconColor: const Color(0xFFFFD700),
          backgroundColor: const Color(0xFF1E1E1E),
          collapsedBackgroundColor: const Color(0xFF1E1E1E),
          title: Row(
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
                        Expanded(
                          child: Text(
                            'Date: $fecha',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (registro.tipoMantenimiento != null &&
                        registro.tipoMantenimiento!.isNotEmpty)
                      Text(
                        'Tipo: ${registro.tipoMantenimiento}',
                        style: const TextStyle(
                          color: Color(0xFFFFD700),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _buildIndicadorEstado(registro.estado),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.white12, height: 1),
                  const SizedBox(height: 16),

                  // ========== CLIENTE ==========
                  if (registro.nombreCliente != null &&
                      registro.nombreCliente!.isNotEmpty) ...[
                    _buildInfoField(
                      icon: Icons.person,
                      label: 'Cliente',
                      value: registro.nombreCliente!,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ========== ENCARGADO ==========
                  if (registro.nombreEncargado != null &&
                      registro.nombreEncargado!.isNotEmpty) ...[
                    _buildInfoField(
                      icon: Icons.supervisor_account,
                      label: 'Encargado',
                      value: registro.nombreEncargado!,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ========== VEHÍCULO ==========
                  _buildInfoField(
                    icon: Icons.two_wheeler,
                    label: 'Vehículo',
                    value: '${registro.marcaMoto ?? 'N/A'} ${registro.modeloMoto ?? ''}',
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),

                  // ========== PLACA ==========
                  if (registro.placaMoto != null && registro.placaMoto!.isNotEmpty) ...[
                    _buildInfoField(
                      icon: Icons.badge,
                      label: 'Placa',
                      value: registro.placaMoto!,
                      color: Colors.cyan,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // ========== COSTO TOTAL ==========
                  if (registro.costoTotal != null) ...[
                    _buildInfoField(
                      icon: Icons.attach_money,
                      label: 'Costo Total',
                      value: '\$${registro.costoTotal!.toStringAsFixed(2)}',
                      color: Colors.green,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // DESPLEGABLE DE DETALLES DE FACTURA
                  if (registro.idFactura != null) ...[
                    _buildDetallesFacturaExpansion(registro.idFactura!),
                    const SizedBox(height: 12),
                  ],

                  // ========== OBSERVACIONES ==========
                  if (registro.descripcion != null &&
                      registro.descripcion!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.note, color: Colors.amber, size: 16),
                              const SizedBox(width: 8),
                              const Text(
                                'Observaciones',
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
          ],
        ),
      ),
    );
  }

  //  DETALLES DE FACTURA
  Widget _buildDetallesFacturaExpansion(int idFactura) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.3)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: Colors.blue,
          collapsedIconColor: Colors.blue,
          backgroundColor: Colors.blue.withOpacity(0.05),
          collapsedBackgroundColor: Colors.blue.withOpacity(0.05),
          title: Row(
            children: [
              Icon(Icons.receipt, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Detalles de Factura',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: FutureBuilder<List<DetalleFacturaDTO>>(
                future: RegistrosService.obtenerDetallesFactura(idFactura),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                        strokeWidth: 2,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        'Error al cargar detalles',
                        style: TextStyle(color: Colors.red.shade300),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        'No hay detalles disponibles',
                        style: TextStyle(color: Colors.white54),
                      ),
                    );
                  }

                  final detalles = snapshot.data!;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: detalles.length,
                    separatorBuilder: (_, __) => Divider(
                      color: Colors.white12,
                      height: 12,
                    ),
                    itemBuilder: (context, index) {
                      final detalle = detalles[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.03),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Descripción del producto/servicio
                            Text(
                              'Producto:\n${detalle.descripcion}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Cantidad, precio y subtotal en fila
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Cantidad: ${detalle.cantidad}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Precio: \$${detalle.precioUnitario.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Subtotal: \$${detalle.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
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

  // ========== WIDGET AUXILIAR PARA MOSTRAR INFO ==========
  Widget _buildInfoField({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
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
    );
  }

  Widget _buildIndicadorEstado(int estado) {
    String textoEstado = 'Pendiente';
    Color colorEstado = Colors.orange;
    IconData iconoEstado = Icons.schedule;

    if (estado == 1) {
      textoEstado = 'En Proceso';
      colorEstado = Colors.blue;
      iconoEstado = Icons.check_circle;
    } else if (estado == 2) {
      textoEstado = 'Finalizado';
      colorEstado = Colors.green;
      iconoEstado = Icons.schedule;
    } else if (estado == 3) {
      textoEstado = 'Reservado';
      colorEstado = Colors.orange;
      iconoEstado = Icons.wallet_travel_sharp;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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