import 'package:flutter/material.dart';
import 'package:ingeconomica/screens/unidad_valor_real/services/calculo_unidad_valor_real.dart';
import 'package:ingeconomica/screens/unidad_valor_real/views/widget.dart';

class UnidadValorRealTabla extends StatefulWidget {
  const UnidadValorRealTabla({super.key});

  @override
  UnidadValorRealTablaState createState() => UnidadValorRealTablaState();
}

class UnidadValorRealTablaState extends State<UnidadValorRealTabla> {
  final TextEditingController _valorAController = TextEditingController();
  final TextEditingController _variationController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  bool? _tablac = false;
  List<double> _uVRAmount = [];
  List<DateTime> _fechas = [];

  final UVRCalculator _calculator =
      UVRCalculator();


  void _calculateUVR() {
    final double valorA = double.parse(_valorAController.text);
    final double variacion = double.parse(_variationController.text);
    DateTime fInicio = _calculator.parseDate(_startDateController.text); DateTime fFinal = _calculator.parseDate(_endDateController.text);
    //final int numeroDias = fFinal.difference(fInicio).inDays;
    final int periodoCalculo = DateTime(fInicio.year,fInicio.month+1,fInicio.day).difference(fInicio).inDays;
    print(periodoCalculo);
    
      setState(() {
        _fechas = _calculator.createDates(fechaI: fInicio, periodo: periodoCalculo);
        _uVRAmount = _calculator.calculateListUVR(
          valorMoneda: valorA, 
          variacion: variacion, 
          periodoCalculo: periodoCalculo);
        _tablac = true;
      });
  }
  void _retornar(){
    setState(() {
      _uVRAmount =[];
      _tablac = false;
    });
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
        _endDateController.text = _calculator.formatDate(DateTime(picked.year,picked.month+1,picked.day));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Unidad de Valor Real'),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_uVRAmount.isEmpty && _tablac == false) ...[
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
                          'Datos para el cálculo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _valorAController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Unidad de Valor Real Anterior',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.attach_money),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _variationController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Variación (%)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            prefixIcon: const Icon(Icons.percent),
                          ),
                        ),
                        const SizedBox(height: 16),
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
                              onPressed: () =>
                                  _selectDate(context, _startDateController),
                            ),
                          ),
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
                    onPressed: _calculateUVR,
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
              ] else ...[
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _retornar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Asignar otros valores",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                              'Tabla de Valores UVR',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 300,
                              child: ListView(
                                children: [
                                  UVRTable(
                                    listaN: _uVRAmount
                                        .map((uVRAmount) =>
                                            _uVRAmount.lastIndexOf(uVRAmount) + 1)
                                        .toList(),
                                    listaF: _fechas
                                        .map((fecha) =>
                                            _calculator.formatDate(fecha))
                                        .toList(),
                                    listaUVR: _uVRAmount,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}