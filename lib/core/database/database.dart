import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  WorkoutTypes,
  Exercises,
  WorkoutSessions,
  WorkoutSets,
  WorkoutPlans,
  PlanDays,
  DayExercises,
  DailyRecords,
  ExerciseRecords,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);
  
  AppDatabase.forMobile() : super(_openConnection());
  
  @override
  int get schemaVersion => 3;
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _createIndexes(m);
        // Insert default workout types
        await _insertDefaultTypes();
        // Insert default exercises
        await _insertDefaultExercises();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await _createIndexes(m);
        }
        if (from < 3) {
          // Migration to version 3: Add new tables
          await m.createAll();
          await _insertDefaultTypes();
          await _insertDefaultExercises();
        }
      },
    );
  }
  
  Future<void> _insertDefaultTypes() async {
    // Insert default workout types if not exist
    final existingTypes = await select(workoutTypes).get();
    if (existingTypes.isEmpty) {
      await into(workoutTypes).insert(WorkoutTypesCompanion.insert(
        name: '通用',
        sortOrder: const Value(0),
      ));
      await into(workoutTypes).insert(WorkoutTypesCompanion.insert(
        name: '胸肌与三头',
        sortOrder: const Value(1),
      ));
      await into(workoutTypes).insert(WorkoutTypesCompanion.insert(
        name: '背部与二头',
        sortOrder: const Value(2),
      ));
      await into(workoutTypes).insert(WorkoutTypesCompanion.insert(
        name: '肩部与臀腿',
        sortOrder: const Value(3),
      ));
    }
  }
  
  Future<void> _insertDefaultExercises() async {
    final existingExercises = await select(exercises).get();
    if (existingExercises.isEmpty) {
      final now = DateTime.now();
      
      // 通用
      await into(exercises).insert(ExercisesCompanion.insert(
        id: 'ex_tongyong_juanqu',
        name: '负重蜷曲',
        typeId: const Value(1),
        category: const Value('通用'),
        defaultSets: const Value(3),
        defaultReps: const Value(15),
        defaultWeight: const Value(6),
        createdAt: now,
      ));
      
      // 胸肌与三头
      final chestExercises = [
        ('ex_gangling_wotui', '杠铃卧推', 4, 10, 50.0),
        ('ex_pingban_yangling_wotui', '平板哑铃卧推', 4, 12, 17.5),
        ('ex_shangxian_yangling_wotui', '上斜哑铃卧推', 4, 10, 17.5),
        ('ex_hudieji_jiaxiong', '蝴蝶机夹胸', 3, 15, 6.0),
        ('ex_qixie_tuixiong', '器械推胸', 4, 12, 1.0),
        ('ex_suikushi', '碎颅式', 4, 12, 5.0),
        ('ex_shoutou_bitichong', '绳索过头臂屈伸', 4, 12, 6.0),
        ('ex_shoutiao_xialaqi', '绳索下拉直杆', 3, 12, 8.0),
      ];
      
      for (final e in chestExercises) {
        await into(exercises).insert(ExercisesCompanion.insert(
          id: e.$1,
          name: e.$2,
          typeId: const Value(2),
          category: const Value('胸肌与三头'),
          defaultSets: Value(e.$3),
          defaultReps: Value(e.$4),
          defaultWeight: Value(e.$5),
          createdAt: now,
        ));
      }
      
      // 背部与二头
      final backExercises = [
        ('ex_yintixiangshang', '引体向上', 4, 10, null),
        ('ex_gaowei_xiala_qixie', '高位下拉器械', 4, 11, 25.0),
        ('ex_gaowei_xiala', '高位下拉', 4, 12, 8.0),
        ('ex_gaowei_xiala_duiwo_kuanku', '高位下拉对握宽距', 4, 12, 8.0),
        ('ex_zuozi_huachuan', '坐姿划船', 4, 12, 8.0),
        ('ex_t_guizahuchuan', 't杠划船', 3, 12, 20.0),
        ('ex_qixie_huachuan', '器械划船', 3, 12, 1.0),
        ('ex_mushifanduiwanqu', '牧师凳弯举', 4, 15, 20.0),
        ('ex_longmenjia_wanquan', '龙门架弯举', 4, 12, 40.0),
        ('ex_chuishi_wanquan', '锤式弯举', 4, 12, 5.0),
        ('ex_fanxiang_gangling_wanquan', '反向杠铃弯举', 4, 12, 10.0),
      ];
      
      for (final e in backExercises) {
        await into(exercises).insert(ExercisesCompanion.insert(
          id: e.$1,
          name: e.$2,
          typeId: const Value(3),
          category: const Value('背部与二头'),
          defaultSets: Value(e.$3),
          defaultReps: Value(e.$4),
          defaultWeight: Value(e.$5),
          createdAt: now,
        ));
      }
      
      // 肩部与臀腿
      final shoulderLegExercises = [
        ('ex_zuozi_tuishoulder', '坐姿推肩', 4, 12, 15.0),
        ('ex_qixie_tuishoulder', '器械推肩', 4, 12, 20.0),
        ('ex_shenglian_cepingju', '绳索侧平举', 4, 15, 2.0),
        ('ex_houshu_qixie', '后束器械', 4, 15, 6.0),
        ('ex_shenglian_mianla', '绳索面拉', 3, 6, 60.0),
        ('ex_shengwan_zhengshou_wanquan', '手腕正手弯举', 3, 12, null),
        ('ex_shengwan_fanshou_wanquan', '手腕反手弯举', 3, 12, null),
        ('ex_kaobei_shenqiqi', '靠背深蹲机', 4, 10, 20.0),
        ('ex_zhengtiaoqi', '正蹲机', 4, 12, 20.0),
        ('ex_gaojiaobei_shenqun', '高脚杯深蹲', 3, 15, 15.0),
      ];
      
      for (final e in shoulderLegExercises) {
        await into(exercises).insert(ExercisesCompanion.insert(
          id: e.$1,
          name: e.$2,
          typeId: const Value(4),
          category: const Value('肩部与臀腿'),
          defaultSets: Value(e.$3),
          defaultReps: Value(e.$4),
          defaultWeight: Value(e.$5),
          createdAt: now,
        ));
      }
    }
  }
  
  Future<void> _createIndexes(Migrator m) async {
    // Indexes for PlanDays
    await customStatement('CREATE INDEX IF NOT EXISTS idx_plan_days_plan_id ON plan_days (plan_id);');
    
    // Indexes for DayExercises
    await customStatement('CREATE INDEX IF NOT EXISTS idx_day_exercises_plan_day_id ON day_exercises (plan_day_id);');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_day_exercises_exercise_id ON day_exercises (exercise_id);');

    // Indexes for DailyRecords
    await customStatement('CREATE INDEX IF NOT EXISTS idx_daily_records_date ON daily_records (date);');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_daily_records_plan_day_id ON daily_records (plan_day_id);');

    // Indexes for ExerciseRecords
    await customStatement('CREATE INDEX IF NOT EXISTS idx_exercise_records_daily_record_id ON exercise_records (daily_record_id);');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_exercise_records_exercise_id ON exercise_records (exercise_id);');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'xworkout.db'));
    return NativeDatabase.createInBackground(file);
  });
}
