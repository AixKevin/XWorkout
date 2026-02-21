import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xworkout/core/router/app_router.dart';
import 'package:xworkout/core/theme/app_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:xworkout/features/data/backup_service.dart';

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
    return CupertinoApp.router(
      title: 'XWorkout',
      theme: AppTheme.lightTheme,
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
