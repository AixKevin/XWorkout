import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.today),
            label: '今日',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.sportscourt),
            label: '训练',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.ellipsis),
            label: '更多',
          ),
        ],
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        currentIndex: navigationShell.currentIndex,
      ),
      tabBuilder: (context, index) {
        return navigationShell;
      },
    );
  }
}
