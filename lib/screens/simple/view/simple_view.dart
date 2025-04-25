import 'package:flutter/material.dart';

class SimpleView extends StatelessWidget {
  const SimpleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interés Simple'),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Tarjeta de fórmulas
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Fórmulas - Interés Simple:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Interés generado (I):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  I = P * i * t'),
                          SizedBox(height: 10),
                          Text(
                            'Monto futuro (F):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  F = P * (1 + i * t)'),
                          SizedBox(height: 10),
                          Text(
                            'Tasa de interés (i):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  i = I / (P * t)'),
                          SizedBox(height: 10),
                          Text(
                            'Tiempo (t):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  t = I / (P * i)'),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Text(
                            'Donde:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  I = Interés generado'),
                          Text('  P = Capital inicial (Valor Presente)'),
                          Text('  F = Monto final (Valor Futuro)'),
                          Text('  i = Tasa de interés por periodo'),
                          Text('  t = Tiempo (en periodos)'),
                        ],
                      ),
                    ),
                  ),
                  // Fin tarjeta de fórmulas

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
                            Icons.calculate_outlined,
                            size: 48,
                            color: Colors.teal,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Seleccione una opción",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildButton(
                            context: context,
                            icon: Icons.monetization_on,
                            label: "Monto",
                            route: "/simple/form",
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.percent,
                            label: "Tasa Interés",
                            route: "/simple/interes",
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.access_time,
                            label: "Tiempo",
                            route: "/simple/tiempo",
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
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
  }) {
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
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        icon: Icon(icon, size: 24),
        label: Text(
          label,
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
}
