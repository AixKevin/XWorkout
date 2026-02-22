import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon, IconData, CircularProgressIndicator;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:xworkout/features/statistics/data/statistics_repository.dart';
import 'package:intl/intl.dart';

// Providers
final totalWorkoutsProvider = FutureProvider.autoDispose<int>((ref) => ref.watch(statisticsRepositoryProvider).getTotalWorkouts());
final thisWeekWorkoutsProvider = FutureProvider.autoDispose<int>((ref) => ref.watch(statisticsRepositoryProvider).getThisWeekWorkouts());
final currentStreakProvider = FutureProvider.autoDispose<int>((ref) => ref.watch(statisticsRepositoryProvider).getCurrentStreak());
final volumeTrendProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) => ref.watch(statisticsRepositoryProvider).getVolumeTrend(30));
final topExercisesProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) => ref.watch(statisticsRepositoryProvider).getTopExercises(5));
final weeklyGoalProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) => ref.watch(statisticsRepositoryProvider).getWeeklyGoalProgress(target: 3));

final exerciseStatsProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, exerciseId) => ref.watch(statisticsRepositoryProvider).getExerciseStats(exerciseId));

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('数据统计'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Goal Card
              const _WeeklyGoalCard(),
              const SizedBox(height: 16),

              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _OverviewCard(
                      title: '总训练',
                      provider: totalWorkoutsProvider,
                      icon: CupertinoIcons.circle_grid_hex_fill,
                      color: CupertinoColors.activeBlue,
                      unit: '次',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OverviewCard(
                      title: '当前连胜',
                      provider: currentStreakProvider,
                      icon: CupertinoIcons.flame_fill,
                      color: CupertinoColors.activeOrange,
                      unit: '天',
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              const _SectionHeader('最近趋势'),
              const SizedBox(height: 12),
              
              // Volume Chart
              Container(
                height: 250,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('总训练量 (kg)', style: TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final trendAsync = ref.watch(volumeTrendProvider);
                          return trendAsync.when(
                            data: (data) => data.isEmpty 
                                ? const Center(child: Text('暂无数据')) 
                                : _SimpleLineChart(data: data, yKey: 'volume', color: CupertinoColors.activeBlue),
                            loading: () => const Center(child: CupertinoActivityIndicator()),
                            error: (e, _) => Center(child: Text('加载失败: $e')),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const _SectionHeader('常练项目'),
              const SizedBox(height: 12),
              const _TopExercisesList(),


              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _WeeklyGoalCard extends ConsumerWidget {
  const _WeeklyGoalCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalAsync = ref.watch(weeklyGoalProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: goalAsync.when(
        data: (data) {
          final current = data['current'] as int;
          final target = data['target'] as int;
          final progress = data['progress'] as double;
          
          return Row(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: progress,
                      backgroundColor: CupertinoColors.systemGrey6,
                      color: CupertinoColors.activeGreen,
                      strokeWidth: 6,
                    ),
                  ),
                  Icon(
                    progress >= 1.0 ? Icons.check : Icons.directions_run,
                    color: progress >= 1.0 ? CupertinoColors.activeGreen : CupertinoColors.systemGrey,
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('本周目标', style: TextStyle(color: CupertinoColors.secondaryLabel)),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$current',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.label,
                        ),
                      ),
                      Text(
                        ' / $target 次',
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
        loading: () => const SizedBox(height: 80, child: Center(child: CupertinoActivityIndicator())),
        error: (_, __) => const SizedBox(height: 80, child: Center(child: Text('加载失败'))),
      ),
    );
  }
}

class _OverviewCard extends ConsumerWidget {
  final String title;
  final AutoDisposeFutureProvider<int> provider;
  final IconData icon;
  final Color color;
  final String unit;

  const _OverviewCard({
    required this.title,
    required this.provider,
    required this.icon,
    required this.color,
    required this.unit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final valueAsync = ref.watch(provider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          valueAsync.when(
            data: (value) => Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ],
            ),
            loading: () => const CupertinoActivityIndicator(),
            error: (_, __) => const Text('--'),
          ),
        ],
      ),
    );
  }
}



class _TopExercisesList extends ConsumerWidget {
  const _TopExercisesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(topExercisesProvider);
    
    return listAsync.when(
      data: (data) {
        if (data.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: CupertinoColors.white, borderRadius: BorderRadius.circular(12)),
            child: const Center(child: Text('暂无数据')),
          );
        }
        return Column(
          children: data.map((item) {
            return GestureDetector(
              onTap: () {
                _showExerciseStats(context, item['id'], item['name']);
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGroupedBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${data.indexOf(item) + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          Text(
                            '共训练 ${item['count']} 次',
                            style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    const Icon(CupertinoIcons.chevron_right, color: CupertinoColors.systemGrey4),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CupertinoActivityIndicator()),
      error: (_, __) => const Text('加载失败'),
    );
  }

  void _showExerciseStats(BuildContext context, String exerciseId, String exerciseName) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _ExerciseStatsSheet(exerciseId: exerciseId, exerciseName: exerciseName),
    );
  }
}



class _SimpleLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String yKey;
  final Color color;
  final bool showPoints;

  const _SimpleLineChart({
    required this.data, 
    required this.yKey, 
    required this.color,
    this.showPoints = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine min/max Y for scaling
    double minY = double.infinity;
    double maxY = double.negativeInfinity;
    
    for (var item in data) {
      final val = (item[yKey] as num).toDouble();
      if (val < minY) minY = val;
      if (val > maxY) maxY = val;
    }
    
    if (minY == double.infinity) minY = 0;
    if (maxY == double.negativeInfinity) maxY = 100;
    
    // Add some padding
    final range = maxY - minY;
    final padding = range == 0 ? maxY * 0.1 : range * 0.1;
    minY = (minY - padding).clamp(0, double.infinity);
    maxY += padding;
    if (maxY == minY) maxY += 10;

    final spots = <FlSpot>[];
    for (int i = 0; i < data.length; i++) {
       spots.add(FlSpot(i.toDouble(), (data[i][yKey] as num).toDouble()));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxY - minY) / 4,
          getDrawingHorizontalLine: (value) => FlLine(color: CupertinoColors.systemGrey6, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: (data.length / 5).ceilToDouble(),
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  final date = data[index]['date'] as DateTime;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(DateFormat('MM/dd').format(date), style: const TextStyle(fontSize: 10, color: CupertinoColors.secondaryLabel)),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: (maxY - minY) / 4,
              getTitlesWidget: (value, meta) {
                if (value == minY && minY == 0) return const Text(''); 
                return Text(value.toStringAsFixed(1), style: const TextStyle(fontSize: 10, color: CupertinoColors.secondaryLabel));
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: color,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: showPoints),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.x.toInt();
                 if (index >= 0 && index < data.length) {
                   final date = data[index]['date'] as DateTime;
                   return LineTooltipItem(
                     '${DateFormat('MM/dd').format(date)}\n',
                     const TextStyle(color: CupertinoColors.white),
                     children: [
                       TextSpan(
                         text: spot.y.toStringAsFixed(1),
                         style: const TextStyle(fontWeight: FontWeight.bold, color: CupertinoColors.white),
                       ),
                     ],
                   );
                 }
                 return null;
              }).toList();
            },
            getTooltipColor: (_) => CupertinoColors.black.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}

class _ExerciseStatsSheet extends ConsumerWidget {
  final String exerciseId;
  final String exerciseName;

  const _ExerciseStatsSheet({required this.exerciseId, required this.exerciseName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(exerciseStatsProvider(exerciseId));

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: CupertinoColors.systemGroupedBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: CupertinoColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: CupertinoColors.separator, width: 0.5)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(exerciseName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(CupertinoIcons.xmark_circle_fill, color: CupertinoColors.systemGrey3),
                ),
              ],
            ),
          ),
          Expanded(
            child: statsAsync.when(
              data: (data) {
                final maxWeight = (data['maxWeight'] as num).toDouble();
                final totalVolume = (data['totalVolume'] as num).toDouble();
                final maxWeightTrend = data['maxWeightTrend'] as List<Map<String, dynamic>>;
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _StatBox(
                              title: '最大重量', 
                              value: '${maxWeight.toStringAsFixed(1)} kg',
                              icon: Icons.vertical_align_top,
                              color: CupertinoColors.systemRed,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatBox(
                              title: '总容量', 
                              value: '${(totalVolume / 1000).toStringAsFixed(1)}k kg',
                              icon: Icons.layers,
                              color: CupertinoColors.systemPurple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        height: 300,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('最大重量趋势', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            Expanded(
                              child: _SimpleLineChart(
                                data: maxWeightTrend, 
                                yKey: 'value', 
                                color: CupertinoColors.systemRed,
                                showPoints: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (e, _) => Center(child: Text('加载失败: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatBox({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(title, style: const TextStyle(color: CupertinoColors.secondaryLabel, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
