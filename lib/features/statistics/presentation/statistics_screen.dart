import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon, IconData;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:xworkout/features/statistics/data/statistics_repository.dart';
import 'package:intl/intl.dart';

// Providers
final totalWorkoutsProvider = FutureProvider.autoDispose<int>((ref) => ref.watch(statisticsRepositoryProvider).getTotalWorkouts());
final thisWeekWorkoutsProvider = FutureProvider.autoDispose<int>((ref) => ref.watch(statisticsRepositoryProvider).getThisWeekWorkouts());
final currentStreakProvider = FutureProvider.autoDispose<int>((ref) => ref.watch(statisticsRepositoryProvider).getCurrentStreak());
final volumeTrendProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) => ref.watch(statisticsRepositoryProvider).getVolumeTrend(30));

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
              // Overview Cards
              Row(
                children: [
                  Expanded(
                    child: _OverviewCard(
                      title: '总训练',
                      provider: totalWorkoutsProvider,
                      icon: Icons.fitness_center,
                      color: CupertinoColors.activeBlue,
                      unit: '次',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OverviewCard(
                      title: '本周',
                      provider: thisWeekWorkoutsProvider,
                      icon: Icons.calendar_today,
                      color: CupertinoColors.activeGreen,
                      unit: '次',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _OverviewCard(
                      title: '当前连胜',
                      provider: currentStreakProvider,
                      icon: Icons.local_fire_department,
                      color: CupertinoColors.activeOrange,
                      unit: '天',
                    ),
                  ),
                  const SizedBox(width: 12),
                   // Placeholder for alignment or another stat
                   const Spacer(), 
                ],
              ),
              
              const SizedBox(height: 24),
              const Text(
                '近30天训练量趋势',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Chart
              Container(
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Consumer(
                  builder: (context, ref, child) {
                    final trendAsync = ref.watch(volumeTrendProvider);
                    
                    return trendAsync.when(
                      data: (data) {
                        if (data.isEmpty) {
                          return const Center(child: Text('暂无数据'));
                        }
                        return _VolumeChart(data: data);
                      },
                      loading: () => const Center(child: CupertinoActivityIndicator()),
                      error: (e, _) => Center(child: Text('加载失败: $e')),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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

class _VolumeChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _VolumeChart({required this.data});

  @override
  Widget build(BuildContext context) {
    // Prepare spots
    // We map dates to indices (0 to 29) for X axis
    // But data might be sparse.
    // Better to just show last N points if we have them, or map strict dates.
    
    // Simplification: Map all data points sorted by date.
    final spots = <FlSpot>[];
    double maxVolume = 0;
    
    for (int i = 0; i < data.length; i++) {
      final volume = (data[i]['volume'] as num).toDouble();
      if (volume > maxVolume) maxVolume = volume;
      spots.add(FlSpot(i.toDouble(), volume));
    }

    if (maxVolume == 0) maxVolume = 100;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxVolume / 5,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: CupertinoColors.systemGrey5,
              strokeWidth: 1,
            );
          },
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
                    child: Text(
                      DateFormat('MM/dd').format(date),
                      style: const TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 10,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: maxVolume / 5,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('');
                return Text(
                  value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : value.toInt().toString(),
                  style: const TextStyle(
                    color: CupertinoColors.systemGrey,
                    fontSize: 10,
                  ),
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (data.length - 1).toDouble(),
        minY: 0,
        maxY: maxVolume * 1.1,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: CupertinoColors.activeBlue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: CupertinoColors.activeBlue.withOpacity(0.1),
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
                         text: '${spot.y.toInt()} kg',
                         style: const TextStyle(
                           fontWeight: FontWeight.bold,
                           color: CupertinoColors.white,
                         ),
                       ),
                     ],
                   );
                }
                return null;
              }).toList();
            },
            tooltipRoundedRadius: 8,
            tooltipPadding: const EdgeInsets.all(8),
            // tooltipBgColor: CupertinoColors.black.withOpacity(0.8), // Deprecated? Check API.
            // Using decoration instead if newer version. 
            // `tooltipBgColor` is likely deprecated in favor of `getTooltipColor`.
            getTooltipColor: (spot) => CupertinoColors.black.withOpacity(0.8),
          ),
        ),
      ),
    );
  }
}
