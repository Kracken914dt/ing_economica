import 'package:flutter/material.dart';

class AmortizacionView extends StatelessWidget {
  const AmortizacionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amortización'),
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
                            'Fórmulas - Amortización:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Francesa (cuota fija):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  C = P * i * (1+i)^n / [(1+i)^n - 1]'),
                          Text('  Interés = Saldo * i'),
                          Text('  Amortización = C - Interés'),
                          SizedBox(height: 10),
                          Text(
                            'Alemana (amortización fija):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  Amortización = P / n'),
                          Text('  Interés = Saldo * i'),
                          Text('  Cuota = Amortización + Interés'),
                          SizedBox(height: 10),
                          Text(
                            'Americana (sólo intereses, capital al final):',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  Cuota = P * i'),
                          Text('  Interés = P * i'),
                          Text('  Amortización (última cuota) = P'),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Text(
                            'Donde:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  C = Cuota periódica'),
                          Text('  P = Préstamo (monto inicial)'),
                          Text('  i = Tasa de interés por periodo'),
                          Text('  n = Número de periodos'),
                          Text('  Saldo = Capital pendiente de amortizar'),
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
                            Icons.account_balance_outlined,
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
                            label: "Amortización Francesa",
                            route: "/amortizacion/francesa",
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.account_balance,
                            label: "Amortización Alemana",
                            route: "/amortizacion/alemana",
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.account_balance,
                            label: "Amortización Americana",
                            route: "/amortizacion/americana",
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
        borderRadius: BorderRadius.circular(15),
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
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
    );
  }
}
