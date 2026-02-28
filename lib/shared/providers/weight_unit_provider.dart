import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/features/more/data/settings_repository.dart';
import 'package:xworkout/shared/utils/weight_unit_utils.dart';

final weightUnitProvider =
    StateNotifierProvider<WeightUnitNotifier, String>((ref) {
  return WeightUnitNotifier(ref.read(settingsRepositoryProvider));
});

class WeightUnitNotifier extends StateNotifier<String> {
  WeightUnitNotifier(this._settingsRepository) : super('kg') {
    _load();
  }

  final SettingsRepository _settingsRepository;

  Future<void> _load() async {
    final unit = await _settingsRepository.getWeightUnit();
    state = WeightUnitUtils.normalizeUnit(unit);
  }

  Future<void> setWeightUnit(String unit) async {
    final normalized = WeightUnitUtils.normalizeUnit(unit);
    await _settingsRepository.setWeightUnit(normalized);
    state = normalized;
  }
}
