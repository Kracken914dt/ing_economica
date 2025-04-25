import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/tir/services/calcular_tir.dart'; // Asegúrate de que la ruta sea correcta según tu estructura de carpetas

class TIRView extends StatefulWidget {
  @override
  _TIRViewState createState() => _TIRViewState();
}

class _TIRViewState extends State<TIRView> {
  final _formKey = GlobalKey<FormState>();
  final CalcularTIR _tirCalculator = CalcularTIR();

  // Controladores para los campos de entrada
  final TextEditingController _inversionController = TextEditingController();
  final TextEditingController _flujosController = TextEditingController();

  String _metodoSeleccionado = 'Calcular TIR';
  double? _resultadoTIR;

  // Limpia los campos después de un cálculo
  void _clearFields() {
    _inversionController.clear();
    _flujosController.clear();
    setState(() {
      _resultadoTIR = null;
    });
  }

  // Realiza el cálculo según el método seleccionado
  void _calcularTIR() {
    if (_formKey.currentState!.validate()) {
      double inversionInicial = double.parse(_inversionController.text);
      List<double> flujos = _flujosController.text
          .split(',')
          .map((f) => double.parse(f.trim()))
          .toList();

      setState(() {
        if (_metodoSeleccionado == 'Calcular TIR') {
          _resultadoTIR = _tirCalculator.calcularTIR(flujos, inversionInicial);
        } else if (_metodoSeleccionado == 'Prueba y Error') {
          _resultadoTIR =
              _tirCalculator.calcularTIRPruebaError(flujos, inversionInicial);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de TIR'),
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
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
                          Icons.trending_up,
                          size: 48,
                          color: Colors.teal,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Tasa Interna de Retorno",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Campo para inversión inicial
                        _buildTextField(
                          controller: _inversionController,
                          label: 'Inversión Inicial',
                          icon: Icons.attach_money,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese la inversión inicial';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Campo para flujos de caja
                        _buildTextField(
                          controller: _flujosController,
                          label:
                              'Flujos de caja (separados por comas, ej: 3000,4000)',
                          icon: Icons.trending_up,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese los flujos de caja';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        // Selector del método de cálculo
                        _buildDropdown(),
                        const SizedBox(height: 24),
                        _buildCalculateButton(),
                        const SizedBox(height: 20),
                        if (_resultadoTIR != null) _buildResultCard(),
                        const SizedBox(height: 20),
                        _buildClearButton(),
                      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(icon),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdown() {
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
        child: DropdownButtonFormField<String>(
          value: _metodoSeleccionado,
          decoration: const InputDecoration(
            labelText: 'Método de Cálculo',
            border: InputBorder.none,
          ),
          items: ['Calcular TIR', 'Prueba y Error']
              .map((metodo) => DropdownMenuItem(
                    value: metodo,
                    child: Text(metodo),
                  ))
              .toList(),
          onChanged: (String? value) {
            setState(() {
              _metodoSeleccionado = value!;
            });
          },
        ),
      ),
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
        onPressed: _calcularTIR,
        icon: const Icon(Icons.calculate, size: 24),
        label: const Text(
          'Calcular TIR',
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

  Widget _buildClearButton() {
    return Container(
      width: 280,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [Colors.red.shade700, Colors.red],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: _clearFields,
        icon: const Icon(Icons.clear, size: 24),
        label: const Text(
          'Limpiar Campos',
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
              const Text('Resultado TIR',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  )),
              const SizedBox(height: 10),
              Text('${_resultadoTIR!.toStringAsFixed(2)}%',
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
