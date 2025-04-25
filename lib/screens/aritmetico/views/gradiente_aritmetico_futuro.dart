import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/aritmetico/services/calculo_gradiente_aritmetico.dart';

class ValorFuturo extends StatefulWidget {
  const ValorFuturo({super.key});

  @override
  _ValorFuturoState createState() => _ValorFuturoState();
}

class _ValorFuturoState extends State<ValorFuturo> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _capitalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _gradienteController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _monthsController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  String _selectedOption = "Creciente";
  String _selectedOption2 = "Valor Futuro";
  String _selectedOption3 = "Mensual";
  String _answerText = "Valor Futuro";

  double? _futureAmount;

  final GradienteACalculator _calculator = GradienteACalculator();

  void _calculateFutureValue() {
    if (_formKey.currentState!.validate()) {
      final double capital = double.parse(_capitalController.text);
      final double rate = double.parse(_rateController.text);
      final double gradient = double.parse(_gradienteController.text);
      final double year = double.parse(_yearsController.text);
      final double month = double.parse(_monthsController.text);
      final double day = double.parse(_daysController.text);
      final double period = _calculator.calculatePeriod(
          days: day, months: month, years: year, mcuota: _selectedOption3);
      final bool perfil = (_selectedOption == "Creciente") ? true : false;

      if (_selectedOption2 == "Valor Futuro") {
        if (period != 0) {
          setState(() {
            _answerText = _selectedOption2;
            _futureAmount = _calculator.calculateFutureValue(
                pago: capital,
                gradiente: gradient,
                periodos: period,
                interes: rate,
                perfil: perfil);
          });
        } else {
          setState(() {
            _futureAmount = null;
          });
        }
      } else {
        if (period != 0) {
          setState(() {
            _answerText = _selectedOption2;
            _futureAmount = _calculator.calculateFirtsPaymentFutureValue(
                future: capital,
                gradiente: gradient,
                periodos: period,
                interes: rate,
                perfil: perfil);
          });
        } else {
          setState(() {
            _futureAmount = null;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de $_selectedOption2'),
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
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.show_chart,
                      size: 48,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Cálculo del $_selectedOption2",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildDropdown(
                      value: _selectedOption2,
                      items: ['Valor Futuro', 'Valor Primera Cuota'],
                      label: 'Tipo de cálculo',
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption2 = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _capitalController,
                      label: (_selectedOption2 == "Valor Futuro")
                          ? 'Valor Primera Cuota'
                          : 'Valor Futuro',
                      icon: Icons.attach_money,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _rateController,
                      label: 'Interes (%)',
                      icon: Icons.percent,
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _gradienteController,
                      label: 'Gradiente',
                      icon: Icons.trending_up,
                    ),
                    const SizedBox(height: 24),
                    _buildDropdown(
                      value: _selectedOption3,
                      items: ['Mensual', 'Anual'],
                      label: 'Período',
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption3 = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _daysController,
                            label: "Días",
                            icon: Icons.calendar_today,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _monthsController,
                            label: "Meses",
                            icon: Icons.calendar_month,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            controller: _yearsController,
                            label: "Años",
                            icon: Icons.date_range,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildDropdown(
                      value: _selectedOption,
                      items: ['Creciente', 'Decreciente'],
                      label: 'Tipo de gradiente',
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildCalculateButton(),
                    const SizedBox(height: 24),
                    if (_futureAmount != null) _buildResultCard(),
                  ],
                ),
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
    required String label,
    required void Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 8),
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
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(icon, color: Colors.teal),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese el $label';
        }
        return null;
      },
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
        onPressed: _calculateFutureValue,
        icon: const Icon(Icons.calculate, size: 24),
        label: Text(
          "Calcular $_selectedOption2",
          style: const TextStyle(
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
              Text(
                _answerText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _calculator.formatNumber(_futureAmount!),
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.teal.shade700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
