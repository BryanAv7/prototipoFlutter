import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoScreen extends StatelessWidget {
  const AppInfoScreen({super.key});

  Future<void> _launchURL(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw 'No se pudo abrir: $url';
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        title: const Text(
          'Información de la App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo y Nombre de la App
            Center(
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.yellow[700]!,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow[700]!.withOpacity(0.2),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logoMotors.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.motorcycle,
                            color: Colors.yellow[700],
                            size: 60,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'GMotors',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Versión 1.0.0',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Descripción
            _buildSectionTitle('Acerca de'),
            _buildSectionContent(
              'GMotors es una aplicación móvil diseñada para propietarios de motocicletas y mecánicos. '
                  'Optimiza la gestión de mantenimientos, la reserva de servicios, la creación de perfiles y el control del inventario de talleres.',
            ),
            const SizedBox(height: 24),

            // Características
            _buildSectionTitle('Características Principales'),
            _buildFeatureItem('🏍️', 'Garaje Virtual - Administra tus motocicletas'),
            _buildFeatureItem('📱', 'Reconocimiento de Placas con IA'),
            _buildFeatureItem('📅', 'Sistema de Reservas de Mantenimiento (Usuarios-Mecanicos)'),
            _buildFeatureItem('📊', 'Historial de Mantenimientos'),
            _buildFeatureItem('🔧', 'Gestión de Inventario (Mecánicos)'),
            const SizedBox(height: 24),

            // ✅ NUEVO: Taller de Mecánica
            _buildSectionTitle('Taller de Mecánica'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gorila Motos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Especialistas en Servicio automotor y Reparación de Motocicletas',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Con más de 5 años de experiencia en reparación y mantenimiento de motocicletas. \n'
                        'Ofrecemos servicios de calidad a precios competitivos.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ubicación
            _buildSectionTitle('Horarios/Ubicación'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Camilo Ponce, Cuenca, Ecuador',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Horario: Lunes a Viernes 8:30 AM - 18:00 PM\n'
                        'Sábados: 9:00 AM - 2:00 PM',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Desarrolladores
            _buildSectionTitle('Desarrollador'),

            // Desarrollador 1
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bryan Avila',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Desarrollador Full Stack',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Responsable del desarrollo integral de la aplicación, incluyendo backend y frontend, gestión de usuarios y mecánicos, integración de IA para el reconocimiento de placas, digitalización del inventario y diseño de una experiencia de usuario (UX).',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Proyecto de Tesis - Desarrollo de un Sistema Asistente para la Gestión y Automatización de Talleres de Motocicletas',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contacto
            _buildSectionTitle('Contacto'),
            _buildContactItem(
              Icons.email,
              'Correo',
              'bavilag@est.ups.edu.ec',
                  () => _launchURL('mailto:bavilag@est.ups.edu.ec'),
            ),
            _buildContactItem(
              Icons.phone,
              'Teléfono',
              '--',
                  () => _launchURL('tel:--'),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Desarrollador'),

            // Desarrollador 2
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Paul Paute',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Desarrollador Full Stack',
                    style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Encargado del diseño de la arquitectura de la aplicación, la estructura de la base de datos, el sistema de facturación y la gestión de roles de usuario.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Proyecto de Tesis - Desarrollo de un Sistema Asistente para la Gestión y Automatización de Talleres de Motocicletas',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Contacto
            _buildSectionTitle('Contacto'),
            _buildContactItem(
              Icons.email,
              'Correo',
              'epautec@est.ups.edu.ec',
                  () => _launchURL('mailto:epautec@est.ups.edu.ec'),
            ),
            _buildContactItem(
              Icons.phone,
              'Teléfono',
              '--',
                  () => _launchURL('tel:--'),
            ),
            const SizedBox(height: 24),


            // Footer
            Center(
              child: Column(
                children: [
                  const Text(
                    '© 2026 GMotors. Todos los derechos reservados.',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        content,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
      IconData icon,
      String label,
      String value,
      VoidCallback onTap,
      ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.black, size: 20),
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
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(String label, IconData icon, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.yellow[700],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, color: Colors.black, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalLink(String label, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
          ],
        ),
      ),
    );
  }
}