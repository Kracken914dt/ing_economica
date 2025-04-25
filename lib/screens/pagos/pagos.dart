import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Pagos extends StatefulWidget {
  final double saldoDisponible;
  final Function(double pago, String descripcion) onPagoRealizado;

  const Pagos({super.key, required this.saldoDisponible, required this.onPagoRealizado});

  @override
  _PagosState createState() => _PagosState();
}

class _PagosState extends State<Pagos> {
  final _formKey = GlobalKey<FormState>();
  double cuota = 0.0;
  String descripcion = '';
  final LocalAuthentication auth = LocalAuthentication();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _mostrarNotificacion(double cantidad) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Pago realizado',
      'Has pagado \$${cantidad.toStringAsFixed(2)}',
      platformChannelSpecifics,
    );
  }

  Future<void> _pagarCuota() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (cuota <= widget.saldoDisponible) {
        // Realiza la autenticación biométrica
        final bool isAuthenticated = await auth.authenticate(
          localizedReason: 'Confirma tu identidad para realizar el pago',
          options: const AuthenticationOptions(biometricOnly: true),
        );

        if (isAuthenticated) {
          // Realiza el pago y notifica a la HomeScreen
          widget.onPagoRealizado(cuota, descripcion);

          // Muestra la notificación
          _mostrarNotificacion(cuota);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Pago exitoso.'),
          ));

          // Regresar a la HomeScreen
          Navigator.pop(context);
        } else {
          // Manejar caso de fallo en la autenticación
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Autenticación fallida')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Saldo insuficiente para pagar la cuota.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagar Cuota'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.teal.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información de Pago',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.account_balance_wallet, color: Colors.teal),
                              const SizedBox(width: 10),
                              Text(
                                'Saldo disponible: \$${widget.saldoDisponible.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Cuota a pagar',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingresa un monto';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Por favor, ingresa un número válido';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            cuota = double.parse(value!);
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Descripción del pago',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.description),
                          ),
                          onSaved: (value) {
                            descripcion = value ?? '';
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.payment),
                    onPressed: _pagarCuota,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    label: const Text(
                      "Realizar Pago",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
