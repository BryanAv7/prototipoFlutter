import 'package:flutter/material.dart';
import '../services/recuperacion_service.dart';

class OlvideContrasenaScreen extends StatefulWidget {
  const OlvideContrasenaScreen({super.key});

  @override
  State<OlvideContrasenaScreen> createState() => _OlvideContrasenaScreenState();
}

class _OlvideContrasenaScreenState extends State<OlvideContrasenaScreen> {
  final TextEditingController correoController = TextEditingController();
  bool _loading = false;
  bool _emailEnviado = false;

  Future<void> _solicitarRecuperacion() async {
    final correo = correoController.text.trim();

    if (correo.isEmpty || !correo.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo inválido'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    final resultado = await RecuperacionService.solicitarRecuperacion(correo);
    setState(() => _loading = false);

    if (resultado?['exito'] ?? false) {
      setState(() => _emailEnviado = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado?['mensaje'] ?? 'Error'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Recuperar Contraseña', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _emailEnviado
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
                child: const Icon(Icons.check_circle, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 20),
              const Text(
                '¡Email Enviado!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Revisa tu bandeja de entrada',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700]),
                child: const Text('Volver al Login', style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ],
          ),
        )
            : Column(
          children: [
            const SizedBox(height: 30),
            const Text('Ingresa tu correo registrado para restablecer tu contraseña',
                style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: correoController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Ej:user1@gmail.com',
                hintStyle: TextStyle(color: Colors.grey[400]),
                labelText: 'Correo',
                labelStyle: const TextStyle(color: Colors.yellow),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _solicitarRecuperacion,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700]),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text('Enviar Codigo', style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}