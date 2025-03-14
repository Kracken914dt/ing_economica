import 'package:intl/intl.dart';
import 'dart:math';

class MontofuturoCalcular {
  double calculateFutureAmount({
    required double capital,
    required double rate,
    required DateTime startDate,
    required int vecesporano,
    required DateTime endDate,
  }) {
    // CORRECCIÓN 1: Para asegurar que la tasa se maneje correctamente
    // Si la tasa viene como 0.02 desde la interfaz, no dividimos
    // Si viene como 2.0, entonces sí dividimos por 100
    final double tasaDecimal = rate >= 1 ? rate / 100 : rate;

    // CORRECCIÓN 2: Usamos directamente el valor del meses que viene desde la interfaz
    // o aseguramos que el cálculo sea correcto sin restar uno
    int meses = ((endDate.year - startDate.year) * 12) +
        endDate.month -
        startDate.month;

    // Eliminamos la condición que resta un mes
    // if (endDate.day < startDate.day) {
    //   meses--;
    // }

    print('Capital: $capital');
    print('Tasa original: $rate');
    print('Tasa decimal corregida: $tasaDecimal');
    print('Meses calculados: $meses');
    print('Fórmula: $capital * (1 + $tasaDecimal)^$meses');

    // Fórmula correcta: MC = Capital * (1 + tasa)^n
    double resultado = capital * pow((1 + tasaDecimal), meses);
    print('Resultado: $resultado');

    return resultado;
  }

  double calculateInterestRate({
    required double futureAmount,
    required double capital,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final int days = endDate.difference(startDate).inDays;
    final double periodInYears = days / 365.0;

    double rate = (pow(futureAmount / capital, 1 / periodInYears) - 1) * 100;

    return rate;
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
