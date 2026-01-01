import 'package:flutter/material.dart';
import 'package:motos_app/screens/ViewProfileScreen.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';
import 'dart:convert';
import 'RutasMenuScreen.dart';
class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({super.key});

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  int _selectedIndex = 0;
  int _selectedCardIndex = -1;
  String nombreUsuario = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final userMap = await TokenManager.getUserJson();
    if (userMap != null) {
      setState(() {
        nombreUsuario = userMap["nombre_usuario"] ??
            userMap["nombreUsuario"] ??
            userMap["nombre_completo"] ??
            "Usuario";
      });
      return;
    }
    final token = await TokenManager.getToken();
    if (token == null) return;
    final parts = token.split(".");
    if (parts.length != 3) return;
    try {
      final payload =
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final data = jsonDecode(payload);
      setState(() {
        nombreUsuario = data["nombre_usuario"] ??
            data["nombreUsuario"] ??
            data["sub"] ??
            "Usuario";
      });
    } catch (e) {
      setState(() => nombreUsuario = "Usuario");
    }
  }

  final List<Widget Function(BuildContext)> _screens = [
        (context) => const Center(child: Text('Inicio', style: TextStyle(color: Colors.white))),
        (context) => const Center(child: Text('Mapa', style: TextStyle(color: Colors.white))),
        (context) => const Center(child: Text('Buscar', style: TextStyle(color: Colors.white))),
        (context) => const Center(child: Text('Notificaciones', style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ViewProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        title: Text(
          '¡Bienvenido, $nombreUsuario!',
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            tooltip: "Cerrar sesión",
            onPressed: () async {
              await AuthService.logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: _selectedIndex < 4
          ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _DashboardCard(
              icon: Icons.event_note,
              label: 'Agendar',
              selected: _selectedCardIndex == 0,
              onTap: () => setState(() => _selectedCardIndex = 0),
            ),
            _DashboardCard(
              icon: Icons.motorcycle,
              label: 'Mantenimientos',
              selected: _selectedCardIndex == 1,
              onTap: () => setState(() => _selectedCardIndex = 1),
            ),
            _DashboardCard(
              icon: Icons.route,
              label: 'Rutas',
              selected: _selectedCardIndex == 2,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RutasMenuPage()),
                );
              },
            ),
          ],
        ),
      )
          : const SizedBox(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.yellow[700],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? Colors.yellow : Colors.transparent,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
