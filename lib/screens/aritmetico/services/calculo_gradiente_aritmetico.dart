import 'package:intl/intl.dart';
import 'dart:math';

class GradienteACalculator {
  // Calcula el valor presente de un gradiente aritmético
  double calculatePresentValue({
    required double pago,
    required double gradiente,
    required double periodos,
    required double interes,
    required bool perfil,
  }) {
    // Convertir la tasa de interés a decimal si viene en porcentaje
    double i = interes >= 1 ? interes / 100 : interes;

    // Calcular valor presente con la fórmula adecuada según el perfil
    if (perfil == true) {
      // Gradiente creciente: P = A * [(1+i)^n - 1]/[i*(1+i)^n] + (G/i)*[((1+i)^n - 1)/(i*(1+i)^n) - n/(1+i)^n]
      double presentValue =
          pago * ((pow(1 + i, periodos) - 1) / (i * pow(1 + i, periodos))) +
              (gradiente / i) *
                  ((pow(1 + i, periodos) - 1) / (i * pow(1 + i, periodos)) -
                      (periodos / pow(1 + i, periodos)));

      print(
          'Fórmula: Pago * [(1+i)^periodos - 1]/[i*(1+i)^periodos] + (Gradiente/i)*[((1+i)^periodos - 1)/(i*(1+i)^periodos) - periodos/(1+i)^periodos]');
      print('Valor presente calculado (creciente): $presentValue');

      return presentValue;
    } else {
      // Gradiente decreciente: P = A * [(1+i)^n - 1]/[i*(1+i)^n] - (G/i)*[((1+i)^n - 1)/(i*(1+i)^n) - n/(1+i)^n]
      double presentValue =
          pago * ((pow(1 + i, periodos) - 1) / (i * pow(1 + i, periodos))) -
              (gradiente / i) *
                  ((pow(1 + i, periodos) - 1) / (i * pow(1 + i, periodos)) -
                      (periodos / pow(1 + i, periodos)));

      print('Valor presente calculado (decreciente): $presentValue');

      return presentValue;
    }
  }

  // Calcula el primer pago basado en el valor presente de un gradiente aritmético
  double calculateFirtsPaymentPresentValue({
    required double present,
    required double gradiente,
    required double periodos,
    required double interes,
    required bool perfil,
  }) {
    // Convertir la tasa de interés a decimal si viene en porcentaje
    double i = interes >= 1 ? interes / 100 : interes;

    // Calcular el primer pago según la fórmula adecuada según el perfil
    if (perfil == true) {
      // Fórmula despejada para primer pago (gradiente creciente)
      double presentValue = (present -
              (gradiente / i) *
                  ((pow(1 + i, periodos) - 1) / (i * pow(1 + i, periodos)) -
                      (periodos / pow(1 + i, periodos)))) /
          ((pow(1 + i, periodos) - 1) / (i * pow(1 + i, periodos)));

      print('Primer pago calculado (creciente): $presentValue');

      return presentValue;
    } else {
      // Fórmula despejada para primer pago (gradiente decreciente)
      double presentValue = (present +
              (gradiente / i) *
                  ((pow(1 + i, periodos) - 1) / (i * pow(1 + i, periodos)) -
                      (periodos / pow(1 + i, periodos)))) /
          ((pow(1 + i, periodos) - 1) / (i * pow(1 + i, periodos)));

      print('Primer pago calculado (decreciente): $presentValue');

      return presentValue;
    }
  }

  // Calcula el valor futuro de un gradiente aritmético
  double calculateFutureValue(
      {required double pago,
      required double gradiente,
      required double periodos,
      required double interes,
      required bool perfil}) {
    // Convertir la tasa de interés a decimal si viene en porcentaje
    double i = interes >= 1 ? interes / 100 : interes;

    // Calcular valor futuro con la fórmula adecuada según el perfil
    if (perfil == true) {
      // Gradiente creciente: F = A * [(1+i)^n - 1]/i + (G/i)*[((1+i)^n - 1)/i - n]
      double futureValue = pago * ((pow(1 + i, periodos) - 1) / i) +
          (gradiente / i) * ((pow(1 + i, periodos) - 1) / i - periodos);

      print('Valor futuro calculado (creciente): $futureValue');

      return futureValue;
    } else {
      // Gradiente decreciente: F = A * [(1+i)^n - 1]/i - (G/i)*[((1+i)^n - 1)/i - n]
      double futureValue = pago * ((pow(1 + i, periodos) - 1) / i) -
          (gradiente / i) * ((pow(1 + i, periodos) - 1) / i - periodos);

      print('Valor futuro calculado (decreciente): $futureValue');

      return futureValue;
    }
  }

