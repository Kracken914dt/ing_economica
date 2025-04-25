import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/amortizacion/francesa/services/calcularFrancesar.dart';
import 'dart:math' as math;

class Francesa extends StatefulWidget {
  const Francesa({super.key});

  @override
  State<Francesa> createState() => _FrancesaState();
}

class _FrancesaState extends State<Francesa> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoprestamo = TextEditingController();
  final TextEditingController _tasaInteresAnual = TextEditingController();
  final TextEditingController _plazoMeses = TextEditingController();

  double? _futureAmount;
  List<Map<String, dynamic>>? _tablaAmortizacion;
  bool _knowsExactDates = true;
  String frecuenciaSeleccionada = 'Anual';
  final Map<String, int> opcionesFrecuencia = {
    'Anual': 1,
    'Semestral': 2,
    'Cuatrimestral': 3,
    'Trimestral': 4,
    'Bimestral': 6,
    'Mensual': 12
  };

  final Calcularfrancesar _calculator = Calcularfrancesar();

  void _calculateFutureAmount() {
    if (_formKey.currentState!.validate()) {
      final double montoPrestamo = double.parse(_montoprestamo.text);
      final double tasaInteresAnual = double.parse(_tasaInteresAnual.text);
      final int plazoMeses = int.parse(_plazoMeses.text);

      setState(() {
        _futureAmount = _calculator.calculateFutureAmount(
            montoPrestamo: montoPrestamo,
            plazoMeses: plazoMeses,
            tasaInteresAnual: tasaInteresAnual);

        // Generar la tabla de amortización
        _generarTablaAmortizacion(montoPrestamo, tasaInteresAnual, plazoMeses);
      });
    }
  }

  void _generarTablaAmortizacion(
      double montoPrestamo, double tasaInteresAnual, int plazoMeses) {
    // Tasa de interés mensual
    double tasaMensual = tasaInteresAnual / 100 / 12;

    // Cuota mensual fija
    double cuotaMensual = montoPrestamo *
        tasaMensual *
        math.pow(1 + tasaMensual, plazoMeses) /
        (math.pow(1 + tasaMensual, plazoMeses) - 1);

    double saldoPendiente = montoPrestamo;
    List<Map<String, dynamic>> tabla = [];

    for (int i = 1; i <= plazoMeses; i++) {
      double interesMensual = saldoPendiente * tasaMensual;
      double amortizacionCapital = cuotaMensual - interesMensual;
      saldoPendiente -= amortizacionCapital;

      tabla.add({
        'periodo': i,
        'cuota': cuotaMensual,
        'interes': interesMensual,
        'amortizacion': amortizacionCapital,
        'saldo': saldoPendiente > 0 ? saldoPendiente : 0,
      });
    }

    _tablaAmortizacion = tabla;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo de Amortización Francesa"),
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
                                  controller: _montoprestamo,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Monto del Préstamo",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: const Icon(Icons.attach_money),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese el monto del préstamo';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _tasaInteresAnual,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Tasa de Interés Anual (%)",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon: const Icon(Icons.percent),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese la tasa de interés';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _plazoMeses,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Plazo en meses",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    prefixIcon:
                                        const Icon(Icons.calendar_today),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Por favor ingrese el plazo en meses';
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
                            onPressed: _calculateFutureAmount,
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
                        if (_futureAmount != null)
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.monetization_on,
                                    color: Colors.teal,
                                    size: 40,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Cuota Mensual: ${_calculator.formatNumber(_futureAmount!)}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal,
                                    ),
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
                                'Tabla de Amortización Francesa',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
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
                                    return DataRow(
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
}
