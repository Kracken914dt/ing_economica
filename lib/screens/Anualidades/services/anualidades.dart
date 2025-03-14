import 'dart:math';

class AnualidadCalculator {
  /// Calcula el Valor Futuro de una anualidad ordinaria
  double calcularValorFuturoOrdinaria({
    required double pago,
    required double tasaInteres,
    required int periodos,
  }) {
    double i = tasaInteres / 100;
    return pago * ((pow(1 + i, periodos) - 1) / i);
  }

  /// Calcula el Valor Presente de una anualidad ordinaria
  double calcularValorPresenteOrdinaria({
    required double pago,
    required double tasaInteres,
    required int periodos,
  }) {
    double i = tasaInteres / 100;
    return pago * ((1 - pow(1 + i, -periodos)) / i);
  }

  /// Calcula el Valor Futuro de una anualidad anticipada
  double calcularValorFuturoAnticipada({
    required double pago,
    required double tasaInteres,
    required int periodos,
  }) {
    double i = tasaInteres / 100;
    return pago * ((pow(1 + i, periodos) - 1) / i) * (1 + i);
  }

  /// Calcula el Valor Presente de una anualidad anticipada
  double calcularValorPresenteAnticipada({
    required double pago,
    required double tasaInteres,
    required int periodos,
  }) {
    double i = tasaInteres / 100;
    return pago * ((1 - pow(1 + i, -periodos)) / i) * (1 + i);
  }
}


