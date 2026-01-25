import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/core/database/database_helper.dart';

final completedLevelsProvider = FutureProvider<List<String>>((ref) async {
  final db = DatabaseHelper.instance;
  return await db.getCompletedLevelIds();
});

final isLevelCompletedProvider = FutureProvider.family<bool, String>((
  ref,
  levelId,
) async {
  final db = DatabaseHelper.instance;
  return await db.isLevelCompleted(levelId);
});
