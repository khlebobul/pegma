import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final levelsProvider = FutureProvider<List<int>>((ref) async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);

  final levelPaths = manifestMap.keys
      .where((String key) => key.contains('lib/data/levels/level_'))
      .toList();

  final levels = levelPaths.map((path) {
    final levelNumber = int.parse(
      path.split('/').last.replaceAll('level_', '').replaceAll('.json', ''),
    );
    return levelNumber;
  }).toList()..sort();

  return levels;
});
