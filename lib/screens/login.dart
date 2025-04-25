import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/biometric_auth.dart';
import 'package:ingeconomica/screens/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _ccController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _forgotPasswordCCController = TextEditingController();
  final BiometricAuth _biometricAuth = BiometricAuth();
  bool _showPasswordLogin = false;
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkDeviceForBiometrics();
  }

  Future<void> _checkDeviceForBiometrics() async {
    bool canCheckBiometrics = await _biometricAuth.canCheckBiometrics();
    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });

    if (canCheckBiometrics) {
      _authenticateBiometric();
    } else {
      setState(() {
        _showPasswordLogin = true;
      });
    }
  }

  Future<void> _authenticateBiometric() async {
    bool isAuthenticated = await _biometricAuth.authenticateWithBiometrics();
    if (isAuthenticated) {
      Navigator.pushNamed(context, "/");
    } else {
      setState(() {
        _showPasswordLogin = true;
      });
    }
  }

  Future<void> _login() async {
    String cc = _ccController.text;
    String password = _passwordController.text;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedCC = prefs.getString('cedula');
    String? storedPassword = prefs.getString('password');

    if (cc == storedCC && password == storedPassword) {
      Navigator.pushNamed(context, "/");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cédula o contraseña incorrecta")),
      );
    }
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Recuperar Contraseña'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ingresa tu número de cédula para recuperar tu contraseña'),
              const SizedBox(height: 16),
              TextField(
                controller: _forgotPasswordCCController,
                decoration: InputDecoration(
                  labelText: 'Cédula',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.credit_card),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _recoverPassword();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 21, 24, 26),
                foregroundColor: Colors.white,
              ),
              child: const Text('Recuperar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _recoverPassword() async {
    final String cc = _forgotPasswordCCController.text;
    if (cc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingresa tu cédula")),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedCC = prefs.getString('cedula');
    String? storedPassword = prefs.getString('password');

    if (cc == storedCC) {
      Navigator.of(context).pop(); // Cerrar el diálogo actual
      
      // Mostrar el diálogo con la contraseña recuperada
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Contraseña Recuperada'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Tu contraseña es:'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.teal),
                  ),
                  child: Text(
                    storedPassword ?? 'No disponible',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 21, 24, 26),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Entendido'),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("La cédula ingresada no está registrada")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen dimensions
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 204, 240, 244),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05), // 5% padding
        child: SingleChildScrollView( // Allows scrolling if content is too large
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset(
                  'icon.png',
                  width: screenWidth * 0.4,
                  height: screenHeight * 0.3,
                ),
              ),
              const SizedBox(height: 40),
              if (!_showPasswordLogin) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showPasswordLogin = true;
                    });
                  },
                  child: const Text("Cancelar autenticación biométrica"),
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    TextField(
                      controller: _ccController,
                      decoration: InputDecoration(
                        labelText: "Cédula",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 12.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Contraseña",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 12.0),
                      ),
                      obscureText: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromARGB(255, 21, 24, 26),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                    ),
                    child: const Text("Iniciar Sesión"),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _showForgotPasswordDialog,
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Register()),
                      );
                    },
                    child: const Text("¿No tienes cuenta? Regístrate aquí"),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
