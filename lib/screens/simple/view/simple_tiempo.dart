import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/simple/services/interes_calculator.dart';

class SimpleTiempo extends StatefulWidget {
  const SimpleTiempo({super.key});

  @override
  _SimpleTiempoState createState() => _SimpleTiempoState();
}

class _SimpleTiempoState extends State<SimpleTiempo> {
  final _interesPagadoController = TextEditingController();
  final _initialCapitalController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _finalCapitalController = TextEditingController();
  double? _time;
  String _selectedView = 'Todos'; // Control de la vista seleccionada

  final InterestCalculator _calculator = InterestCalculator();

  void _calculateTime() {
    final interesPagado = double.tryParse(_interesPagadoController.text);
    final initialCapital = double.tryParse(_initialCapitalController.text);
    final finalCapital = double.tryParse(_finalCapitalController.text);
    final interestRate = double.tryParse(_interestRateController.text);

    double? calculatedInterest;

    if (interesPagado == null && finalCapital != null && initialCapital != null) {
      calculatedInterest = finalCapital - initialCapital;
    } else {
      calculatedInterest = interesPagado;
    }

    if (calculatedInterest != null &&
        initialCapital != null &&
        interestRate != null &&
        interestRate != 0) {
      final time = _calculator.calculateTime(
          calculatedInterest, initialCapital, interestRate);
      setState(() {
        _time = time;
      });
    } else {
      setState(() {
        _time = null;
      });
    }
  }

  Map<String, int> _convertTime(double timeInYears) {
    int years = timeInYears.floor();
    double remainingMonths = (timeInYears - years) * 12;
    int months = remainingMonths.floor();
    double remainingDays = (remainingMonths - months) * 30;
    int days = remainingDays.floor();

    return {
      'years': years,
      'months': months,
      'days': days,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcular Tiempo'),
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
                        _interesPagadoController, 
                        'Interés Pagado',
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
                        _finalCapitalController, 
                        'Capital Final',
                        prefixIcon: Icons.attach_money,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _interestRateController, 
                        'Tasa de Interés (%)',
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
                        'Formato de Visualización',
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
                            value: _selectedView,
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: 'Todos',
                                child: Text('Todos'),
                              ),
                              DropdownMenuItem(
                                value: 'Años',
                                child: Text('Años'),
                              ),
                              DropdownMenuItem(
                                value: 'Meses',
                                child: Text('Meses'),
                              ),
                              DropdownMenuItem(
                                value: 'Días',
                                child: Text('Días'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedView = value!;
                              });
                            },
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
                  onPressed: _calculateTime,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Calcular Tiempo",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_time != null)
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Tiempo: ${_time!.toStringAsFixed(2)} años',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _buildTimeText(),
                          style: const TextStyle(
                            fontSize: 16,
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

  String _buildTimeText() {
    final timeComponents = _convertTime(_time!);
    
    switch (_selectedView) {
      case 'Años':
        return '${timeComponents['years']} años';
      case 'Meses':
        return '${timeComponents['months']} meses';
      case 'Días':
        return '${timeComponents['days']} días';
      default:
        return '${timeComponents['years']} años, ${timeComponents['months']} meses, ${timeComponents['days']} días';
    }
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
}
