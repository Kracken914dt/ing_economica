import 'package:intl/intl.dart';
import 'dart:math';

class InterestCalculator {
  double calculateTasaInteres({
    required double capital,
    required double montofuturo,
    required int vecesporano,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    // Calculamos el número de meses entre las fechas
    int meses = ((endDate.year - startDate.year) * 12) +
        endDate.month -
        startDate.month;

    print('Capital: $capital');
    print('Monto Futuro: $montofuturo');
    print('Meses calculados: $meses');
    print('Veces por año: $vecesporano');

    // Calculamos el número de períodos según la frecuencia de capitalización
    double periodos = meses * vecesporano / 12;

    // Fórmula correcta: i = ((MC / C) ^ (1/periodos)) - 1
    double tasaPorPeriodo = (pow(montofuturo / capital, (1 / periodos)) - 1);

    // Convertimos la tasa por período a tasa anual nominal
    double tasaAnualNominal = tasaPorPeriodo * vecesporano * 100;

    print('Períodos calculados: $periodos');
    print('Fórmula: ((${montofuturo} / ${capital}) ^ (1/${periodos})) - 1');
    print('Tasa por período: $tasaPorPeriodo');
    print('Tasa anual nominal: $tasaAnualNominal%');

    return tasaAnualNominal;
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
    return "${formattedInteger.toString()},${decimalPart}";
  }

  DateTime parseDate(String date) {
    return DateFormat('dd/MM/yyyy').parse(date);
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
