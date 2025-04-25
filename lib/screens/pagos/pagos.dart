import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class Pagos extends StatefulWidget {
  final double saldoDisponible;
  final Function(double pago, String descripcion) onPagoRealizado;

  const Pagos({super.key, required this.saldoDisponible, required this.onPagoRealizado});

  @override
  _PagosState createState() => _PagosState();
}

class _PagosState extends State<Pagos> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
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

  void _pagarCuota() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      
      double cuota = double.tryParse(_montoController.text) ?? 0;
      String descripcion = _descripcionController.text;

      if (cuota <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor, ingrese una cantidad válida")),
        );
        return;
      }

      if (cuota <= widget.saldoDisponible) {
        // Realizar el pago
        widget.onPagoRealizado(cuota, descripcion);
        _mostrarNotificacion(cuota);
        
        // Mostrar el recibo de pago
        _mostrarReciboPago(cuota, descripcion);
        
        setState(() {
          _montoController.clear();
          _descripcionController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Saldo insuficiente para pagar la cuota.'),
        ));
      }
    }
  }
  
  void _mostrarReciboPago(double cantidad, String descripcion) {
    final DateTime ahora = DateTime.now();
    final String fecha = DateFormat('dd/MM/yyyy HH:mm:ss').format(ahora);
    final String idTransaccion = '${ahora.millisecondsSinceEpoch}';
    final double nuevoSaldo = widget.saldoDisponible - cantidad;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: Colors.teal, size: 28),
            const SizedBox(width: 10),
            const Text('Recibo de Pago', style: TextStyle(color: Colors.teal)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sección de información de transacción
              _buildSectionTitle('Información de la Transacción'),
              _buildInfoRow('Fecha:', fecha),
              _buildInfoRow('ID Transacción:', idTransaccion),
              const Divider(),
              
              // Sección de detalles del pago
              _buildSectionTitle('Detalles del Pago'),
              _buildInfoRow('Monto Pagado:', '\$${cantidad.toStringAsFixed(2)}', valueColor: Colors.red),
              _buildInfoRow('Descripción:', descripcion.isNotEmpty ? descripcion : 'No especificada'),
              const Divider(),
              
              // Sección de saldo
              _buildSectionTitle('Información de Saldo'),
              _buildInfoRow('Saldo Anterior:', '\$${widget.saldoDisponible.toStringAsFixed(2)}'),
              _buildInfoRow('Nuevo Saldo:', '\$${nuevoSaldo.toStringAsFixed(2)}', valueColor: Colors.red),
              const Divider(),
              
              // Mensaje de confirmación
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.teal.withOpacity(0.5)),
                ),
                child: const Column(
                  children: [
                    Text(
                      '¡Pago procesado con éxito!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'La transacción se ha registrado correctamente en tu historial de movimientos.',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar', style: TextStyle(color: Colors.teal)),
          ),
        ],
      ),
    );
  }
  
  // Métodos auxiliares para construir el recibo
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.teal,
        ),
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor,
              fontWeight: valueColor != null ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                            'Datos del Pago',
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
                            controller: _montoController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Monto a pagar',
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
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _descripcionController,
                            decoration: InputDecoration(
                              labelText: 'Descripción del pago',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.description),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _pagarCuota,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
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
      ),
    );
  }
}
