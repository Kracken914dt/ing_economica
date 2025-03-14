import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/anualidades/services/anualidades.dart';

class AnualidadesScreen extends StatefulWidget {
  @override
  _AnualidadesScreenState createState() => _AnualidadesScreenState();
}

class _AnualidadesScreenState extends State<AnualidadesScreen> {
  final TextEditingController _pagoController = TextEditingController();
  final TextEditingController _tasaController = TextEditingController();
  final TextEditingController _duracionController = TextEditingController();
  
  double _valorFuturo = 0.0;
  double _valorPresente = 0.0;

  String _frecuenciaCapitalizacion = 'Anual';
  String _frecuenciaPago = 'Mensual';

  void _calcularValores() {
    double pago = double.parse(_pagoController.text);
    double tasa = double.parse(_tasaController.text);
    int duracion = int.parse(_duracionController.text);

    var calculadora = AnualidadCalculator();
    
    // Obtener los factores
    double factorCapitalizacion = getCapitalizationFactor(_frecuenciaCapitalizacion);
    double factorPago = getPaymentFrequencyFactor(_frecuenciaPago);
    
    // Calcular el valor futuro
    _valorFuturo = calculadora.calcularValorFuturoOrdinaria(
      pago: pago,
      tasaInteres: tasa,
      periodos: duracion,
    );

    // Calcular el valor presente
    _valorPresente = calculadora.calcularValorPresenteOrdinaria(
      pago: pago * factorPago / factorCapitalizacion,
      tasaInteres: tasa / factorCapitalizacion,
      periodos: (duracion * factorCapitalizacion).round(),
    );

    // Mostrar los valores en la consola
    print('=== CÁLCULO DE ANUALIDADES ===');
    print('Datos de entrada:');
    print('- Pago (A): \$$pago');
    print('- Tasa de interés: $tasa%');
    print('- Duración: $duracion años');
    print('- Frecuencia de capitalización: $_frecuenciaCapitalizacion');
    print('- Frecuencia de pago: $_frecuenciaPago');
    print('\nFactores:');
    print('- Factor de capitalización: $factorCapitalizacion');
    print('- Factor de pago: $factorPago');
    print('\nResultados:');
    print('- Valor Futuro: \$${_valorFuturo.toStringAsFixed(2)}');
    print('- Valor Presente: \$${_valorPresente.toStringAsFixed(2)}');
    print('============================');

    setState(() {});
  }

  double getCapitalizationFactor(String capitalization) {
    switch (capitalization) {
      case 'Anual':
        return 1;
      case 'Semestral':
        return 2;
      case 'Trimestral':
        return 4;
      case 'Cuatrimestral':
        return 3;
      case 'Mensual':
        return 12;
      default:
        return 1;
    }
  }

  double getPaymentFrequencyFactor(String paymentFrequency) {
    switch (paymentFrequency) {
      case 'Anual':
        return 1;
      case 'Semestral':
        return 2;
      case 'Trimestral':
        return 4;
      case 'Cuatrimestral':
        return 3;
      case 'Mensual':
        return 12;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Anualidades'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _pagoController,
                        decoration: InputDecoration(
                          labelText: 'Pago (A)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _tasaController,
                        decoration: InputDecoration(
                          labelText: 'Tasa de interés anual (%)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.percent),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _duracionController,
                        decoration: InputDecoration(
                          labelText: 'Duración (años)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Frecuencia de Capitalización',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: _frecuenciaCapitalizacion,
                          isExpanded: true,
                          underline: Container(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _frecuenciaCapitalizacion = newValue!;
                            });
                          },
                          items: <String>['Anual', 'Semestral', 'Trimestral', 'Cuatrimestral', 'Mensual']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Frecuencia de Pago',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: _frecuenciaPago,
                          isExpanded: true,
                          underline: Container(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _frecuenciaPago = newValue!;
                            });
                          },
                          items: <String>['Anual', 'Semestral', 'Trimestral', 'Cuatrimestral', 'Mensual']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
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
                  onPressed: _calcularValores,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Calcular Valores',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Valor Futuro: \$${_valorFuturo.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Valor Presente: \$${_valorPresente.toStringAsFixed(2)}',
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
            ],
          ),
        ),
      ),
    );
  }
}
