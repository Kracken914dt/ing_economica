import 'package:flutter/material.dart';

class Inflacion extends StatefulWidget {
  const Inflacion({super.key});

  @override
  _InflacionState createState() => _InflacionState();
}

class _InflacionState extends State<Inflacion> {
  final TextEditingController _ipcInicialController = TextEditingController();
  final TextEditingController _ipcFinalController = TextEditingController();
  final TextEditingController _tasasMensualesController =
      TextEditingController();

  double _resultado = 0;
  String _tipoCalculo = 'Inflación Anual';

  void _calcular() {
    switch (_tipoCalculo) {
      case 'Inflación Anual':
        _calcularInflacionAnual();
        break;

      case 'Inflación Acumulada':
        _calcularInflacionAcumulada();
        break;

      case 'Inflación Mensual':
        _calcularInflacionMensual();
        break;
    }
    setState(() {});
  }

  void _calcularInflacionAnual() {
    final double ipcInicial = double.tryParse(_ipcInicialController.text) ?? 0;
    final double ipcFinal = double.tryParse(_ipcFinalController.text) ?? 0;
    _resultado = (ipcInicial > 0 && ipcFinal > 0)
        ? ((ipcFinal - ipcInicial) / ipcInicial) * 100
        : 0;
  }

  void _calcularInflacionAcumulada() {
    final tasasStr = _tasasMensualesController.text
        .split(',')
        .map((e) => double.tryParse(e.trim()) ?? 0)
        .toList();
    double tasaAcumulada =
        tasasStr.fold(1, (acc, tasa) => acc * (1 + tasa / 100));
    _resultado = (tasaAcumulada - 1) * 100;
  }

  void _calcularInflacionMensual() {
    final double ipcActual = double.tryParse(_ipcFinalController.text) ?? 0;
    final double ipcAnterior = double.tryParse(_ipcInicialController.text) ?? 0;
    _resultado = (ipcAnterior > 0 && ipcActual > 0)
        ? (((ipcActual / ipcAnterior) - 1) * 100)
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cálculo de Inflación'),
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
                    children: [
                      const Icon(
                        Icons.trending_up,
                        size: 48,
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Cálculo de Inflación",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildDropdown(),
                      const SizedBox(height: 20),
                      _buildInputFields(),
                      const SizedBox(height: 20),
                      _buildCalculateButton(),
                      const SizedBox(height: 20),
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
          value: _tipoCalculo,
          items: <String>[
            'Inflación Anual',
            'Inflación Acumulada',
            'Inflación Mensual'
          ]
              .map((String value) =>
                  DropdownMenuItem(value: value, child: Text(value)))
              .toList(),
          onChanged: (newValue) {
            setState(() {
              _tipoCalculo = newValue!;
              _ipcInicialController.clear();
              _ipcFinalController.clear();
              _tasasMensualesController.clear();
              _resultado = 0; // Reset result when changing calculation type
            });
          },
        ),
      ),
    );
  }

  Widget _buildInputFields() {
    if (_tipoCalculo == 'Inflación Anual') {
      return Column(
        children: [
          _buildRoundedTextField(_ipcInicialController, 'IPC Inicial',
              'Ingrese el IPC del período anterior'),
          const SizedBox(height: 10),
          _buildRoundedTextField(_ipcFinalController, 'IPC Final',
              'Ingrese el IPC del período actual'),
        ],
      );
    } else if (_tipoCalculo == 'Inflación Acumulada') {
      return _buildRoundedTextField(_tasasMensualesController,
          'Tasas Mensuales (separadas por comas)', 'Ej: 1.5, 2.0, 1.7');
    } else if (_tipoCalculo == 'Inflación Mensual') {
      return Column(
        children: [
          _buildRoundedTextField(_ipcInicialController, 'IPC Anterior',
              'Ingrese el IPC del período anterior'),
          const SizedBox(height: 10),
          _buildRoundedTextField(_ipcFinalController, 'IPC Actual',
              'Ingrese el IPC del período actual'),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildRoundedTextField(
      TextEditingController controller, String label, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        prefixIcon: const Icon(Icons.attach_money),
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
        onPressed: _calcular,
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
              Text('${_resultado.toStringAsFixed(2)}%',
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

  @override
  void dispose() {
    _ipcInicialController.dispose();
    _ipcFinalController.dispose();
    _tasasMensualesController.dispose();
    super.dispose();
  }
}
