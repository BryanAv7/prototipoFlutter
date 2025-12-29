import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../models/moto.dart';
import '../models/Tipo.dart';
import '../models/detalle_ui.dart'; // ⬅️ AGREGAR
import '../screens/BuscarUsuarioPage.dart';
import '../services/moto_service.dart';
import '../services/tipo_service.dart';
import '../services/registros_service.dart';
import '../screens/seleccionar_productos_page.dart'; // ⬅️ AGREGAR

class AgregarMantenimientoPage extends StatefulWidget {
  const AgregarMantenimientoPage({super.key});

  @override
  State<AgregarMantenimientoPage> createState() =>
      _AgregarMantenimientoPageState();
}

class _AgregarMantenimientoPageState
    extends State<AgregarMantenimientoPage> {

  // ---------------- FORM ----------------
  final _formKey = GlobalKey<FormState>();
  bool intentoGuardar = false;

  // ---------------- CONTROLLERS ----------------
  final TextEditingController clienteCtrl = TextEditingController();
  final TextEditingController vehiculoCtrl = TextEditingController();
  final TextEditingController descripcionCtrl = TextEditingController();

  // ---------------- DATA ----------------
  int? idClienteSeleccionado;
  int? idTipoSeleccionado; // ⬅️ CAMBIADO de String? tipoMantenimiento
  List<DetalleUI> detallesSeleccionados = []; // ⬅️ AGREGAR

  // VEHÍCULO ----------------
  int? idMotoSeleccionada;
  List<Moto> motosCliente = [];
  bool cargandoMotos = false;
  // TIPOS ----------------
  List<Tipo> tiposMantenimiento = []; // ⬅️ NUEVO
  bool cargandoTipos = false; // ⬅️ NUEVO

  @override
  void initState() {
    super.initState();
    _cargarTipos(); // ⬅️ NUEVO: Cargar tipos al iniciar
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mantenimientos / Agregar",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: intentoGuardar
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _labelValue("Fecha:", "29/08/2025"),
              _labelValue("# De Registro:", "0000000001"),
              const SizedBox(height: 16),

              // -------- CLIENTE --------
              _searchClienteField(),
              const SizedBox(height: 12),

              _dropdownVehiculo(),
              const SizedBox(height: 12),

              _dropdownTipo(),
              const SizedBox(height: 12),

              _productsBox(),
              const SizedBox(height: 12),

              _descriptionField(),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD700),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: _validarAntesDeGuardar,
                  child: const Text(
                    "+ Guardar",
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- VALIDACIÓN ----------------

  void _validarAntesDeGuardar() {
    setState(() => intentoGuardar = true);

    final formValido = _formKey.currentState!.validate();

    if (idClienteSeleccionado == null ||
        idTipoSeleccionado == null ||
        detallesSeleccionados.isEmpty || // ⬅️ CAMBIAR AQUÍ
        !formValido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Complete los campos obligatorios"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (idMotoSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Debe seleccionar un vehículo"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    _confirmGuardar();
  }

  void _confirmGuardar() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2B2B2B),
        title: const Text(
          "Confirmación",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "¿Está seguro de guardar este mantenimiento?",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 12),
            Text(
              "Total: \$${_calcularTotal().toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar",
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Cerrar diálogo
              await _guardarMantenimiento();
            },
            child: const Text("Aceptar",
                style: TextStyle(color: Colors.yellow)),
          ),
        ],
      ),
    );
  }

  Future<void> _guardarMantenimiento() async {
    try {
      final body = {
        "idCliente": idClienteSeleccionado,
        "idEncargado": 2, // Por ahora manual
        "idMoto": idMotoSeleccionada,
        "idTipo": idTipoSeleccionado,
        "estado": 1,
        "observaciones": descripcionCtrl.text.trim(),
        "detalles": detallesSeleccionados
            .map((detalle) => detalle.toJson())
            .toList(),
      };

      print('JSON a enviar: ${jsonEncode(body)}'); // Para debugging

      final resultado = await RegistrosService.crear(body);

      Navigator.pop(context);

      if (resultado != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Mantenimiento guardado exitosamente"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pop(context, true);
      } else {
        _mostrarError("No se recibió respuesta del servidor");
      }
    } catch (e) {
      Navigator.pop(context);
      _mostrarError("Error al guardar: ${e.toString()}");
      print('❌ Error completo: $e');
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ---------------- COMPONENTES ----------------

  /// CLIENTE (bloqueado + búsqueda)
  Widget _searchClienteField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: clienteCtrl,
            readOnly: true,
            style: const TextStyle(color: Colors.white),
            decoration: _inputDecoration("Cliente"),
            validator: (_) {
              if (idClienteSeleccionado == null) {
                return 'Seleccione un cliente';
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.yellow),
          onPressed: _buscarCliente,
        ),
      ],
    );
  }

  Future<void> _buscarCliente() async {
    print('🔍 Iniciando búsqueda de cliente...');
    final Usuario? usuario = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const BuscarUsuarioPage()),
    );

    if (usuario != null) {
      setState(() {
        idClienteSeleccionado = usuario.idUsuario;
        clienteCtrl.text = usuario.nombreCompleto ?? '';

        // reset vehículo
        idMotoSeleccionada = null;
        vehiculoCtrl.clear();
        motosCliente.clear();
        cargandoMotos = true;
      });

      _cargarMotos(usuario.idUsuario!);
    }
  }

  Future<void> _cargarMotos(int idUsuario) async {
    try {
      final motos = await MotoService.listarMotosPorUsuario(idUsuario);
      setState(() {
        motosCliente = motos;
      });
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al cargar vehículos"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => cargandoMotos = false);
    }
  }
  Widget _campoBloqueado(String texto) {
    return TextFormField(
      enabled: false,
      decoration: _inputDecoration(texto),
    );
  }

  Widget _dropdownVehiculo() {
    if (idClienteSeleccionado == null) {
      return _campoBloqueado("Seleccione primero un cliente");
    }

    if (cargandoMotos) {
      return const Center(child: CircularProgressIndicator());
    }

    if (motosCliente.isEmpty) {
      return _campoBloqueado("Este cliente no tiene vehículos");
    }

    return DropdownButtonFormField<int>(
      dropdownColor: const Color(0xFF2B2B2B),
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration("Vehículo (Placa)"),
      value: idMotoSeleccionada,
      items: motosCliente.map((moto) {
        return DropdownMenuItem(
          value: moto.id_moto,
          child: Text("${moto.placa} - ${moto.modelo}"),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => idMotoSeleccionada = value);
      },
      validator: (value) =>
      value == null ? 'Seleccione un vehículo' : null,
    );
  }

  // ⬅️ NUEVO: Método para cargar tipos
  Future<void> _cargarTipos() async {
    setState(() => cargandoTipos = true);
    try {
      final tipos = await TipoService.obtenerTodos();
      setState(() {
        tiposMantenimiento = tipos;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error al cargar tipos: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => cargandoTipos = false);
    }
  }

  Widget _dropdownTipo() {
    if (cargandoTipos) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.yellow),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
              ),
            ),
            SizedBox(width: 12),
            Text(
              "Cargando tipos...",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      );
    }

    if (tiposMantenimiento.isEmpty) {
      return _campoBloqueado("No hay tipos disponibles");
    }

    return DropdownButtonFormField<int>(
      dropdownColor: const Color(0xFF2B2B2B),
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration("Tipo de mantenimiento"),
      value: idTipoSeleccionado,
      items: tiposMantenimiento.map((tipo) {
        return DropdownMenuItem<int>(
          value: tipo.idTipo,
          child: Text(tipo.nombre),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => idTipoSeleccionado = value);
      },
      validator: (value) =>
      value == null ? 'Seleccione un tipo de mantenimiento' : null,
    );
  }

  Widget _productsBox() {
    final bool hayDetalles = detallesSeleccionados.isNotEmpty;
    final bool error = intentoGuardar && !hayDetalles;

    return GestureDetector(
      onTap: () async {
        final resultado = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SeleccionarProductosPage(
              detallesIniciales: detallesSeleccionados,
            ),
          ),
        );

        if (resultado != null && resultado is List<DetalleUI>) {
          setState(() {
            detallesSeleccionados = resultado;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: error ? Colors.red : Colors.yellow,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hayDetalles
                      ? "Productos (${detallesSeleccionados.length})"
                      : "Productos:",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios,
                    color: Colors.yellow, size: 16),
              ],
            ),
            if (hayDetalles) ...[
              const SizedBox(height: 8),
              Text(
                "Total: \$${_calcularTotal().toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.yellow,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _calcularTotal() {
    return detallesSeleccionados.fold(
      0.0,
          (sum, detalle) => sum + detalle.subtotal,
    );
  }
  Widget _descriptionField() {
    return TextField(
      controller: descripcionCtrl,
      maxLines: 4,
      style: const TextStyle(color: Colors.white),
      decoration: _inputDecoration("Descripción"),
    );
  }

  Widget _labelValue(String label, String value) {
    return Row(
      children: [
        Text(label, style: _labelStyle()),
        const SizedBox(width: 8),
        Text(value, style: _valueStyle()),
      ],
    );
  }

  // ---------------- ESTILOS ----------------

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.yellow),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.yellow, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  TextStyle _labelStyle() =>
      const TextStyle(color: Colors.white70, fontSize: 14);

  TextStyle _valueStyle() =>
      const TextStyle(color: Colors.white, fontSize: 14);
}
