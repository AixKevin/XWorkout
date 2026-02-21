import 'package:xworkout/core/database/database.dart';
import 'package:drift/drift.dart';

class PlanTemplate {
  final String name;
  final String description;
  final int cycleDays;
  final List<DayTemplate> days;

  const PlanTemplate({
    required this.name,
    required this.description,
    required this.cycleDays,
    required this.days,
  });
}

class DayTemplate {
  final int dayIndex;
  final bool isRestDay;
  final List<ExerciseTemplate> exercises;

  const DayTemplate({
    required this.dayIndex,
    required this.isRestDay,
    required this.exercises,
  });
}

class ExerciseTemplate {
  final String name;
  final String category;
  final int targetSets;
  final int targetReps;
  final double? targetWeight;

  const ExerciseTemplate({
    required this.name,
    required this.category,
    required this.targetSets,
    required this.targetReps,
    this.targetWeight,
  });
}

const List<PlanTemplate> planTemplates = [
  PlanTemplate(
    name: '胸部训练计划',
    description: '专注于胸肌的训练计划',
    cycleDays: 3,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '杠铃卧推', category: '胸部', targetSets: 4, targetReps: 8, targetWeight: 60),
          ExerciseTemplate(name: '哑铃卧推', category: '胸部', targetSets: 3, targetReps: 10, targetWeight: 20),
          ExerciseTemplate(name: '上斜哑铃卧推', category: '胸部', targetSets: 3, targetReps: 10, targetWeight: 16),
          ExerciseTemplate(name: '哑铃飞鸟', category: '胸部', targetSets: 3, targetReps: 12, targetWeight: 12),
        ],
      ),
      DayTemplate(
        dayIndex: 1,
        isRestDay: true,
        exercises: [],
      ),
      DayTemplate(
        dayIndex: 2,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '双杠臂屈伸', category: '胸部', targetSets: 3, targetReps: 10),
          ExerciseTemplate(name: '俯卧撑', category: '胸部', targetSets: 3, targetReps: 15),
          ExerciseTemplate(name: '蝴蝶机夹胸', category: '胸部', targetSets: 3, targetReps: 12, targetWeight: 30),
        ],
      ),
    ],
  ),
  PlanTemplate(
    name: '背部训练计划',
    description: '专注于背阔肌和核心的训练计划',
    cycleDays: 3,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '引体向上', category: '背部', targetSets: 4, targetReps: 6),
          ExerciseTemplate(name: '杠铃划船', category: '背部', targetSets: 4, targetReps: 8, targetWeight: 50),
          ExerciseTemplate(name: '单臂哑铃划船', category: '背部', targetSets: 3, targetReps: 10, targetWeight: 20),
          ExerciseTemplate(name: '硬拉', category: '背部', targetSets: 3, targetReps: 8, targetWeight: 80),
        ],
      ),
      DayTemplate(
        dayIndex: 1,
        isRestDay: true,
        exercises: [],
      ),
      DayTemplate(
        dayIndex: 2,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '背阔肌下拉', category: '背部', targetSets: 3, targetReps: 10, targetWeight: 40),
          ExerciseTemplate(name: '坐姿划船', category: '背部', targetSets: 3, targetReps: 10, targetWeight: 35),
          ExerciseTemplate(name: '山羊挺身', category: '背部', targetSets: 3, targetReps: 12),
        ],
      ),
    ],
  ),
  PlanTemplate(
    name: '腿部训练计划',
    description: '针对大腿和臀部的训练计划',
    cycleDays: 3,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '深蹲', category: '腿部', targetSets: 4, targetReps: 8, targetWeight: 80),
          ExerciseTemplate(name: '腿举', category: '腿部', targetSets: 4, targetReps: 10, targetWeight: 120),
          ExerciseTemplate(name: '腿弯举', category: '腿部', targetSets: 3, targetReps: 12, targetWeight: 30),
          ExerciseTemplate(name: '提踵', category: '腿部', targetSets: 3, targetReps: 15, targetWeight: 40),
        ],
      ),
      DayTemplate(
        dayIndex: 1,
        isRestDay: true,
        exercises: [],
      ),
      DayTemplate(
        dayIndex: 2,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '硬拉', category: '腿部', targetSets: 4, targetReps: 6, targetWeight: 90),
          ExerciseTemplate(name: '箭步蹲', category: '腿部', targetSets: 3, targetReps: 10, targetWeight: 20),
          ExerciseTemplate(name: '腿外展', category: '腿部', targetSets: 3, targetReps: 12, targetWeight: 25),
        ],
      ),
    ],
  ),
  PlanTemplate(
    name: '全身训练计划',
    description: '简洁高效的全身训练计划',
    cycleDays: 2,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '深蹲', category: '腿部', targetSets: 4, targetReps: 8, targetWeight: 60),
          ExerciseTemplate(name: '卧推', category: '胸部', targetSets: 4, targetReps: 8, targetWeight: 50),
          ExerciseTemplate(name: '划船', category: '背部', targetSets: 4, targetReps: 8, targetWeight: 40),
          ExerciseTemplate(name: '肩部推举', category: '肩部', targetSets: 3, targetReps: 10, targetWeight: 25),
          ExerciseTemplate(name: '硬拉', category: '背部', targetSets: 3, targetReps: 8, targetWeight: 60),
        ],
      ),
      DayTemplate(
        dayIndex: 1,
        isRestDay: true,
        exercises: [],
      ),
    ],
  ),
  PlanTemplate(
    name: '哑铃训练计划',
    description: '适合居家使用的哑铃训练计划',
    cycleDays: 3,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '哑铃深蹲', category: '腿部', targetSets: 3, targetReps: 12, targetWeight: 16),
          ExerciseTemplate(name: '哑铃卧推', category: '胸部', targetSets: 3, targetReps: 10, targetWeight: 16),
          ExerciseTemplate(name: '哑铃划船', category: '背部', targetSets: 3, targetReps: 10, targetWeight: 14),
          ExerciseTemplate(name: '哑铃推举', category: '肩部', targetSets: 3, targetReps: 10, targetWeight: 10),
        ],
      ),
      DayTemplate(
        dayIndex: 1,
        isRestDay: true,
        exercises: [],
      ),
      DayTemplate(
        dayIndex: 2,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '哑铃硬拉', category: '背部', targetSets: 3, targetReps: 12, targetWeight: 18),
          ExerciseTemplate(name: '哑铃飞鸟', category: '胸部', targetSets: 3, targetReps: 12, targetWeight: 10),
          ExerciseTemplate(name: '哑铃弯举', category: '手臂', targetSets: 3, targetReps: 12, targetWeight: 8),
          ExerciseTemplate(name: '三头肌臂屈伸', category: '手臂', targetSets: 3, targetReps: 12, targetWeight: 8),
        ],
      ),
    ],
  ),
];
