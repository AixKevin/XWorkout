import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Material, Icons, Colors;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:xworkout/core/database/database.dart';
import 'package:xworkout/features/history/data/history_repository.dart';
import 'package:xworkout/features/history/presentation/history_detail_screen.dart';
import 'package:xworkout/shared/widgets/async_value_widget.dart';
import 'package:xworkout/shared/widgets/empty_state.dart';

enum ViewMode { list, calendar }

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  ViewMode _viewMode = ViewMode.calendar;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  List<DailyRecord> _getEventsForDay(DateTime day, List<DailyRecord> records) {
    return records.where((record) {
      return isSameDay(record.date, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyStreamProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: CupertinoSlidingSegmentedControl<ViewMode>(
          groupValue: _viewMode,
          children: const {
            ViewMode.list: Text('列表'),
            ViewMode.calendar: Text('日历'),
          },
          onValueChanged: (ViewMode? value) {
            if (value != null) {
              setState(() {
                _viewMode = value;
              });
            }
          },
        ),
      ),
      child: SafeArea(
        child: AsyncValueWidget<List<DailyRecord>>(
          value: historyAsync,
          data: (records) {
            if (records.isEmpty && _viewMode == ViewMode.list) {
              return const EmptyStateWidget(
                  icon: Icons.book,
                title: '暂无训练记录',
              );
            }

            return _viewMode == ViewMode.list
                ? _buildListView(records)
                : _buildCalendarView(records);
          },
        ),
      ),
    );
  }

  Widget _buildListView(List<DailyRecord> records) {
    final grouped = <String, List<DailyRecord>>{};
    for (var record in records) {
      final month = DateFormat('yyyy年M月', 'zh_CN').format(record.date);
      if (!grouped.containsKey(month)) {
        grouped[month] = [];
      }
      grouped[month]!.add(record);
    }

    return CustomScrollView(
      slivers: grouped.entries.map((entry) {
        return SliverToBoxAdapter(
          child: CupertinoListSection.insetGrouped(
            header: Text(entry.key),
            children: entry.value.map((record) {
              return _HistoryItem(record: record);
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarView(List<DailyRecord> records) {
    final currentMonthRecords = records.where((r) => 
      r.date.year == _focusedDay.year && r.date.month == _focusedDay.month
    ).toList();
    
    final completedCount = currentMonthRecords.where((r) => 
      r.status == 'completed' || r.status == 'normal'
    ).length;
    final totalCount = currentMonthRecords.length;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '本月完成 $completedCount/$totalCount 次',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Material(
            color: CupertinoColors.systemBackground,
            child: TableCalendar<DailyRecord>(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: CalendarFormat.month,
              eventLoader: (day) => _getEventsForDay(day, records),
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  final events = _getEventsForDay(day, records);
                  if (events.isEmpty) return null;
                  
                  final record = events.first;
                  // Skip marking rest days
                  if (record.status == 'rest') return null;

                  Color? bgColor;
                  Color textColor = CupertinoColors.label;

                  if (record.status == 'skipped') {
                    bgColor = CupertinoColors.systemOrange;
                    textColor = CupertinoColors.white;
                  } else if (record.status == 'completed' || record.status == 'normal') {
                    bgColor = CupertinoColors.activeGreen;
                    textColor = CupertinoColors.white;
                  } else if (record.status == 'in_progress') {
                     bgColor = CupertinoColors.activeBlue;
                     textColor = CupertinoColors.white;
                  } else {
                     // Default to blue for other statuses if not rest
                     bgColor = CupertinoColors.activeBlue;
                     textColor = CupertinoColors.white;
                  }
                  
                  if (bgColor != null) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }
                  return null;
                },
                selectedBuilder: (context, day, focusedDay) {
                  // Keep the color of the day if it has status, but add selection border/style?
                  // Or override. If I override, I lose status color.
                  // But usually selection is temporary.
                  // Let's check if it has event.
                  final events = _getEventsForDay(day, records);
                  Color? bgColor = CupertinoColors.systemGrey3;
                  if (events.isNotEmpty) {
                    final record = events.first;
                     if (record.status == 'skipped') {
                      bgColor = CupertinoColors.systemOrange;
                    } else if (record.status == 'completed' || record.status == 'normal') {
                      bgColor = CupertinoColors.activeGreen;
                    } else if (record.status == 'in_progress') {
                       bgColor = CupertinoColors.activeBlue;
                    }
                  }

                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: CupertinoColors.activeBlue, width: 2), // Selection indicator
                    ),
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: CupertinoColors.white),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                   return Container(
                    margin: const EdgeInsets.all(6.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: CupertinoColors.activeBlue.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: CupertinoColors.activeBlue),
                    ),
                  );
                },
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                
                final events = _getEventsForDay(selectedDay, records);
                if (events.isNotEmpty) {
                   Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => HistoryDetailScreen(record: events.first),
                    ),
                  );
                }
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final DailyRecord record;

  const _HistoryItem({required this.record});

  @override
  Widget build(BuildContext context) {
    final isCompleted = record.status == 'normal' || record.status == 'completed';
    final isSkipped = record.status == 'skipped';
    
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (isSkipped) {
      statusColor = CupertinoColors.systemRed;
      statusIcon = Icons.cancel;
      statusText = '请假';
    } else if (isCompleted) {
      statusColor = CupertinoColors.activeGreen;
      statusIcon = Icons.check_circle;
      statusText = '完成';
    } else {
      statusColor = CupertinoColors.systemGrey;
      statusIcon = Icons.radio_button_unchecked;
      statusText = record.status;
    }

    return CupertinoListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(statusIcon, color: statusColor, size: 20),
      ),
      title: Text(
        DateFormat('MM月dd日 EEEE', 'zh_CN').format(record.date),
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        isSkipped ? (record.skipReason ?? '无理由') : statusText,
        style: TextStyle(
          color: isSkipped ? CupertinoColors.systemRed : CupertinoColors.secondaryLabel,
          fontSize: 13,
        ),
      ),
      trailing: const Icon(CupertinoIcons.chevron_right, color: Colors.grey, size: 28),
      onTap: () {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => HistoryDetailScreen(record: record),
          ),
        );
      },
    );
  }
}
