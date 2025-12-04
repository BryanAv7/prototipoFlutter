import 'package:flutter/material.dart';
import 'EditProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Lista de acciones para cada ítem
  final List<Widget Function(BuildContext)> _screens = [
        (context) => const Center(child: Text('Inicio', style: TextStyle(color: Colors.white))),
        (context) => const Center(child: Text('Mapa', style: TextStyle(color: Colors.white))),
        (context) => const Center(child: Text('Buscar', style: TextStyle(color: Colors.white))),
        (context) => const Center(child: Text('Notificaciones', style: TextStyle(color: Colors.white))),
  ];

  void _onItemTapped(int index) {
    if (index == 4) {
      // Ítem "Perfil": me lleva a EditProfileScreen---
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
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
        title: const Text(
          '¡Bienvenido a Gorila Motors!',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: _selectedIndex < 4
          ? Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _DashboardCard(icon: Icons.list_alt, label: 'Órdenes', onTap: () {}),
            _DashboardCard(icon: Icons.inventory, label: 'Inventario', onTap: () {}),
            _DashboardCard(icon: Icons.notifications, label: 'Reservas', onTap: () {}),
            _DashboardCard(icon: Icons.motorcycle, label: 'Mantenimientos', onTap: () {}),
            _DashboardCard(icon: Icons.person, label: 'Usuarios', onTap: () {}),
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

// Widget de tarjeta
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(12),
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