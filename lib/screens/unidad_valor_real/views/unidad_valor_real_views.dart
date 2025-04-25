import 'package:flutter/material.dart';

class UnidadValorRealView extends StatelessWidget {
  const UnidadValorRealView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unidad de Valor Real'),
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
                            'Fórmulas - Unidad de Valor Real (UVR):',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Cálculo del valor de la UVR:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  UVR(t) = UVR(t-1) * (1 + i)^(1/d)'),
                          SizedBox(height: 10),
                          Text(
                            'Conversión de Pesos a UVR:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  Valor en UVR = Valor en Pesos / UVR del día'),
                          SizedBox(height: 10),
                          Text(
                            'Conversión de UVR a Pesos:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  Valor en Pesos = Valor en UVR * UVR del día'),
                          SizedBox(height: 10),
                          Divider(),
                          SizedBox(height: 10),
                          Text(
                            'Donde:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text('  UVR(t) = Valor de la UVR del día t'),
                          Text('  UVR(t-1) = Valor de la UVR del día anterior'),
                          Text('  i = Inflación mensual'),
                          Text('  d = Número de días del mes'),
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
                            Icons.monetization_on_outlined,
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
                            label: "U.V.R Valor Específico",
                            route: "/unidadvalorreal/valor",
                          ),
                          const SizedBox(height: 16),
                          _buildButton(
                            context: context,
                            icon: Icons.view_timeline_rounded,
                            label: "U.V.R Tabla",
                            route: "/unidadvalorreal/tabla",
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
