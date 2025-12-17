import 'package:flutter/material.dart';
import 'EditProfileScreen.dart';
import 'AddMotorcycleScreen.dart';
import '../models/usuario.dart';
import '../utils/token_manager.dart';

class ViewProfileScreen extends StatefulWidget {
  const ViewProfileScreen({super.key});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  Usuario? usuario;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final jsonMap = await TokenManager.getUserJson();
    setState(() {
      usuario = jsonMap != null ? Usuario.fromJson(jsonMap) : null;
      isLoading = false;
    });
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
                // Botón Editar
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
                      loadUser(); // recarga después de editar
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
                // Botón Compartir
                ElevatedButton(
                  onPressed: () {
                    // Aquí puedes implementar la acción de compartir
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
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
                    style:
                    TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
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
                        const AddMotorcycleScreen()),
                  );
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
