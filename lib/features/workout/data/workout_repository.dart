import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:uuid/uuid.dart';

final workoutTypeRepositoryProvider = Provider<WorkoutTypeRepository>((ref) {
  return WorkoutTypeRepository();
});

class WorkoutTypeRepository {
  // 获取所有训练类型
  Future<List<WorkoutType>> getAllTypes() {
    return databaseProvider.select(databaseProvider.workoutTypes).get();
  }

  // 监听所有训练类型
  Stream<List<WorkoutType>> watchAllTypes() {
    return databaseProvider.select(databaseProvider.workoutTypes).watch();
  }

  // 根据ID获取训练类型
  Future<WorkoutType?> getTypeById(int id) {
    return (databaseProvider.select(databaseProvider.workoutTypes)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // 添加训练类型
  Future<int> addType(String name, {int sortOrder = 0}) {
    return databaseProvider.into(databaseProvider.workoutTypes).insert(
      WorkoutTypesCompanion.insert(
        name: name,
        sortOrder: Value(sortOrder),
      ),
    );
  }

  // 更新训练类型
  Future<bool> updateType(int id, String name) {
    return (databaseProvider.update(databaseProvider.workoutTypes)
          ..where((t) => t.id.equals(id)))
        .write(WorkoutTypesCompanion(name: Value(name)))
        .then((rows) => rows > 0);
  }

  // 删除训练类型
  Future<int> deleteType(int id) {
    return (databaseProvider.delete(databaseProvider.workoutTypes)
          ..where((t) => t.id.equals(id)))
        .go();
  }
}

// 训练会话仓库
final workoutSessionRepositoryProvider = WorkoutSessionRepository();

class WorkoutSessionRepository {
  // 创建新训练会话
  Future<String> createSession({
    required int typeId,
    required DateTime date,
    String? note,
    String status = 'in_progress',
  }) async {
    final id = const Uuid().v4();
    await databaseProvider.into(databaseProvider.workoutSessions).insert(
      WorkoutSessionsCompanion.insert(
        id: id,
        typeId: typeId,
        date: date,
        note: Value(note),
        status: Value(status),
        createdAt: DateTime.now(),
      ),
    );
    return id;
  }

  // 完成训练会话
  Future<void> completeSession(String sessionId, {String? note}) async {
    await (databaseProvider.update(databaseProvider.workoutSessions)
          ..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(
          status: const Value('completed'),
          note: Value(note),
        ));
  }

  // 获取所有训练会话
  Future<List<WorkoutSession>> getAllSessions() {
    return (databaseProvider.select(databaseProvider.workoutSessions)
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .get();
  }

  // 监听所有训练会话
  Stream<List<WorkoutSession>> watchAllSessions() {
    return (databaseProvider.select(databaseProvider.workoutSessions)
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .watch();
  }

  // 根据类型获取训练会话
  Future<List<WorkoutSession>> getSessionsByType(int typeId) {
    return (databaseProvider.select(databaseProvider.workoutSessions)
          ..where((s) => s.typeId.equals(typeId))
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .get();
  }

  // 获取最后一次同类型训练
  Future<WorkoutSession?> getLastSessionByType(int typeId) async {
    final sessions = await (databaseProvider.select(databaseProvider.workoutSessions)
          ..where((s) => s.typeId.equals(typeId) & s.status.equals('completed'))
          ..orderBy([(s) => OrderingTerm.desc(s.date)])
          ..limit(1))
        .get();
    return sessions.isEmpty ? null : sessions.first;
  }

  // 获取最后两次同类型训练
  Future<List<WorkoutSession>> getLastTwoSessionsByType(int typeId) async {
    final sessions = await (databaseProvider.select(databaseProvider.workoutSessions)
          ..where((s) => s.typeId.equals(typeId) & s.status.equals('completed'))
          ..orderBy([(s) => OrderingTerm.desc(s.date)])
          ..limit(2))
        .get();
    return sessions;
  }

  // 根据ID获取训练会话
  Future<WorkoutSession?> getSessionById(String id) {
    return (databaseProvider.select(databaseProvider.workoutSessions)
          ..where((s) => s.id.equals(id)))
        .getSingleOrNull();
  }

  // 删除训练会话
  Future<int> deleteSession(String id) {
    // 先删除所有关联的组
    return databaseProvider.transaction(() async {
      await (databaseProvider.delete(databaseProvider.workoutSets)
            ..where((s) => s.sessionId.equals(id)))
          .go();
      return (databaseProvider.delete(databaseProvider.workoutSessions)
            ..where((s) => s.id.equals(id)))
          .go();
    });
  }

  // 更新训练会话备注
  Future<void> updateNote(String sessionId, String? note) async {
    await (databaseProvider.update(databaseProvider.workoutSessions)
          ..where((s) => s.id.equals(sessionId)))
        .write(WorkoutSessionsCompanion(note: Value(note)));
  }
}

// 训练组仓库
final workoutSetRepositoryProvider = WorkoutSetRepository();

class WorkoutSetRepository {
  // 添加训练组
  Future<void> addSet({
    required String sessionId,
    required String exerciseId,
    required int setNumber,
    String weight = '',
    int reps = 0,
  }) async {
    final id = const Uuid().v4();
    await databaseProvider.into(databaseProvider.workoutSets).insert(
      WorkoutSetsCompanion.insert(
        id: id,
        sessionId: sessionId,
        exerciseId: exerciseId,
        setNumber: setNumber,
        weight: Value(weight),
        reps: Value(reps),
      ),
    );
  }

  // 更新训练组
  Future<void> updateSet(String id, {String? weight, int? reps}) async {
    await (databaseProvider.update(databaseProvider.workoutSets)
          ..where((s) => s.id.equals(id)))
        .write(WorkoutSetsCompanion(
          weight: weight != null ? Value(weight) : const Value.absent(),
          reps: reps != null ? Value(reps) : const Value.absent(),
        ));
  }

  // 删除训练组
  Future<int> deleteSet(String id) {
    return (databaseProvider.delete(databaseProvider.workoutSets)
          ..where((s) => s.id.equals(id)))
        .go();
  }

  // 根据会话ID获取所有组
  Future<List<WorkoutSet>> getSetsBySession(String sessionId) {
    return (databaseProvider.select(databaseProvider.workoutSets)
          ..where((s) => s.sessionId.equals(sessionId))
          ..orderBy([
            (s) => OrderingTerm.asc(s.exerciseId),
            (s) => OrderingTerm.asc(s.setNumber),
          ]))
        .get();
  }

  // 监听会话的所有组
  Stream<List<WorkoutSet>> watchSetsBySession(String sessionId) {
    return (databaseProvider.select(databaseProvider.workoutSets)
          ..where((s) => s.sessionId.equals(sessionId))
          ..orderBy([
            (s) => OrderingTerm.asc(s.exerciseId),
            (s) => OrderingTerm.asc(s.setNumber),
          ]))
        .watch();
  }

  // 根据动作ID获取历史组记录
  Future<List<WorkoutSet>> getSetsByExercise(String exerciseId, {int limit = 10}) {
    return (databaseProvider.select(databaseProvider.workoutSets)
          ..where((s) => s.exerciseId.equals(exerciseId))
          ..orderBy([(s) => OrderingTerm.desc(s.id)])
          ..limit(limit))
        .get();
  }

  // 复制上次训练的组到新会话
  Future<void> copySetsFromLastSession(String lastSessionId, String newSessionId) async {
    final lastSets = await getSetsBySession(lastSessionId);
    
    for (final set in lastSets) {
      await addSet(
        sessionId: newSessionId,
        exerciseId: set.exerciseId,
        setNumber: set.setNumber,
        weight: set.weight,
        reps: set.reps,
      );
    }
  }

  // 删除会话的所有组
  Future<int> deleteSetsBySession(String sessionId) {
    return (databaseProvider.delete(databaseProvider.workoutSets)
          ..where((s) => s.sessionId.equals(sessionId)))
        .go();
  }
}
