import 'package:flutter/material.dart';
import '../services/recuperacion_service.dart';

class ReestablecerContrasenaScreen extends StatefulWidget {
  final String token;
  const ReestablecerContrasenaScreen({super.key, required this.token});

  @override
  State<ReestablecerContrasenaScreen> createState() => _ReestablecerContrasenaScreenState();
}

class _ReestablecerContrasenaScreenState extends State<ReestablecerContrasenaScreen> {
  final nuevaController = TextEditingController();
  final confirmarController = TextEditingController();
  bool _loading = false;
  bool _validandoToken = true;
  bool _tokenValido = false;
  bool _obscure1 = true;
  bool _obscure2 = true;

  @override
  void initState() {
    super.initState();
    _validarToken();
  }

  Future<void> _validarToken() async {

    final esValido = await RecuperacionService.validarToken(widget.token);


    setState(() {
      _tokenValido = esValido;
      _validandoToken = false;
    });
  }

  Future<void> _restablecer() async {

    if (nuevaController.text != confirmarController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Las contraseñas no coinciden'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    final resultado = await RecuperacionService.restablecerContrasena(widget.token, nuevaController.text);


    setState(() => _loading = false);

    if (resultado?['exito'] ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resultado?['mensaje'] ?? 'Éxito'), backgroundColor: Colors.green),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
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
        title: const Text('Nueva Contraseña', style: TextStyle(color: Colors.black)),
      ),
      body: _validandoToken
          ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
          : _tokenValido
          ? SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: nuevaController,
              obscureText: _obscure1,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Nueva contraseña',
                labelText: 'Nueva Contraseña',
                labelStyle: const TextStyle(color: Colors.yellow),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: () => setState(() => _obscure1 = !_obscure1),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: confirmarController,
              obscureText: _obscure2,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Confirma contraseña',
                labelText: 'Confirmar Contraseña',
                labelStyle: const TextStyle(color: Colors.yellow),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                  onPressed: () => setState(() => _obscure2 = !_obscure2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _restablecer,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700]),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.black)
                    : const Text('Restablecer', style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
            ),
          ],
        ),
      )
          : Center(
        child: Text('Token inválido o expirado', style: TextStyle(color: Colors.red, fontSize: 18)),
      ),
    );
  }
}