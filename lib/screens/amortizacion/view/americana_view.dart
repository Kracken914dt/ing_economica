import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/amortizacion/americana/services/calcular_americana.dart'; // Asegúrate de importar la clase

class AmericaView extends StatefulWidget {
  const AmericaView({Key? key}) : super(key: key);

  @override
  _AmericaViewState createState() => _AmericaViewState();
}

class _AmericaViewState extends State<AmericaView> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para obtener los datos ingresados por el usuario
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();
  final TextEditingController _aniosController = TextEditingController();

  // Variables para almacenar los resultados
  double? _interesMensual;
  double? _totalIntereses;
  double? _ultimoPago;
  List<Map<String, dynamic>>? _tablaAmortizacion;

  // Función para realizar el cálculo
  void _calcularAmortizacion() {
    if (_formKey.currentState!.validate()) {
      // Obtener los valores ingresados por el usuario
      double principal = double.parse(_principalController.text);
      double tasaInteresAnual = double.parse(_tasaController.text);
      int anios = int.parse(_aniosController.text);

      // Crear una instancia de la clase CalcularAmericana
      CalcularAmericana calculadora = CalcularAmericana(
        principal: principal,
        tasaInteresAnual: tasaInteresAnual,
        anios: anios,
      );

      // Realizar el cálculo y obtener los resultados
      var resultado = calculadora.calcularAmortizacion();

      setState(() {
        _interesMensual = resultado['interesMensual'];
        _totalIntereses = resultado['totalIntereses'];
        _ultimoPago = resultado['ultimoPago'];

        // Generar la tabla de amortización
        _generarTablaAmortizacion(principal, tasaInteresAnual, anios);
      });
    }
  }

  void _generarTablaAmortizacion(
      double principal, double tasaInteresAnual, int anios) {
    double tasaMensual = tasaInteresAnual / 100 / 12;
    double interesMensual = principal * tasaMensual;
    int totalMeses = anios * 12;

    List<Map<String, dynamic>> tabla = [];

    // Generar los pagos mensuales (solo interés)
    for (int i = 1; i <= totalMeses; i++) {
      double pago = interesMensual;
      double amortizacion = i == totalMeses ? principal : 0.0;
      double cuota = pago + amortizacion;
      double saldo = i == totalMeses ? 0.0 : principal;

      tabla.add({
        'periodo': i,
        'cuota': cuota,
        'interes': pago,
        'amortizacion': amortizacion,
        'saldo': saldo,
      });
    }

    _tablaAmortizacion = tabla;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Amortización Americana'),
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
        child: Column(
          children: [
            Expanded(
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
                                  'Datos del Préstamo',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _principalController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Monto del Préstamo (Capital)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: const Icon(Icons.attach_money),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa el monto del préstamo';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _tasaController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Tasa de Interés Anual (%)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: const Icon(Icons.percent),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa la tasa de interés';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _aniosController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Duración del Préstamo (años)',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingresa la duración del préstamo';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _calcularAmortizacion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "Calcular",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_interesMensual != null)
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
                                    'Resultados',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildResultRow(
                                    'Interés Mensual:',
                                    '\$${_interesMensual!.toStringAsFixed(2)}',
                                    Icons.payments,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildResultRow(
                                    'Total de Intereses:',
                                    '\$${_totalIntereses!.toStringAsFixed(2)}',
                                    Icons.account_balance,
                                  ),
                                  const SizedBox(height: 12),
                                  _buildResultRow(
                                    'Último Pago (Capital + Interés):',
                                    '\$${_ultimoPago!.toStringAsFixed(2)}',
                                    Icons.monetization_on,
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Tabla de amortización
                        if (_tablaAmortizacion != null &&
                            _tablaAmortizacion!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              const Text(
                                'Tabla de Amortización Americana',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                height: 300,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.teal.shade200),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: DataTable(
                                      headingTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal,
                                      ),
                                      columns: const [
                                        DataColumn(label: Text('N°')),
                                        DataColumn(label: Text('Cuota')),
                                        DataColumn(label: Text('Interés')),
                                        DataColumn(label: Text('Amortización')),
                                        DataColumn(label: Text('Saldo')),
                                      ],
                                      rows: _tablaAmortizacion!.map((row) {
                                        bool esUltimoPago = row['periodo'] ==
                                            _tablaAmortizacion!.length;
                                        return DataRow(
                                          color: esUltimoPago
                                              ? MaterialStateProperty.all(
                                                  Colors.teal.withOpacity(0.1))
                                              : null,
                                          cells: [
                                            DataCell(Text('${row['periodo']}')),
                                            DataCell(Text(
                                                '\$${row['cuota'].toStringAsFixed(2)}')),
                                            DataCell(Text(
                                                '\$${row['interes'].toStringAsFixed(2)}')),
                                            DataCell(Text(
                                                '\$${row['amortizacion'].toStringAsFixed(2)}')),
                                            DataCell(Text(
                                                '\$${row['saldo'].toStringAsFixed(2)}')),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
