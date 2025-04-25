import 'package:flutter/material.dart';

class CompuestoView extends StatelessWidget {
  const CompuestoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interés Compuesto'),
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
                            'Fórmulas - Interés Compuesto:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Monto Futuro (F):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  F = P(1 + i)^n'),
                          SizedBox(height: 10),
                          Text(
                            'Valor Presente (P):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  P = F/(1 + i)^n'),
                          SizedBox(height: 10),
                          Text(
                            'Tasa de Interés (i):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  i = (F/P)^(1/n) - 1'),
                          SizedBox(height: 10),
                          Text(
                            'Tiempo (n):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  n = ln(F/P)/ln(1+i)'),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Text(
                            'Donde:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  F = Monto futuro'),
                          Text('  P = Capital inicial (Valor Presente)'),
                          Text('  i = Tasa de interés (por periodo)'),
                          Text('  n = Número de periodos'),
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
                            Icons.trending_up,
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
                            label: "Monto Futuro",
                            route: "/compuesto/montofuturo",
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.percent,
                            label: "Tasa Interés",
                            route: "/compuesto/tasainteres",
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.access_time,
                            label: "Tiempo",
                            route: "/compuesto/tiempo",
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
