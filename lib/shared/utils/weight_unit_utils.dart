class WeightUnitUtils {
  // No conversion between units - display raw value with selected unit
  static const double _kgToLb = 2.2046226218;

  static String normalizeUnit(String unit) {
    final normalized = unit.toLowerCase();
    if (normalized == 'lbs') {
      return 'lb';
    }
    if (normalized == '片' || normalized == 'plate') {
      return '片';
    }
    return normalized == 'lb' ? 'lb' : 'kg';
  }

  // No conversion - return the kg value as-is
  static double kgToDisplay(double kg, String unit) {
    return kg;
  }

  // No conversion - return the value as-is (stored in kg), floor to integer
  static double displayToKg(double value, String unit) {
    return value.floorToDouble();
  }

  // Parse number and floor to integer
  static double? parseNumber(String raw) {
    final cleaned = raw.trim();
    if (cleaned.isEmpty) {
      return null;
    }
    final match = RegExp(r'-?\d+(?:\.\d+)?').firstMatch(cleaned);
    if (match == null) {
      return null;
    }
    final parsed = double.tryParse(match.group(0)!);
    return parsed?.floorToDouble();
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
      if (normalized == 'kg' || normalized == 'lb' || normalized == '片') {
        return normalized;
      }
    }

    if (trimmed.endsWith('kg')) {
      return 'kg';
    }
    if (trimmed.endsWith('lb') || trimmed.endsWith('lbs')) {
      return 'lb';
    }
    if (trimmed.endsWith('片')) {
      return '片';
    }
    return null;
  }

  static String formatStoredWeight(double kg, String unit) {
    return '${formatNumber(kg)}|${normalizeUnit(unit)}';
  }

  // Always floor to integer (no decimals)
  static String formatNumber(double value) {
    final floored = value.floorToDouble();
    return floored.toStringAsFixed(0);
  }

  static String formatKgToDisplay(double kg, String unit) {
    return formatNumber(kgToDisplay(kg, unit));
  }
}
