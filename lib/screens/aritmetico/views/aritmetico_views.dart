import 'package:flutter/material.dart';

class AritmeticoView extends StatelessWidget {
  const AritmeticoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradiente Aritmético'),
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
                            'Fórmulas - Gradiente Aritmético:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Valor Presente (P):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                              '  P = G * [(1+i)^n - 1 - n*i] / [i^2 * (1+i)^n]'),
                          SizedBox(height: 10),
                          Text(
                            'Valor Futuro (F):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  F = G * [(1+i)^n - 1 - n*i] / [i^2]'),
                          SizedBox(height: 10),
                          Text(
                            'Valor Presente Infinito (P∞):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  P∞ = G / i^2'),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Text(
                            'Donde:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  P = Valor presente del gradiente'),
                          Text('  F = Valor futuro del gradiente'),
                          Text('  G = Incremento constante (gradiente)'),
                          Text('  i = Tasa de interés por periodo'),
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
                            Icons.stacked_line_chart,
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
                            icon: Icons.calculate,
                            label: "Valor Presente",
                            route: "/aritmetico/valorpresente",
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.view_timeline_rounded,
                            label: "Valor Futuro",
                            route: "/aritmetico/valorfuturo",
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.loop_outlined,
                            label: "Valor Presente G.A Infinito",
                            route: "/aritmetico/valorpresenteinfinito",
                          ),
                          /*const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.manage_search_rounded,
                            label: "Cuota Específica",
                            route: "/aritmetico/cuotaespecifica",
                          ),*/
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
