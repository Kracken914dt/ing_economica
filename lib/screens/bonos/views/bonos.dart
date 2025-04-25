import 'package:flutter/material.dart';
import 'dart:math';

class Bono {
  final double valorNominal;
  final double tasaCupon;
  final double tasaRendimiento;
  final int anos;
  final int diasDevengados;
  final int periodoCupon;

  Bono({
    required this.valorNominal,
    required this.tasaCupon,
    required this.tasaRendimiento,
    required this.anos,
    required this.diasDevengados,
    required this.periodoCupon,
  });

  double calcularPrecio() {
    double precio = 0.0;
    double pagoCupon = valorNominal * tasaCupon;

    for (int t = 1; t <= anos * (360 / periodoCupon); t++) {
      precio += pagoCupon / pow(1 + tasaRendimiento, t * periodoCupon / 360);
    }

    precio += valorNominal / pow(1 + tasaRendimiento, anos);

    return precio;
  }

  double calcularPrecioSucio() {
    double precioSucio = 0.0;
    double cupon = valorNominal * tasaCupon * periodoCupon / 360;
    int totalCupones = anos * (360 ~/ periodoCupon);

    for (int i = 1; i <= totalCupones; i++) {
      precioSucio += cupon / pow(1 + tasaRendimiento, i * periodoCupon / 360);
    }

    precioSucio += valorNominal /
        pow(1 + tasaRendimiento, totalCupones * periodoCupon / 360);

    return precioSucio;
  }

  double calcularInteresDevengado() {
    double cupon = valorNominal * tasaCupon * periodoCupon / 360;
    return cupon * diasDevengados / 360;
  }

  double calcularPrecioLimpio() {
    return calcularPrecioSucio() - calcularInteresDevengado();
  }
}

class Bonos extends StatefulWidget {
  const Bonos({super.key});

  @override
  _BonosState createState() => _BonosState();
}

class _BonosState extends State<Bonos> {
  final TextEditingController _valorNominalController = TextEditingController();
  final TextEditingController _tasaCuponController = TextEditingController();
  final TextEditingController _tasaRendimientoController =
      TextEditingController();
  final TextEditingController _anosController = TextEditingController();
  final TextEditingController _diasDevengadosController =
      TextEditingController();
  final TextEditingController _periodoCuponController = TextEditingController();

  double _resultado = 0.0;
  String _opcionSeleccionada = 'Precio del Bono';
  final List<String> _opciones = [
    'Precio del Bono',
    'Precio Sucio',
    'Interés Devengado',
    'Precio Limpio'
  ];

  void _calcularValores() {
    final valorNominal = double.tryParse(_valorNominalController.text);
    final tasaCupon = double.tryParse(_tasaCuponController.text)! / 100;
    final tasaRendimiento =
        double.tryParse(_tasaRendimientoController.text)! / 100;
    final anos = int.tryParse(_anosController.text);
    final diasDevengados = int.tryParse(_diasDevengadosController.text);
    final periodoCupon = int.tryParse(_periodoCuponController.text);

    if (valorNominal != null &&
        anos != null &&
        diasDevengados != null &&
        periodoCupon != null) {
      final bono = Bono(
        valorNominal: valorNominal,
        tasaCupon: tasaCupon,
        tasaRendimiento: tasaRendimiento,
        anos: anos,
        diasDevengados: diasDevengados,
        periodoCupon: periodoCupon,
      );

      setState(() {
        switch (_opcionSeleccionada) {
          case 'Precio del Bono':
            _resultado = bono.calcularPrecio();
            break;
          case 'Precio Sucio':
            _resultado = bono.calcularPrecioSucio();
            break;
          case 'Interés Devengado':
            _resultado = bono.calcularInteresDevengado();
            break;
          case 'Precio Limpio':
            _resultado = bono.calcularPrecioLimpio();
            break;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Bonos'),
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
          child: Column(
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
                      const Center(
                        child: Icon(
                          Icons.account_balance,
                          size: 48,
                          color: Colors.teal,
                        ),
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            "Cálculo de Bonos",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(_valorNominalController,
                          'Valor Nominal del Bono', Icons.attach_money),
                      const SizedBox(height: 16),
                      _buildTextField(_tasaCuponController, 'Tasa de Cupón (%)',
                          Icons.percent),
                      const SizedBox(height: 16),
                      _buildTextField(
                          _tasaRendimientoController,
                          'Tasa de Rendimiento Requerida (%)',
                          Icons.trending_up),
                      const SizedBox(height: 16),
                      _buildTextField(_anosController,
                          'Años hasta el Vencimiento', Icons.calendar_today),
                      const SizedBox(height: 16),
                      _buildTextField(_diasDevengadosController,
                          'Días Devengados', Icons.date_range),
                      const SizedBox(height: 16),
                      _buildTextField(_periodoCuponController,
                          'Periodo del Cupón (días)', Icons.access_time),
                      const SizedBox(height: 24),
                      _buildDropdown(),
                      const SizedBox(height: 24),
                      Center(child: _buildCalculateButton()),
                      const SizedBox(height: 24),
                      _buildResultCard(),
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
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: Icon(icon),
      ),
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
        child: DropdownButton<String>(
          isExpanded: true,
          value: _opcionSeleccionada,
          items: _opciones.map((String opcion) {
            return DropdownMenuItem<String>(
              value: opcion,
              child: Text(opcion),
            );
          }).toList(),
          onChanged: (String? nuevaOpcion) {
            setState(() {
              _opcionSeleccionada = nuevaOpcion!;
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
        onPressed: _calcularValores,
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
              Text('\$${_resultado.toStringAsFixed(2)}',
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
