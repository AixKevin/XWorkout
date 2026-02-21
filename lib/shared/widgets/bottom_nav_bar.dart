import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Icon;
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          Expanded(child: navigationShell),
          CupertinoTabBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.today),
                label: '今日',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.fitness_center),
                label: '训练',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: '更多',
              ),
            ],
            currentIndex: navigationShell.currentIndex,
            onTap: (index) => _onTap(index),
          ),
        ],
      ),
    );
  }

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
