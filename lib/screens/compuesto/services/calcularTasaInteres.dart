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

    // Fórmula correcta: i = ((MC / C) ^ (1/n)) - 1
    double tasaMensual = (pow(montofuturo / capital, (1 / meses)) - 1);
    double tasaPorcentaje = tasaMensual * 100;

    print('Fórmula: ((${montofuturo} / ${capital}) ^ (1/${meses})) - 1');
    print('Cálculo: (${montofuturo / capital} ^ ${1 / meses}) - 1');
    print('Tasa mensual decimal: $tasaMensual');
    print('Tasa mensual porcentaje: $tasaPorcentaje%');

    return tasaPorcentaje;
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
