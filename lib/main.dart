import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/router/app_router.dart';
import 'package:xworkout/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:xworkout/features/data/backup_service.dart';
import 'package:xworkout/features/settings/app_settings_repository.dart';

void main() {
  runApp(
    const ProviderScope(
      child: XWorkoutApp(),
    ),
  );
}

class XWorkoutApp extends ConsumerStatefulWidget {
  const XWorkoutApp({super.key});

  @override
  ConsumerState<XWorkoutApp> createState() => _XWorkoutAppState();
}

class _XWorkoutAppState extends ConsumerState<XWorkoutApp> {
  @override
  void initState() {
    super.initState();
    // Initialize services
    ref.read(backupServiceProvider).init();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    
    // Determine theme based on setting
    final CupertinoThemeData theme;
    switch (themeMode) {
      case 'dark':
        theme = AppTheme.darkTheme;
        break;
      case 'light':
        theme = AppTheme.lightTheme;
        break;
      case 'system':
      default:
        // Use light as default but allow system to override via platform
        theme = AppTheme.lightTheme;
    }

    return CupertinoApp.router(
      title: 'XWorkout',
      theme: theme,
      routerConfig: appRouter,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('zh', 'CN'),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
