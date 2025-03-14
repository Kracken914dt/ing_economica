import 'package:flutter/material.dart';
import 'dart:math';

class SimpleInteres extends StatefulWidget {
  const SimpleInteres({super.key});

  @override
  _SimpleInteresState createState() => _SimpleInteresState();
}

class _SimpleInteresState extends State<SimpleInteres> {
  final _futureAmountController = TextEditingController();
  final _initialCapitalController = TextEditingController();
  final _interesGenradoController = TextEditingController();
  final _timeController = TextEditingController();

  // Controllers para las fechas exactas
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  // Controllers para día, mes, y año
  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();

  double? _interestRate;
  bool _useExactDates = false; // Para alternar entre fechas exactas o manual

  void _calculateInterestRate() {
    final futureAmount = double.tryParse(_futureAmountController.text);
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final interesGenerado = double.tryParse(_interesGenradoController.text);
    if (initialCapital == null) {
      setState(() {
        _interestRate = null;
      });
      return;
    }

    double? timeInYears;

    if (_useExactDates) {
      final startDate = DateTime.tryParse(_startDateController.text);
      final endDate = DateTime.tryParse(_endDateController.text);

      if (startDate != null && endDate != null) {
        final difference = endDate.difference(startDate).inDays;
        timeInYears = difference / 365.0;
      }
    } else {
      final days = int.tryParse(_dayController.text) ?? 0;
      final months = int.tryParse(_monthController.text) ?? 0;
      final years = int.tryParse(_yearController.text) ?? 0;

      timeInYears = years + (months / 12) + (days / 360);
      if (interesGenerado != null && initialCapital > 0) {
        final i = (interesGenerado / (initialCapital * timeInYears)) *100;
        print(i);
        print("calcula aquiiiii" );
         setState(() {
        _interestRate = i as double?;
      });
      }
    }

    if (timeInYears != null && timeInYears > 0 && futureAmount != null) {
      final rate =
          (pow(futureAmount / initialCapital, 1 / timeInYears) - 1) * 100;
      setState(() {
        _interestRate = rate as double?;
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
        controller.text =
            "${picked.toLocal()}".split(' ')[0]; // Formatear la fecha
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasa de Interés'),
        backgroundColor: Colors.teal,
        centerTitle: true,
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
                      const Text(
                        'Datos del Capital',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _futureAmountController, 
                        'Monto Futuro',
                        prefixIcon: Icons.attach_money,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _initialCapitalController, 
                        'Capital Inicial',
                        prefixIcon: Icons.attach_money,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _interesGenradoController, 
                        'Interés Generado',
                        prefixIcon: Icons.percent,
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
                        title: const Text("¿Conoces las fechas exactas?"),
                        value: _useExactDates,
                        activeColor: Colors.teal,
                        onChanged: (bool value) {
                          setState(() {
                            _useExactDates = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if (_useExactDates)
                        Column(
                          children: [
                            _buildDateField(
                              _startDateController,
                              "Fecha de Inicio",
                              Icons.calendar_today,
                            ),
                            const SizedBox(height: 16),
                            _buildDateField(
                              _endDateController,
                              "Fecha de Fin",
                              Icons.calendar_today,
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            _buildTextField(
                              _dayController,
                              'Número de días',
                              prefixIcon: Icons.calendar_today,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _monthController,
                              'Número de meses',
                              prefixIcon: Icons.calendar_today,
                            ),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _yearController,
                              'Número de años',
                              prefixIcon: Icons.calendar_today,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _calculateInterestRate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Calcular Tasa de Interés",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_interestRate != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Tasa de Interés: ${_interestRate!.toStringAsFixed(2)}%',
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

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    IconData? prefixIcon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDateField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onTap: () {
        _selectDate(context, controller);
      },
    );
  }
}
