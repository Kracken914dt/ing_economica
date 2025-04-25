import 'package:flutter/material.dart';
import '../services/geometric_gradient_calculator.dart';

class GeometricValueCalculator extends StatefulWidget {
  const GeometricValueCalculator({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GeometricValueCalculatorState createState() =>
      _GeometricValueCalculatorState();
}

class _GeometricValueCalculatorState extends State<GeometricValueCalculator> {
  final _seriePagosController = TextEditingController();
  final _variacionController = TextEditingController();
  final _interesController = TextEditingController();
  final _periodosController = TextEditingController();

  String _valueType = 'Valor Presente'; // Default value
  String _growthType = 'Creciente'; // Default value
  double? _calculatedValue;

  void _calculateValue() {
    final double? A = double.tryParse(_seriePagosController.text);
    final double? G = double.tryParse(_variacionController.text);
    final double? i = double.tryParse(_interesController.text);
    final int? n = int.tryParse(_periodosController.text);

    // Verifica si alguna entrada no es válida
    if (A == null || G == null || i == null || n == null) {
      setState(() {
        _calculatedValue = null; // No mostrar resultado si hay un error
      });
      // Muestra un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, ingresa valores válidos.'),
        ),
      );
      return;
    }

    final calculator = GeometricGradientCalculator();
    double result;

    if (_valueType == 'Valor Presente') {
      if (_growthType == 'Creciente') {
        result =
            calculator.calculateValorPresenteCreciente(A: A, G: G, i: i, n: n);
      } else {
        result = calculator.calculateValorPresenteDecreciente(
            A: A, G: G, i: i, n: n);
      }
    } else {
      if (_growthType == 'Creciente') {
        result =
            calculator.calculateValorFuturoCreciente(A: A, G: G, i: i, n: n);
      } else {
        result =
            calculator.calculateValorFuturoDecreciente(A: A, G: G, i: i, n: n);
      }
    }

    setState(() {
      _calculatedValue = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Valor Geométrico'),
        backgroundColor: Colors.teal,
        centerTitle: true,
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
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(
                    Icons.show_chart,
                    size: 48,
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Cálculo de Valor Geométrico",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDropdown(
                    value: _valueType,
                    items: ['Valor Presente', 'Valor Futuro'],
                    onChanged: (newValue) {
                      setState(() {
                        _valueType = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildDropdown(
                    value: _growthType,
                    items: ['Creciente', 'Decreciente'],
                    onChanged: (newValue) {
                      setState(() {
                        _growthType = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // Input fields for A, G, i, n
                  _buildTextField(
                      _seriePagosController, 'Serie de Pagos (A)', Icons.money),
                  const SizedBox(height: 24),
                  _buildTextField(
                      _variacionController, 'Variación (G)', Icons.trending_up),
                  const SizedBox(height: 24),
                  _buildTextField(
                      _interesController, 'Tasa de Interés (i)', Icons.percent),
                  const SizedBox(height: 24),
                  _buildTextField(_periodosController, 'Número de Periodos (n)',
                      Icons.date_range),
                  const SizedBox(height: 24),
                  _buildCalculateButton(),
                  const SizedBox(height: 24),
                  if (_calculatedValue != null) _buildResultCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFEF7FF),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(icon),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCalculateButton() {
    return Container(
      width: 280,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [Colors.teal.shade700, Colors.teal],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _calculateValue,
        icon: const Icon(Icons.calculate, size: 24),
        label: const Text(
          'Calcular',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.teal.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Resultado',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  )),
              const SizedBox(height: 10),
              Text('\$${_calculatedValue!.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal.shade700,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
