import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pegma/core/services/review_service.dart';

final reviewServiceProvider = Provider<ReviewService>((ref) {
  return ReviewService();
});

