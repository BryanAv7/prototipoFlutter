import 'package:flutter/material.dart';
import 'EditProfileScreen.dart';
import 'AddMotorcycleScreen.dart';
import '../models/usuario.dart';
import '../models/moto.dart';
import '../services/moto_service.dart';
import '../utils/token_manager.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  Usuario? usuario;
  List<Moto> motos = [];
  bool isLoading = true;
  int? selectedMotoIndex;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final jsonMap = await TokenManager.getUserJson();
    if (jsonMap != null) {
      usuario = Usuario.fromJson(jsonMap);
      motos = await MotoService.listarMotosPorUsuario(usuario!.idUsuario!);
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget buildMotoRow(String label1, String value1, String label2, String value2) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label1: ',
                    style: const TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value1,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label2: ',
                    style: const TextStyle(
                        color: Colors.white70, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: value2,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        title: const Text(
          'Ver Perfil',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : usuario == null
          ? const Center(
        child: Text(
          'No se pudo cargar usuario',
          style: TextStyle(color: Colors.white),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil y botones
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[850],
                  backgroundImage: usuario!.rutaImagen != null &&
                      usuario!.rutaImagen!.isNotEmpty
                      ? NetworkImage(usuario!.rutaImagen!)
                      : null,
                  child: (usuario!.rutaImagen == null ||
                      usuario!.rutaImagen!.isEmpty)
                      ? const Icon(Icons.person,
                      color: Colors.grey, size: 32)
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  usuario!.nombreUsuario ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    if (usuario != null) {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(usuario: usuario!),
                        ),
                      );
                      loadUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    padding:
                    const EdgeInsets.symmetric(vertical: 6),
                  ),
                  child: const Text(
                    'Editar',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                    TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () {
                    print('Compartir perfil');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    padding:
                    const EdgeInsets.symmetric(vertical: 6),
                  ),
                  child: const Text(
                    'Compartir',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                    TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Descripción
            const Text(
              'Descripción',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                usuario!.descripcion?.isNotEmpty == true
                    ? usuario!.descripcion!
                    : 'Aún no has agregado una descripción.',
                style:
                const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // Garaje virtual
            const Text(
              'Garaje Virtual',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: motos.isEmpty
                    ? [
                  const Icon(Icons.motorcycle,
                      color: Colors.grey, size: 48),
                  const SizedBox(height: 12),
                  const Text(
                    'No tienes motos en tu garaje',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '¡Añade tu primera moto!',
                    style: TextStyle(
                        color: Colors.white, fontSize: 14),
                  ),
                ]
                    : motos.asMap().entries.map((entry) {
                  int index = entry.key;
                  Moto moto = entry.value;
                  bool isSelected = selectedMotoIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMotoIndex = index;
                      });
                    },
                    child: Card(
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: isSelected
                            ? const BorderSide(
                            color: Colors.yellow, width: 2)
                            : BorderSide.none,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[700],
                                image: moto.ruta_imagenMotos != null &&
                                    moto.ruta_imagenMotos!
                                        .isNotEmpty
                                    ? DecorationImage(
                                  image: NetworkImage(
                                      moto.ruta_imagenMotos!),
                                  fit: BoxFit.cover,
                                )
                                    : null,
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: (moto.ruta_imagenMotos == null ||
                                  moto.ruta_imagenMotos!
                                      .isEmpty)
                                  ? const Icon(Icons.motorcycle,
                                  color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  buildMotoRow(
                                      'Marca',
                                      moto.marca ?? '-',
                                      'Placa',
                                      moto.placa ?? '-'),
                                  buildMotoRow(
                                      'Modelo',
                                      moto.modelo ?? '-',
                                      'Año',
                                      moto.anio?.toString() ?? '-'),
                                  buildMotoRow(
                                      'Kilometraje',
                                      '${moto.kilometraje?.toString() ?? '-'} km',
                                      'Cilindraje',
                                      '${moto.cilindraje?.toString() ?? '-'} cc'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddMotorcycleScreen(usuario: usuario!),
                    ),
                  ).then((_) => loadUser());
                },
                icon: const Icon(Icons.motorcycle,
                    color: Colors.black, size: 20),
                label: const Text(
                  'AÑADIR MI MOTO',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow[700],
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
