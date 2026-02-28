class WeightUnitUtils {
  static const double _kgToLb = 2.2046226218;

  static String normalizeUnit(String unit) {
    final normalized = unit.toLowerCase();
    if (normalized == 'lbs') {
      return 'lb';
    }
    return normalized == 'lb' ? 'lb' : 'kg';
  }

  static double kgToDisplay(double kg, String unit) {
    return normalizeUnit(unit) == 'lb' ? kg * _kgToLb : kg;
  }

  static double displayToKg(double value, String unit) {
    return normalizeUnit(unit) == 'lb' ? value / _kgToLb : value;
  }

  static double? parseNumber(String raw) {
    final cleaned = raw.trim();
    if (cleaned.isEmpty) {
      return null;
    }
    final match = RegExp(r'-?\d+(?:\.\d+)?').firstMatch(cleaned);
    if (match == null) {
      return null;
    }
    return double.tryParse(match.group(0)!);
  }

  static double? parseDisplayToKg(String raw, String unit) {
    final value = parseNumber(raw);
    if (value == null) {
      return null;
    }
    return displayToKg(value, unit);
  }

  static double? parseStoredToKg(String raw) {
    return parseNumber(raw);
  }

  static String? parseStoredUnit(String raw) {
    final trimmed = raw.trim().toLowerCase();
    if (trimmed.isEmpty) {
      return null;
    }

    if (trimmed.contains('|')) {
      final unitPart = trimmed.split('|').last.trim();
      final normalized = normalizeUnit(unitPart);
      if (normalized == 'kg' || normalized == 'lb') {
        return normalized;
      }
    }

    if (trimmed.endsWith('kg')) {
      return 'kg';
    }
    if (trimmed.endsWith('lb') || trimmed.endsWith('lbs')) {
      return 'lb';
    }
    return null;
  }

  static String formatStoredWeight(double kg, String unit) {
    return '${formatNumber(kg)}|${normalizeUnit(unit)}';
  }

  static String formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  static String formatKgToDisplay(double kg, String unit) {
    return formatNumber(kgToDisplay(kg, unit));
  }
}
