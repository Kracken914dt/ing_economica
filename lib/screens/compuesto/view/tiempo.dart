import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/compuesto/services/calcularTiempo.dart';

class Tiempo extends StatefulWidget {
  const Tiempo({super.key});

  @override
  State<Tiempo> createState() => _Tiempo();
}

class _Tiempo extends State<Tiempo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montoFuturoController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _capitalController = TextEditingController();
  //final TextEditingController _startDateController = TextEditingController();
  //final TextEditingController _endDateController = TextEditingController();
  //final TextEditingController _daysController = TextEditingController();
  //final TextEditingController _monthsController = TextEditingController();
  //final TextEditingController _yearsController = TextEditingController();
  double? _futureAmount;
  //bool _knowsExactDates = true;
  String frecuenciaSeleccionada = 'Anual';
  final Map<String, int> opcionesFrecuencia = {
    'Anual': 1,
    'Semestral': 2,
    'Cuatrimestral': 3,
    'Trimestral': 4,
    'Bimestral': 6,
    'Mensual': 12
  };

  final TiempoCalculator _calculator = TiempoCalculator();

  void _calculateFutureAmount() {
    if (_formKey.currentState!.validate()) {
      final double capital = double.parse(_capitalController.text);
      final double montofuturo = double.parse(_montoFuturoController.text);
      final double rate = double.parse(_rateController.text);
      final int veces = opcionesFrecuencia[frecuenciaSeleccionada]!;

      setState(() {
        _futureAmount = _calculator.calculateTiempo(
            capital: capital,
            interes: rate / 100,
            vecesporano: veces,
            montofuturo: montofuturo);
      });
    }
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = _calculator.formatDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cálculo del Tiempo"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _capitalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Capital Inicial",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el capital inicial';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Container(
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
                    value: frecuenciaSeleccionada,
                    onChanged: (String? nuevoValor) {
                      setState(() {
                        frecuenciaSeleccionada = nuevoValor!;
                      });
                    },
                    items: opcionesFrecuencia.keys
                        .map<DropdownMenuItem<String>>((String valor) {
                      return DropdownMenuItem<String>(
                        value: valor,
                        child: Text(valor),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _montoFuturoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Monto Futuro",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el monto futuro';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Tasa de Interés (%)",
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
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateFutureAmount,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Calcular Tiempo"),
                ),
              ),
              const SizedBox(height: 20),
              if (_futureAmount != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const Icon(
                          Icons.monetization_on,
                          color: Colors.teal,
                          size: 26,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Tiempo necesario: ${_calculator.formatNumber(_futureAmount!)} años",
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.teal,
                              ),
                            ),
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
