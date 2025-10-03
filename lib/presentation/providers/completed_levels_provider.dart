import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/core/database/database_helper.dart';

final completedLevelsProvider = FutureProvider<List<int>>((ref) async {
  final db = DatabaseHelper.instance;
  return await db.getCompletedLevelIds();
});

final isLevelCompletedProvider = FutureProvider.family<bool, int>((
  ref,
  levelId,
) async {
  final db = DatabaseHelper.instance;
  return await db.isLevelCompleted(levelId);
});
