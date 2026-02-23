class PlanTemplate {
  final String id;
  final String name;
  final String description;
  final int cycleDays;
  final List<DayTemplate> days;
  final bool isCustom;

  const PlanTemplate({
    this.id = '',
    required this.name,
    required this.description,
    required this.cycleDays,
    required this.days,
    this.isCustom = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'cycleDays': cycleDays,
      'days': days.map((day) => day.toJson()).toList(),
      'isCustom': isCustom,
    };
  }

  factory PlanTemplate.fromJson(Map<String, dynamic> json) {
    return PlanTemplate(
      id: json['id'] ?? '',
      name: json['name'] as String,
      description: json['description'] as String,
      cycleDays: json['cycleDays'] as int,
      days: (json['days'] as List).map((e) => DayTemplate.fromJson(e)).toList(),
      isCustom: json['isCustom'] ?? false,
    );
  }

  PlanTemplate copyWith({
    String? id,
    String? name,
    String? description,
    int? cycleDays,
    List<DayTemplate>? days,
    bool? isCustom,
  }) {
    return PlanTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      cycleDays: cycleDays ?? this.cycleDays,
      days: days ?? this.days,
      isCustom: isCustom ?? this.isCustom,
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'dayIndex': dayIndex,
      'isRestDay': isRestDay,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }

  factory DayTemplate.fromJson(Map<String, dynamic> json) {
    return DayTemplate(
      dayIndex: json['dayIndex'] as int,
      isRestDay: json['isRestDay'] as bool,
      exercises: (json['exercises'] as List).map((e) => ExerciseTemplate.fromJson(e)).toList(),
    );
  }
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

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'targetSets': targetSets,
      'targetReps': targetReps,
      'targetWeight': targetWeight,
    };
  }

  factory ExerciseTemplate.fromJson(Map<String, dynamic> json) {
    return ExerciseTemplate(
      name: json['name'] as String,
      category: json['category'] as String,
      targetSets: json['targetSets'] as int,
      targetReps: json['targetReps'] as int,
      targetWeight: (json['targetWeight'] as num?)?.toDouble(),
    );
  }
}

