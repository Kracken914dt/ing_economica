import 'dart:math';

class CalcularTIR {
  // Método para calcular la TIR usando la fórmula estándar
  double calcularTIR(List<double> flujos, double inversionInicial) {
    // Aproximación inicial de TIR
    double tir = 0.1; // TIR inicial (10%)
    double precision = 0.0001; // Precisión para detener la búsqueda
    double van = 0.0;
    int maxIteraciones = 1000; // Máximo número de iteraciones

    for (int i = 0; i < maxIteraciones; i++) {
      van = -inversionInicial; // Comenzar con la inversión inicial negativa
      for (int n = 0; n < flujos.length; n++) {
        // Cálculo del VAN usando la fórmula dada
        van += flujos[n] / pow(1 + tir, n + 1);
      }

      if (van.abs() < precision) {
        return tir * 100; // Devolver TIR en porcentaje
      }

      // Ajustar TIR según si el VAN es positivo o negativo
      tir += (van > 0) ? 0.01 : -0.01;
    }

    return tir * 100; // Si no converge, devolver la TIR calculada
  }

  // Método para calcular la TIR usando método de bisección (más preciso que prueba y error simple)
  double calcularTIRPruebaError(List<double> flujos, double inversionInicial) {
    // Método de bisección para aproximar la TIR
    double tirBajo = -0.99; // Límite inferior para la TIR (-99%)
    double tirAlto = 2.0; // Límite superior para la TIR (200%)
    double tirMedio = 0.1; // Punto medio inicial
    double precision = 0.0001; // Precisión para detener la búsqueda
    double vanMedio = 0.0;
    double vanBajo = 0.0;
    int maxIteraciones = 100; // Máximo número de iteraciones

    // Calcular VAN para el límite inferior
    vanBajo = -inversionInicial;
    for (int n = 0; n < flujos.length; n++) {
      vanBajo += flujos[n] / pow(1 + tirBajo, n + 1);
    }

    // Verificar si hay una raíz en el intervalo
    if (vanBajo >= 0) {
      return 0.0; // No se puede encontrar una TIR válida
    }

    for (int i = 0; i < maxIteraciones; i++) {
      tirMedio = (tirBajo + tirAlto) / 2;

      // Calcular VAN para el punto medio
      vanMedio = -inversionInicial;
      for (int n = 0; n < flujos.length; n++) {
        vanMedio += flujos[n] / pow(1 + tirMedio, n + 1);
      }

      // Verificar si hemos alcanzado la precisión deseada
      if (vanMedio.abs() < precision) {
        return tirMedio * 100; // Devolver TIR en porcentaje
      }

      // Ajustar los límites según el signo del VAN
      if (vanMedio * vanBajo < 0) {
        tirAlto = tirMedio;
      } else {
        tirBajo = tirMedio;
        vanBajo = vanMedio;
      }
    }

    return tirMedio *
        100; // Si no converge completamente, devolver la mejor aproximación
  }
}
