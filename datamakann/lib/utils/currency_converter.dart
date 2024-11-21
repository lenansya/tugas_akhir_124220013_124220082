class CurrencyConverter {
  static const Map<String, double> _exchangeRates = {
    'IDR': 15000.0, // Indonesia
    'SAR': 3.75, // Saudi Arabia
    'CNY': 7.2, // China
    'JPY': 110.0, // Japan
    'USD': 1.0, // United States
    'KRW': 1300.0, // South Korea
  };

  // Mengembalikan hasil konversi dalam tipe double
  static double convert(double amount, String currencyCode) {
    final rate = _exchangeRates[currencyCode];

    if (rate == null) {
      throw ArgumentError('Currency code not supported');
    }

    return amount * rate;
  }

  // Fungsi untuk mendapatkan hasil konversi dalam format string
  static String convertToString(double amount, String currencyCode) {
    final convertedAmount = convert(amount, currencyCode);
    return '${convertedAmount.toStringAsFixed(2)} $currencyCode';
  }
}
