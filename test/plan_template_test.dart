import 'package:flutter_test/flutter_test.dart';
import 'package:xworkout/features/templates/data/plan_templates.dart';

void main() {
  group('PlanTemplate', () {
    test('toJson and fromJson should work correctly', () {
      const template = PlanTemplate(
        id: 'test_id',
        name: 'Test Plan',
        description: 'Test Description',
        cycleDays: 3,
        days: [
          DayTemplate(
            dayIndex: 0,
            isRestDay: false,
            exercises: [
              ExerciseTemplate(
                name: 'Squat',
                category: 'Legs',
                targetSets: 3,
                targetReps: 10,
                targetWeight: 100.0,
              ),
            ],
          ),
          DayTemplate(
            dayIndex: 1,
            isRestDay: true,
            exercises: [],
          ),
        ],
        isCustom: true,
      );

      final json = template.toJson();
      final fromJson = PlanTemplate.fromJson(json);

      expect(fromJson.id, template.id);
      expect(fromJson.name, template.name);
      expect(fromJson.description, template.description);
      expect(fromJson.cycleDays, template.cycleDays);
      expect(fromJson.isCustom, template.isCustom);
      expect(fromJson.days.length, template.days.length);
      
      expect(fromJson.days[0].dayIndex, template.days[0].dayIndex);
      expect(fromJson.days[0].isRestDay, template.days[0].isRestDay);
      expect(fromJson.days[0].exercises.length, template.days[0].exercises.length);
      
      expect(fromJson.days[0].exercises[0].name, template.days[0].exercises[0].name);
      expect(fromJson.days[0].exercises[0].targetWeight, template.days[0].exercises[0].targetWeight);
    });
  });
}
