import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xworkout/features/templates/data/plan_templates.dart';

final userTemplateRepositoryProvider = Provider<UserTemplateRepository>((ref) {
  return UserTemplateRepository();
});

class UserTemplateRepository {
  static const String _storageKey = 'user_plan_templates';

  Future<List<PlanTemplate>> getUserTemplates() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);
    
    if (jsonString == null) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList
          .map((e) => PlanTemplate.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTemplate(PlanTemplate template) async {
    final prefs = await SharedPreferences.getInstance();
    final templates = await getUserTemplates();
    
    // Check if template with same ID exists
    final index = templates.indexWhere((t) => t.id == template.id);
    if (index >= 0) {
      templates[index] = template;
    } else {
      templates.add(template);
    }

    final jsonList = templates.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }

  Future<void> deleteTemplate(String templateId) async {
    final prefs = await SharedPreferences.getInstance();
    final templates = await getUserTemplates();
    
    templates.removeWhere((t) => t.id == templateId);
    
    final jsonList = templates.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(jsonList));
  }
}
