import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../config/api.dart';
import 'HomeScreen.dart';
import 'RegisterScreen.dart';
import 'HomeUserScreen.dart';
import '../screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  Widget? _correoSuffix;

  String? _savedIp;

  @override
  void initState() {
    super.initState();
    _correoSuffix = const Icon(Icons.close, color: Colors.red);
    correoController.addListener(_validarCorreo);
    _loadSavedIp();
  }

  @override
  void dispose() {
    correoController.removeListener(_validarCorreo);
    super.dispose();
  }

  Future<void> _loadSavedIp() async {
    final prefs = await ApiConfig.getSavedServerIp();
    setState(() {
      _savedIp = prefs;
    });
  }

  void _validarCorreo() {
    final email = correoController.text.trim();

    if (email.endsWith('@gmail.com') || email.endsWith('@outlook.com')) {
      setState(() => _correoSuffix = const Icon(Icons.check_circle, color: Colors.green));
    } else {
      setState(() => _correoSuffix = const Icon(Icons.close, color: Colors.red));
    }
  }

  Future<void> _login() async {
    final correo = correoController.text.trim();
    final contrasena = contrasenaController.text.trim();

    // Verificar si la IP está configurada
    if (_savedIp == null || _savedIp!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Configura la IP del servidor antes de iniciar sesión."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (correo.isEmpty || contrasena.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa todos los campos"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    final response = await AuthService.login(correo, contrasena);

    setState(() => _loading = false);

    if (response == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Correo o contraseña incorrectos"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("¡Bienvenido, ${response.usuario.nombreUsuario}!"),
        backgroundColor: Colors.green,
      ),
    );

    // Obtener Roles y Redireccionamiento
    _redirigirSegunRol(response.usuario.idUsuario);
  }

  Future<void> _redirigirSegunRol(dynamic idUsuario) async {
    try {
      // Convertir a int si es necesario
      final userId = idUsuario is int ? idUsuario : int.parse(idUsuario.toString());

      //print('[LOGIN] Obteniendo roles para usuario ID: $userId');

      final roles = await AuthService.obtenerRolesUsuario(userId);

      if (!mounted) return;

      if (roles != null && roles.isNotEmpty) {
        // El primer rol es el principal
        final rolPrincipal = roles[0] as Map<String, dynamic>;
        final idRol = rolPrincipal['idRol'] as int?;

        //print('[LOGIN] ID Rol: $idRol');

        // Redirigir según el rol
        if (idRol == 2) {
          // CLIENTE
          //print('[LOGIN] Redirigiendo a HomeUserScreen (CLIENTE)');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeUserScreen()),
          );
        } else if (idRol == 3) {
          // MECANICO
          //print('[LOGIN] Redirigiendo a HomeScreen (MECANICO)');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else if (idRol == 1) {
          // ADMIN
          print('[LOGIN] Redirigiendo a HomeScreen (ADMIN)');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeUserScreen()),
          );
        } else {
          // Rol desconocido
          //print('[LOGIN] Rol desconocido: $idRol, se direcciona a HomeScreen por defecto');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      } else {
        // Si no hay roles, ir a HomeScreen por defecto
        //print('[LOGIN] Sin roles, yendo a HomeScreen por defecto');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      //print('[LOGIN] Error obteniendo roles: $e');
      // En caso de error, ir a HomeScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  void _showIpDialog() {
    final ipPuerto = _savedIp?.split(':') ?? ['', ''];
    final ipController = TextEditingController(text: ipPuerto[0]);
    final puertoController = TextEditingController(text: ipPuerto.length > 1 ? ipPuerto[1] : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: const Text(
          "Configurar Servidor",
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo IP
            TextField(
              controller: ipController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "XXX.XXX.XX.XXX",
                hintStyle: TextStyle(color: Colors.grey[400]),
                labelText: "Dirección IP",
                labelStyle: const TextStyle(color: Colors.yellow),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.yellow),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.yellow),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Campo Puerto
            TextField(
              controller: puertoController,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "8080",
                hintStyle: TextStyle(color: Colors.grey[400]),
                labelText: "Puerto",
                labelStyle: const TextStyle(color: Colors.yellow),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.yellow),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.yellow),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () async {
              final ip = ipController.text.trim();
              final puerto = puertoController.text.trim();

              if (ip.isNotEmpty && puerto.isNotEmpty) {
                final ipPuertoCompleta = '$ip:$puerto';
                await ApiConfig.setServerIp(ipPuertoCompleta);
                setState(() => _savedIp = ipPuertoCompleta);
                if (mounted) {
                  Navigator.pop(context);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Por favor completa todos los campos"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text("Guardar", style: TextStyle(color: Colors.green)),
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 60,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.settings, color: Colors.yellow),
              onPressed: _showIpDialog,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Spacer(),

                        Center(
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.red,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logoMotors.png',
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[850],
                                    child: Icon(
                                      Icons.motorcycle,
                                      color: Colors.grey[400],
                                      size: 60,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // CAMPO CORREO
                        TextField(
                          controller: correoController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Correo',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[850],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.yellow),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.yellow),
                            ),
                            suffixIcon: _correoSuffix,
                          ),
                        ),

                        const SizedBox(height: 15),

                        // CAMPO CONTRASEÑA
                        TextField(
                          controller: contrasenaController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            filled: true,
                            fillColor: Colors.grey[850],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.yellow),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.yellow),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.grey[400],
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OlvideContrasenaScreen(),
                                ),
                              );
                            },
                            child: const Text('¿Olvidaste tu contraseña?', style: TextStyle(color: Colors.red)),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // BOTÓN LOGIN
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[700],
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _loading
                                ? const CircularProgressIndicator(
                              color: Colors.black,
                            )
                                : const Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // BOTÓN REGISTRO
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow[700],
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Registrarse',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'O continúa con:',
                          style: TextStyle(color: Colors.white),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: Image.asset(
                              'assets/images/logoGoogle.png',
                              height: 24,
                              width: 24,
                            ),
                            label: const Text(
                              'Google',
                              style: TextStyle(color: Colors.black),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}