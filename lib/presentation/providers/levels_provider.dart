import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelsProvider = FutureProvider<List<String>>((ref) async {
  final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

  final levelPaths = manifest
      .listAssets()
      .where((String key) => key.contains('lib/data/levels/level_'))
      .toList();

  final levels = levelPaths.map((path) {
    final levelId = path.split('/').last.replaceAll('level_', '').replaceAll('.json', '');
    return levelId;
  }).toList();

  // Sort numerically (supports fractional levels like 0.1, 0.2)
  levels.sort((a, b) {
    final aNum = double.tryParse(a) ?? 0;
    final bNum = double.tryParse(b) ?? 0;
    return aNum.compareTo(bNum);
  });

  return levels;
});
