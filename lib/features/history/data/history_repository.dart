import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:drift/drift.dart';

final historyRepositoryProvider = Provider<HistoryRepository>((ref) {
  return HistoryRepository(databaseProvider);
});

final historyStreamProvider = StreamProvider<List<DailyRecord>>((ref) {
  final repository = ref.watch(historyRepositoryProvider);
  return repository.watchAllRecords();
});

class HistoryRepository {
  final AppDatabase _db;

  HistoryRepository(this._db);

  Stream<List<DailyRecord>> watchAllRecords() {
    return (_db.select(_db.dailyRecords)
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }

  Stream<List<DailyRecord>> watchRecordsByRange(DateTime start, DateTime end) {
    return (_db.select(_db.dailyRecords)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)]))
        .watch();
  }
}
