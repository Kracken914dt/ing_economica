import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/alternativa_inversion/services/calculo_eai.dart';
import 'package:ingeconomica/screens/aritmetico/views/widget.dart';

class EvaluacionAlternativaInversionVPN extends StatefulWidget {
  const EvaluacionAlternativaInversionVPN({super.key});

  @override
  EvaluacionAlternativaInversionVPNState createState() => EvaluacionAlternativaInversionVPNState();
}

class EvaluacionAlternativaInversionVPNState extends State<EvaluacionAlternativaInversionVPN> {
  final TextEditingController _valorFCController = TextEditingController();
  final TextEditingController _valorIController = TextEditingController();
  final TextEditingController _tasaDController = TextEditingController();
  double? _eAIResult;
  String? _selectedOption2 = "Valor Presente Neto";
  String? _answerText = "Valor Presente Neto";
  List<double> fcaja = [];
  final EAICalculator _calculator = EAICalculator();

  void _calculateEAI() {
    final double invInicial = double.parse(_valorIController.text);
    final double tasadescuento = double.parse(_tasaDController.text);

    if (_selectedOption2 == "Valor Presente Neto") {
      setState(() {
        _answerText = _selectedOption2;
        _eAIResult = _calculator.calcularVPN(
          fcaja: fcaja, 
          tasadescuento: tasadescuento, 
          invInicial: invInicial);
      });
    } else {
      final double vpn = _calculator.calcularVPN(
        fcaja: fcaja, 
        tasadescuento: tasadescuento, 
        invInicial: invInicial);
      setState(() {
        _answerText = _selectedOption2;
        _eAIResult = _calculator.calculateIR(
          vpn: vpn, 
          invInicial: invInicial);
      });
    }
  }

  void _addFlujoCaja() {
    if (_valorFCController.text.isNotEmpty) {
      setState(() {
        fcaja.add(double.parse(_valorFCController.text));
        _valorFCController.text = "";
      });
    }
  }

  void _removeFlujoCaja(int caja) {
    setState(() {
      fcaja.removeAt(caja);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora del $_selectedOption2'),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
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
                          'Tipo de Evaluación',
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
                              value: _selectedOption2,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedOption2 = newValue!;
                                });
                              },
                              items: <String>[
                                'Valor Presente Neto',
                                'Indice de Rentabilidad',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _valorFCController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Flujo de Caja',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  prefixIcon: const Icon(Icons.trending_up),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: _addFlujoCaja,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        if (fcaja.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Flujos de Caja Añadidos',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 70,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: fcaja.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                  key: ObjectKey(fcaja.length - index),
                                  onDismissed: (direccion) {
                                    _removeFlujoCaja(index);
                                  },
                                  child: Card(
                                    color: Colors.teal.shade50,
                                    margin: const EdgeInsets.all(5),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${fcaja[index]}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Text(
                                            'Desliza para eliminar',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _valorIController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Inversión Inicial',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _tasaDController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Tasa de Descuento (%)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.percent),
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
                    onPressed: fcaja.isNotEmpty ? _calculateEAI : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: Text(
                      "Calcular",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_eAIResult != null)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            _answerText == "Valor Presente Neto" ? Icons.bar_chart : Icons.trending_up,
                            color: Colors.teal,
                            size: 40,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '(E.A.I) ${(_answerText == "Valor Presente Neto") ? 'VPN' : 'IR'}: ${_eAIResult!.toStringAsFixed(4)}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _eAIResult! > 0 
                                ? 'Proyecto Financieramente Viable' 
                                : 'Proyecto Financieramente No Viable',
                            style: TextStyle(
                              fontSize: 14,
                              color: _eAIResult! > 0 ? Colors.green : Colors.red,
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