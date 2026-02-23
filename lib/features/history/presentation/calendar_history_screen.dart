import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Colors, Scaffold;
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:xworkout/core/database/database_provider.dart';
import 'package:xworkout/features/workout/data/workout_providers.dart';
import 'package:xworkout/features/training/presentation/providers/exercise_provider.dart';

class CalendarHistoryScreen extends ConsumerStatefulWidget {
  const CalendarHistoryScreen({super.key});

  @override
  ConsumerState<CalendarHistoryScreen> createState() => _CalendarHistoryScreenState();
}

class _CalendarHistoryScreenState extends ConsumerState<CalendarHistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final sessionsAsync = ref.watch(workoutSessionsProvider);
    final typesAsync = ref.watch(workoutTypesProvider);

    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('日历视图'),
        backgroundColor: CupertinoColors.systemBackground,
      ),
      body: SafeArea(
        child: sessionsAsync.when(
          data: (sessions) => _buildCalendar(sessions, typesAsync),
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text('错误: $e')),
        ),
      ),
    );
  }

  Widget _buildCalendar(List<WorkoutSession> sessions, AsyncValue<List<WorkoutType>> typesAsync) {
    final sessionMap = <DateTime, List<WorkoutSession>>{};
    for (final session in sessions) {
      final date = DateTime(session.date.year, session.date.month, session.date.day);
      sessionMap.putIfAbsent(date, () => []).add(session);
    }

    return Column(
      children: [
        Container(
          color: CupertinoColors.systemBackground,
          child: TableCalendar<WorkoutSession>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            eventLoader: (day) {
              final date = DateTime(day.year, day.month, day.day);
              return sessionMap[date] ?? [];
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final events = sessionMap[DateTime(day.year, day.month, day.day)] ?? [];
                if (events.isEmpty) return null;
                return Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Text(day.day.toString(), style: const TextStyle(color: Colors.white)),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: Text(day.day.toString(), style: const TextStyle(color: Colors.white)),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Text(day.day.toString(), style: const TextStyle(color: Colors.blue)),
                );
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
          ),
        ),
        Expanded(
          child: _selectedDay != null 
            ? _buildDayDetail(sessionMap[DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)] ?? [], typesAsync) 
            : const Center(child: Text('选择一天查看详情')),
        ),
      ],
    );
  }

  Widget _buildDayDetail(List<WorkoutSession> sessions, AsyncValue<List<WorkoutType>> typesAsync) {
    if (sessions.isEmpty) {
      return const Center(child: Text('当天无训练记录', style: TextStyle(color: Colors.grey)));
    }

    return typesAsync.when(
      data: (types) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sessions.length,
        itemBuilder: (context, index) {
          final session = sessions[index];
          final type = types.where((t) => t.id == session.typeId).firstOrNull;
          return GestureDetector(
            onTap: () => _showSessionDetail(context, session),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey5),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.fitness_center, color: Colors.blue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(type?.name ?? '训练', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                        Text(DateFormat('HH:mm').format(session.date), style: const TextStyle(color: Colors.grey, fontSize: 14)),
                        if (session.note != null && session.note!.isNotEmpty)
                          Text(session.note!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      ],
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          );
        },
      ),
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (e, _) => Center(child: Text('错误: $e')),
    );
  }

  void _showSessionDetail(BuildContext context, WorkoutSession session) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => _SessionDetailPage(session: session),
      ),
    );
  }
}

class _SessionDetailPage extends ConsumerWidget {
  final WorkoutSession session;
  const _SessionDetailPage({required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(sessionSetsProvider(session.id));
    final exercisesAsync = ref.watch(exerciseListProvider);

    return Scaffold(
      appBar: const CupertinoNavigationBar(
        middle: Text('训练详情'),
        backgroundColor: CupertinoColors.systemBackground,
      ),
      body: SafeArea(
        child: setsAsync.when(
          data: (sets) {
            final grouped = <String, List<WorkoutSet>>{};
            for (final set in sets) {
              grouped.putIfAbsent(set.exerciseId, () => []).add(set);
            }
            if (grouped.isEmpty) {
              return const Center(child: Text('暂无数据'));
            }
            return exercisesAsync.when(
              data: (exercises) => ListView(
                padding: const EdgeInsets.all(16),
                children: grouped.entries.map((entry) {
                  final exercise = exercises.where((e) => e.id == entry.key).firstOrNull;
                  return _ExerciseDetailCard(
                    exerciseName: exercise?.name ?? '未知动作',
                    sets: entry.value,
                  );
                }).toList(),
              ),
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) => Center(child: Text('错误: $e')),
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text('错误: $e')),
        ),
      ),
    );
  }
}

class _ExerciseDetailCard extends StatelessWidget {
  final String exerciseName;
  final List<WorkoutSet> sets;
  const _ExerciseDetailCard({required this.exerciseName, required this.sets});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CupertinoColors.systemGrey5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(exerciseName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ...sets.map((set) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(width: 30, child: Text('${set.setNumber}.', style: const TextStyle(color: Colors.grey))),
                Expanded(child: Text('${set.weight.isEmpty ? "-" : set.weight} × ${set.reps}次', style: const TextStyle(fontSize: 15))),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
