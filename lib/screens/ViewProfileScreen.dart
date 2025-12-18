import 'package:flutter/material.dart';
import 'EditProfileScreen.dart';
import 'AddMotorcycleScreen.dart';
import 'ViewMotorcycleScreen.dart';
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
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
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
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
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
                      ? const Icon(Icons.person, color: Colors.grey, size: 32)
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
                SizedBox(
                  width: 75,
                  child: ElevatedButton(
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
                      padding: const EdgeInsets.symmetric(vertical: 6),
                    ),
                    child: const Text(
                      'Editar Perfil',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    print('Compartir perfil');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                  child: const Text(
                    'Compartir',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 1),
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 8),
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
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            const SizedBox(height: 1),
            const Divider(color: Colors.grey, thickness: 1),
            const SizedBox(height: 12),
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
            ConstrainedBox(
              constraints: motos.isEmpty
                  ? const BoxConstraints() // se ajusta al contenido si no hay motos
                  : const BoxConstraints(maxHeight: 400),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: motos.isEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.motorcycle, color: Colors.grey, size: 48),
                    SizedBox(height: 12),
                    Text(
                      'No tienes motos en tu garaje',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    SizedBox(height: 6),
                    Text(
                      '¡Añade tu primera moto!',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: motos.length,
                  itemBuilder: (context, index) {
                    final motoItem = motos[index];
                    final isSelected = selectedMotoIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selectedMotoIndex == index) {
                            selectedMotoIndex = null;
                          } else {
                            selectedMotoIndex = index;
                          }
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
                                  image: motoItem.ruta_imagenMotos != null &&
                                      motoItem.ruta_imagenMotos!.isNotEmpty
                                      ? DecorationImage(
                                    image: NetworkImage(
                                        motoItem.ruta_imagenMotos!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: (motoItem.ruta_imagenMotos == null ||
                                    motoItem.ruta_imagenMotos!.isEmpty)
                                    ? const Icon(Icons.motorcycle,
                                    color: Colors.grey)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildMotoRow('Marca', motoItem.marca ?? '-',
                                        'Placa', motoItem.placa ?? '-'),
                                    buildMotoRow('Modelo', motoItem.modelo ?? '-',
                                        'Año', motoItem.anio?.toString() ?? '-'),
                                    buildMotoRow(
                                        'Kilometraje',
                                        '${motoItem.kilometraje?.toString() ?? '-'} km',
                                        'Cilindraje',
                                        '${motoItem.cilindraje?.toString() ?? '-'} cc'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
                            AddMotorcycleScreen(usuario: usuario!)),
                  ).then((_) => loadUser());
                },
                icon: const Icon(Icons.motorcycle, color: Colors.black, size: 20),
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
      floatingActionButton: selectedMotoIndex != null
          ? FloatingActionButton.extended(
        onPressed: () {
          final selectedMoto = motos[selectedMotoIndex!];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewMotorcycleScreen(
                usuario: usuario!,
                moto: selectedMoto,
              ),
            ),
          ).then((updated) {
            if (updated == true) {
              loadUser();
            }
          });
        },
        backgroundColor: Colors.yellow[700],
        label: const Text(
          'Editar',
          style: TextStyle(color: Colors.black),
        ),
        icon: const Icon(Icons.edit, color: Colors.black),
      )
          : null,
    );
  }
}
