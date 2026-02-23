#!/usr/bin/env dart
// Version Sync Script
// Run: dart scripts/sync_version.dart
// This script syncs version from pubspec.yaml to all other files

import 'dart:io';

void main() async {
  print('🔄 Starting version sync...\n');

  // Read version from pubspec.yaml
  final pubspecFile = File('pubspec.yaml');
  final pubspecContent = await pubspecFile.readAsString();
  
  final versionMatch = RegExp(r'^version:\s*(\S+)$', multiLine: true).firstMatch(pubspecContent);
  if (versionMatch == null) {
    print('❌ ERROR: Could not find version in pubspec.yaml');
    exit(1);
  }
  
  final version = versionMatch.group(1)!;
  final versionParts = version.split('.');
  final buildNumber = versionParts.length > 2 ? versionParts[2] : '0';
  final buildNumberInt = int.tryParse(buildNumber) ?? 0;
  
  print('📦 Found version: $version (Build $buildNumberInt)\n');

  // Files to update
  final filesToUpdate = <String, List<VersionReplacement>>{
    'lib/features/more/presentation/more_screen.dart': [
      VersionReplacement(
        pattern: RegExp(r"'XWorkout v[\d.]+'"),
        replacement: "'XWorkout v$version'",
      ),
      VersionReplacement(
        pattern: RegExp(r"'Build \d+'"),
        replacement: "'Build $buildNumberInt'",
      ),
      VersionReplacement(
        pattern: RegExp(r'版本:\s*[\d.]+\s*\(Build\s*\d+\)'),
        replacement: '版本: $version (Build $buildNumberInt)',
      ),
    ],
    'README.md': [
      VersionReplacement(
        pattern: RegExp(r'!\[Version\]\(https://img\.shields\.io/badge/version-[\d.]+-brightgreen\)'),
        replacement: '![Version](https://img.shields.io/badge/version-$version-brightgreen)',
      ),
      VersionReplacement(
        pattern: RegExp(r'### v[\d.]+ \(\d{4}-\d{2}-\d{2}\)'),
        replacement: '### v$version (${_formatDate(DateTime.now())})',
        isFirst: true,
      ),
    ],
  };

  int updateCount = 0;

  // Update more_screen.dart
  final moreScreenFile = File('lib/features/more/presentation/more_screen.dart');
  if (await moreScreenFile.exists()) {
    var content = await moreScreenFile.readAsString();
    for (final replacement in filesToUpdate['lib/features/more/presentation/more_screen.dart']!) {
      content = content.replaceFirst(replacement.pattern, replacement.replacement);
    }
    await moreScreenFile.writeAsString(content);
    updateCount++;
    print('✅ Updated lib/features/more/presentation/more_screen.dart');
  }

  // Update README.md
  final readmeFile = File('README.md');
  if (await readmeFile.exists()) {
    var content = await readmeFile.readAsString();
    for (final replacement in filesToUpdate['README.md']!) {
      if (replacement.isFirst) {
        // For changelog, we need to add new entry at the top
        final newEntry = '### v$version (${_formatDate(DateTime.now())})\n- 更新内容待填写\n\n';
        content = content.replaceFirst(
          RegExp(r'(## 📝 更新日志\n\n)'),
          '\$1$newEntry'
        );
      } else {
        content = content.replaceFirst(replacement.pattern, replacement.replacement);
      }
    }
    await readmeFile.writeAsString(content);
    updateCount++;
    print('✅ Updated README.md');
  }

  print('\n✅ Version sync complete! Updated $updateCount files.');
  print('📝 Please update the changelog entry with actual changes.\n');
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

class VersionReplacement {
  final RegExp pattern;
  final String replacement;
  final bool isFirst;

  VersionReplacement({
    required this.pattern,
    required this.replacement,
    this.isFirst = false,
  });
}
