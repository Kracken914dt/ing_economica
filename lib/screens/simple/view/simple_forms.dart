import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/simple/services/interes_calculator.dart';

class SimpleForms extends StatefulWidget {
  const SimpleForms({super.key});

  @override
  State<SimpleForms> createState() => _SimpleFormsState();
}

class _SimpleFormsState extends State<SimpleForms> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _finalCapitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  double? _result;
  bool _knowsExactDates = true;
  String _selectedOption = 'Monto futuro';
  final InterestCalculator _calculator = InterestCalculator();

  void _calculate() {
    if (_formKey.currentState!.validate()) {
      final double? capital = _capitalController.text.isNotEmpty
          ? double.tryParse(_capitalController.text)
          : null;
      final double? finalCapital = _finalCapitalController.text.isNotEmpty
          ? double.tryParse(_finalCapitalController.text)
          : null;
      final double rate = double.parse(_rateController.text);
      DateTime startDate;
      DateTime endDate;

      if (_knowsExactDates) {
        startDate = _calculator.parseDate(_startDateController.text);
        endDate = _calculator.parseDate(_endDateController.text);
      } else {
        final int days = int.tryParse(_daysController.text) ?? 0;
        final int months = int.tryParse(_monthsController.text) ?? 0;
        final int years = int.tryParse(_yearsController.text) ?? 0;
        startDate = DateTime.now();
        endDate =
            startDate.add(Duration(days: days + months * 30 + years * 360));
      }

      setState(() {
        if (capital != null && finalCapital == null) {
          if (_selectedOption == 'Monto futuro') {
            _result = _calculator.calculateFutureAmount(
              capital: capital,
              rate: rate,
              startDate: startDate,
              endDate: endDate,
            );
          } else if (_selectedOption == 'Interés') {
            //final double time = endDate.difference(startDate).inDays / 365;
            final double years =
                int.tryParse(_yearsController.text)?.toDouble() ?? 0;
            final double months =
                (int.tryParse(_monthsController.text)?.toDouble() ?? 0) / 12;
            final double days =
                (int.tryParse(_daysController.text)?.toDouble() ?? 0) / 360;
            final double totalTime = years + months + days;
            _result = (capital * (rate / 100)) * totalTime;
          } else if (_selectedOption == 'Capital') {
            final double time = endDate.difference(startDate).inDays / 360;
            final tiempo = int.tryParse(_yearsController.text) ??
                int.tryParse(_monthsController.text) ??
                int.tryParse(_daysController.text) ??
                time;
            _result = (capital / ((rate / 100) * tiempo));
          }
        } else if (capital == null && finalCapital != null) {
          if (_selectedOption == 'Principal prestamo') {
            _result = _calculator.calculateInitialCapitalPrestamo(
              finalCapital: finalCapital,
              rate: rate,
              tiempo: int.tryParse(_yearsController.text) ??
                  int.tryParse(_monthsController.text) ??
                  int.tryParse(_daysController.text) ??
                  0,
              startDate: startDate,
              endDate: endDate,
            );
          } else {
            final initialCapital = _calculator.calculateInitialCapital(
              finalCapital: finalCapital,
              rate: rate,
              tiempo: int.tryParse(_yearsController.text) ??
                  int.tryParse(_monthsController.text) ??
                  int.tryParse(_daysController.text) ??
                  0,
              startDate: startDate,
              endDate: endDate,
            );
            _result = initialCapital;
          }
        }
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
        title: const Text("Cálculo del Monto"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
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
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _finalCapitalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Capital Final",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                          validator: (value) {
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
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
                          'Período de Tiempo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SwitchListTile(
                          title: const Text("¿Conoce las fechas exactas del crédito?"),
                          value: _knowsExactDates,
                          activeColor: Colors.teal,
                          onChanged: (bool value) {
                            setState(() {
                              _knowsExactDates = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        if (_knowsExactDates) ...[
                          TextFormField(
                            controller: _startDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Fecha de Inicio",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () => _selectDate(context, _startDateController),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la fecha de inicio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _endDateController,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Fecha de Finalización",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () => _selectDate(context, _endDateController),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Por favor ingrese la fecha de finalización';
                              }
                              return null;
                            },
                          ),
                        ] else ...[
                          TextFormField(
                            controller: _daysController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Número de Días",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _monthsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Número de Meses",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _yearsController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Número de Años",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              prefixIcon: const Icon(Icons.calendar_today),
                            ),
                          ),
                        ],
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
                          'Tipo de Cálculo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedOption,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedOption = newValue!;
                                });
                              },
                              items: <String>[
                                'Monto futuro',
                                'Monto inicial',
                                'Interés',
                                'Principal prestamo',
                                'Capital'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
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
                    onPressed: _calculate,
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
                if (_result != null)
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            "$_selectedOption: ${_calculator.formatNumber(_result!)}",
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
      ),
    );
  }
}