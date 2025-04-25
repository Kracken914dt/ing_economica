import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

class RetirosScreen extends StatefulWidget {
  final Function(double) onRetiroRealizado;
  final double saldoActual;
  final String nombreUsuario;
  final String cedulaUsuario;

  const RetirosScreen({
    super.key, 
    required this.onRetiroRealizado,
    this.saldoActual = 0.0,
    this.nombreUsuario = "Usuario", // Valor predeterminado
    this.cedulaUsuario = "Sin cédula", // Valor predeterminado
  });

  @override
  _RetirosScreenState createState() => _RetirosScreenState();
}

class _RetirosScreenState extends State<RetirosScreen> {
  final TextEditingController _montoController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _mostrarNotificacion(String cantidad) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Retiro realizado',
      'Has retirado \$ $cantidad',
      platformChannelSpecifics,
    );
  }

  void _retirarDinero() {
    double cantidad = double.tryParse(_montoController.text) ?? 0;

    if (cantidad <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingrese una cantidad válida")),
      );
      return;
    }

    // Verificar si hay saldo suficiente
    if (cantidad > widget.saldoActual) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saldo insuficiente para realizar el retiro')),
      );
      return;
    }

    widget.onRetiroRealizado(cantidad);
    _mostrarNotificacion(cantidad.toStringAsFixed(2));
    
    // Mostrar el recibo de retiro
    _mostrarReciboRetiro(cantidad);

    setState(() {
      _montoController.clear();
    });
  }
  
  void _mostrarReciboRetiro(double cantidad) {
    final DateTime ahora = DateTime.now();
    final String fecha = DateFormat('dd/MM/yyyy HH:mm:ss').format(ahora);
    final String idTransaccion = '${ahora.millisecondsSinceEpoch}';
    final double nuevoSaldo = widget.saldoActual - cantidad;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: Colors.orange, size: 28),
            const SizedBox(width: 10),
            const Text('Recibo de Retiro', style: TextStyle(color: Colors.orange)),
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
              
              // Sección de información del cliente
              _buildSectionTitle('Información del Cliente'),
              _buildInfoRow('Nombre:', widget.nombreUsuario),
              _buildInfoRow('Cédula:', widget.cedulaUsuario),
              const Divider(),
              
              // Sección de detalles del retiro
              _buildSectionTitle('Detalles del Retiro'),
              _buildInfoRow('Monto Retirado:', '\$${cantidad.toStringAsFixed(2)}', valueColor: Colors.orange),
              const Divider(),
              
              // Sección de saldo
              _buildSectionTitle('Información de Saldo'),
              _buildInfoRow('Saldo Anterior:', '\$${widget.saldoActual.toStringAsFixed(2)}'),
              _buildInfoRow('Nuevo Saldo:', '\$${nuevoSaldo.toStringAsFixed(2)}', valueColor: Colors.red),
              const Divider(),
              
              // Mensaje de confirmación
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange.withOpacity(0.5)),
                ),
                child: const Column(
                  children: [
                    Text(
                      '¡Retiro procesado con éxito!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
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
            },
            child: const Text('Cerrar', style: TextStyle(color: Colors.orange)),
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
          color: Colors.orange,
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
        title: const Text('Retiros'),
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
                          'Datos del Retiro',
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
                                'Saldo disponible: \$${widget.saldoActual.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.teal.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, size: 16, color: Colors.teal),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.nombreUsuario,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.credit_card, size: 16, color: Colors.teal),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Cédula: ${widget.cedulaUsuario}',
                                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _montoController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Monto a retirar",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.attach_money),
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
                    onPressed: _retirarDinero,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Realizar Retiro",
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