  // Calcula el primer pago basado en el valor futuro de un gradiente aritmético
  double calculateFirtsPaymentFutureValue(
      {required double future,
      required double gradiente,
      required double periodos,
      required double interes,
      required bool perfil}) {
    // Convertir la tasa de interés a decimal si viene en porcentaje
    double i = interes >= 1 ? interes / 100 : interes;

    // Calcular el primer pago según la fórmula adecuada según el perfil
    if (perfil == true) {
      // Fórmula despejada para primer pago (gradiente creciente)
      double futureValue = (future -
              (gradiente / i) * ((pow(1 + i, periodos) - 1) / i - periodos)) /
          ((pow(1 + i, periodos) - 1) / i);

      print('Primer pago desde valor futuro (creciente): $futureValue');

      return futureValue;
    } else {
      // Fórmula despejada para primer pago (gradiente decreciente)
      double futureValue = (future +
              (gradiente / i) * ((pow(1 + i, periodos) - 1) / i - periodos)) /
          ((pow(1 + i, periodos) - 1) / i);

      print('Primer pago desde valor futuro (decreciente): $futureValue');

      return futureValue;
    }
  }

  // Calcula el valor presente de un gradiente aritmético infinito
  double calculateInfinitePresentValue(
      {required double pago,
      required double gradiente,
      required double interes,
      required bool perfil}) {
    // Convertir la tasa de interés a decimal si viene en porcentaje
    double i = interes >= 1 ? interes / 100 : interes;

    // Calcular valor presente infinito según la fórmula adecuada
    if (perfil == true) {
      // Gradiente creciente infinito: P = pago/i + gradiente/i²
      double infinitePresentValue = (pago / i) + (gradiente / pow(i, 2));

      print('Valor presente infinito (creciente): $infinitePresentValue');

      return infinitePresentValue;
    } else {
      // Gradiente decreciente infinito: P = pago/i - gradiente/i²
      double infinitePresentValue = (pago / i) - (gradiente / pow(i, 2));

      print('Valor presente infinito (decreciente): $infinitePresentValue');

      return infinitePresentValue;
    }
  }

  // Calcula una cuota específica de un gradiente aritmético
  double calculateSpecificQouta(
      {required double pago,
      required double gradiente,
      required double periodos}) {
    // Fórmula de cuota específica: Cuotan = A + (n-1)*G
    double specificQuota = (pago + (periodos - 1) * gradiente);

    print('Cuota específica en el período $periodos: $specificQuota');

    return specificQuota;
  }

  // Calcula el número de períodos basado en días, meses y años
  double calculatePeriod({
    required double days,
    required double months,
    required double years,
    required String mcuota,
  }) {
    double periodo = 0;

    if (mcuota == "Mensual") {
      // Convertir a períodos mensuales
      periodo = (days / 30 + months + years * 12);
      print('Períodos mensuales calculados: $periodo');
      return periodo;
    } else if (mcuota == "Anual") {
      // Convertir a períodos anuales
      periodo = (days / 360 + months / 12 + years);
      print('Períodos anuales calculados: $periodo');
      return periodo;
    }

    return periodo;
  }

  String formatNumber(double number) {
    String numberString = number.toStringAsFixed(2);
    List<String> parts = numberString.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    StringBuffer formattedInteger = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        formattedInteger.write('.');
      }
      formattedInteger.write(integerPart[i]);
    }
    return '\$${formattedInteger.toString()},$decimalPart';
  }

  DateTime parseDate(String date) {
    return DateFormat('dd/MM/yyyy').parse(date);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
