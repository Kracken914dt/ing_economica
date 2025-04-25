import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class LoanWidget extends StatefulWidget {
  final Function(double) onLoanMade;

  const LoanWidget({super.key, required this.onLoanMade});

  @override
  _LoanWidgetState createState() => _LoanWidgetState();
}

class _LoanWidgetState extends State<LoanWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _termController = TextEditingController();

  String _loanType = "simple";
  String _amortizationType = "francesa";
  List<double> _monthlyPayments = [];
  DateTime? _endDate;

  void _calculateLoan() {
    double amount = double.tryParse(_amountController.text) ?? 0;
    double rate = (double.tryParse(_rateController.text) ?? 0) / 100;
    int term = int.tryParse(_termController.text) ?? 0;

    if (amount > 0 && rate > 0 && term > 0) {
      _monthlyPayments.clear();

      if (_loanType == "simple") {
        if (_amortizationType == "francesa") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    "Amortización Francesa no es compatible con interés Simple")),
          );
          return;
        }
        double totalAmount = amount * (1 + rate * term);
        _monthlyPayments.add(totalAmount / (term * 12));
      } else {
        double totalAmount = amount * pow((1 + rate / 12), 12 * term);
        switch (_amortizationType) {
          case "francesa":
            double monthlyRate = rate / 12;
            int totalPayments = term * 12;
            double monthlyPayment = amount *
                monthlyRate /
                (1 - pow(1 + monthlyRate, -totalPayments));
            for (int i = 0; i < totalPayments; i++) {
              _monthlyPayments.add(monthlyPayment);
            }
            break;
          case "alemana":
            double germanBasePayment = amount / (term * 12);
            for (int i = 0; i < term * 12; i++) {
              double interestPayment =
                  (amount - (i * germanBasePayment)) * rate / 12;
              _monthlyPayments.add(germanBasePayment + interestPayment);
            }
            break;
          case "americana":
            for (int i = 0; i < term * 12; i++) {
              _monthlyPayments.add(amount * (rate / 12));
            }
            break;
        }
      }

      _endDate = DateTime.now().add(Duration(days: term * 365));
      widget.onLoanMade(amount);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingrese valores válidos")),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Préstamo'),
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
                          'Datos del Préstamo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Monto del Préstamo",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _rateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Tasa de Interés Anual (%)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.percent),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _termController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Plazo (años)",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tipo de Interés',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text("Simple"),
                                value: "simple",
                                groupValue: _loanType,
                                activeColor: Colors.teal,
                                onChanged: (String? value) {
                                  setState(() {
                                    _loanType = value ?? "simple";
                                    if (_loanType == "simple" &&
                                        _amortizationType == "francesa") {
                                      _amortizationType = "alemana";
                                    }
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<String>(
                                title: const Text("Compuesto"),
                                value: "compuesto",
                                groupValue: _loanType,
                                activeColor: Colors.teal,
                                onChanged: (String? value) {
                                  setState(() {
                                    _loanType = value ?? "simple";
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Tipo de Amortización',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
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
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _amortizationType,
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _amortizationType = newValue!;
                                });
                              },
                              items: <String>['francesa', 'alemana', 'americana']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value.capitalizeFirstOfEach),
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
                    onPressed: _calculateLoan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Realizar Préstamo",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_monthlyPayments.isNotEmpty)
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
                            'Detalle del Préstamo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _monthlyPayments.length > 6
                                ? 6
                                : _monthlyPayments.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Cuota ${index + 1}:",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "\$${_monthlyPayments[index].toStringAsFixed(2)}",
                                      style: const TextStyle(color: Colors.teal),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          if (_monthlyPayments.length > 6) ...[
                            const Divider(),
                            Center(
                              child: Text(
                                "... y ${_monthlyPayments.length - 6} cuotas más",
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ),
                          ],
                          const Divider(),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Fecha de finalización:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _endDate != null
                                    ? DateFormat('dd/MM/yyyy').format(_endDate!)
                                    : '',
                                style: const TextStyle(color: Colors.teal),
                              ),
                            ],
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

// Extensión para capitalizar el primer carácter de cada palabra
extension StringExtension on String {
  String get capitalizeFirstOfEach {
    return this.split(' ').map((word) {
      return word.length > 0
          ? '${word[0].toUpperCase()}${word.substring(1)}'
          : '';
    }).join(' ');
  }
}