const List<PlanTemplate> planTemplates = [
  PlanTemplate(
    id: 'chest_focus',
    name: '胸部训练计划',
    description: '专注于胸肌的训练计划',
    cycleDays: 3,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '杠铃卧推', category: '胸肌与三头', targetSets: 4, targetReps: 8, targetWeight: 60),
          ExerciseTemplate(name: '哑铃卧推', category: '胸肌与三头', targetSets: 3, targetReps: 10, targetWeight: 20),
          ExerciseTemplate(name: '上斜哑铃卧推', category: '胸肌与三头', targetSets: 3, targetReps: 10, targetWeight: 16),
          ExerciseTemplate(name: '哑铃飞鸟', category: '胸肌与三头', targetSets: 3, targetReps: 12, targetWeight: 12),
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
          ExerciseTemplate(name: '双杠臂屈伸', category: '胸肌与三头', targetSets: 3, targetReps: 10),
          ExerciseTemplate(name: '俯卧撑', category: '胸肌与三头', targetSets: 3, targetReps: 15),
          ExerciseTemplate(name: '蝴蝶机夹胸', category: '胸肌与三头', targetSets: 3, targetReps: 12, targetWeight: 30),
        ],
      ),
    ],
  ),
  PlanTemplate(
    id: 'back_focus',
    name: '背部训练计划',
    description: '专注于背阔肌和核心的训练计划',
    cycleDays: 3,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '引体向上', category: '背部与二头', targetSets: 4, targetReps: 6),
          ExerciseTemplate(name: '杠铃划船', category: '背部与二头', targetSets: 4, targetReps: 8, targetWeight: 50),
          ExerciseTemplate(name: '单臂哑铃划船', category: '背部与二头', targetSets: 3, targetReps: 10, targetWeight: 20),
          ExerciseTemplate(name: '硬拉', category: '背部与二头', targetSets: 3, targetReps: 8, targetWeight: 80),
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
          ExerciseTemplate(name: '背阔肌下拉', category: '背部与二头', targetSets: 3, targetReps: 10, targetWeight: 40),
          ExerciseTemplate(name: '坐姿划船', category: '背部与二头', targetSets: 3, targetReps: 10, targetWeight: 35),
          ExerciseTemplate(name: '山羊挺身', category: '背部与二头', targetSets: 3, targetReps: 12),
        ],
      ),
    ],
  ),
  PlanTemplate(
    id: 'leg_focus',
    name: '腿部训练计划',
    description: '针对大腿和臀部的训练计划',
    cycleDays: 3,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '深蹲', category: '肩部与臀腿', targetSets: 4, targetReps: 8, targetWeight: 80),
          ExerciseTemplate(name: '腿举', category: '肩部与臀腿', targetSets: 4, targetReps: 10, targetWeight: 120),
          ExerciseTemplate(name: '腿弯举', category: '肩部与臀腿', targetSets: 3, targetReps: 12, targetWeight: 30),
          ExerciseTemplate(name: '提踵', category: '肩部与臀腿', targetSets: 3, targetReps: 15, targetWeight: 40),
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
          ExerciseTemplate(name: '硬拉', category: '肩部与臀腿', targetSets: 4, targetReps: 6, targetWeight: 90),
          ExerciseTemplate(name: '箭步蹲', category: '肩部与臀腿', targetSets: 3, targetReps: 10, targetWeight: 20),
          ExerciseTemplate(name: '腿外展', category: '肩部与臀腿', targetSets: 3, targetReps: 12, targetWeight: 25),
        ],
      ),
    ],
  ),
  PlanTemplate(
    id: 'full_body',
    name: '全身训练计划',
    description: '简洁高效的全身训练计划',
    cycleDays: 2,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '深蹲', category: '肩部与臀腿', targetSets: 4, targetReps: 8, targetWeight: 60),
          ExerciseTemplate(name: '卧推', category: '胸肌与三头', targetSets: 4, targetReps: 8, targetWeight: 50),
          ExerciseTemplate(name: '划船', category: '背部与二头', targetSets: 4, targetReps: 8, targetWeight: 40),
          ExerciseTemplate(name: '肩部推举', category: '肩部', targetSets: 3, targetReps: 10, targetWeight: 25),
          ExerciseTemplate(name: '硬拉', category: '背部与二头', targetSets: 3, targetReps: 8, targetWeight: 60),
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
    id: 'dumbbell_home',
    name: '哑铃训练计划',
    description: '适合居家使用的哑铃训练计划',
    cycleDays: 3,
    days: [
      DayTemplate(
        dayIndex: 0,
        isRestDay: false,
        exercises: [
          ExerciseTemplate(name: '哑铃深蹲', category: '肩部与臀腿', targetSets: 3, targetReps: 12, targetWeight: 16),
          ExerciseTemplate(name: '哑铃卧推', category: '胸肌与三头', targetSets: 3, targetReps: 10, targetWeight: 16),
          ExerciseTemplate(name: '哑铃划船', category: '背部与二头', targetSets: 3, targetReps: 10, targetWeight: 14),
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
          ExerciseTemplate(name: '哑铃硬拉', category: '背部与二头', targetSets: 3, targetReps: 12, targetWeight: 18),
          ExerciseTemplate(name: '哑铃飞鸟', category: '胸肌与三头', targetSets: 3, targetReps: 12, targetWeight: 10),
          ExerciseTemplate(name: '哑铃弯举', category: '手臂', targetSets: 3, targetReps: 12, targetWeight: 8),
          ExerciseTemplate(name: '三头肌臂屈伸', category: '手臂', targetSets: 3, targetReps: 12, targetWeight: 8),
        ],
      ),
    ],
  ),
];
