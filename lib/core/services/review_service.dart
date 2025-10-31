import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pegma/core/constants/app_constants.dart';
import 'package:pegma/core/utils/market_helper.dart';

class ReviewService {
  final InAppReview _inAppReview = InAppReview.instance;

  Future<bool> onLevelEntry() async {
    if (!MarketHelper.shouldShowRating()) {
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    final currentCount = prefs.getInt(ReviewConsts.levelEntriesCountKey) ?? 0;
    final newCount = currentCount + 1;
    await prefs.setInt(ReviewConsts.levelEntriesCountKey, newCount);
    if (newCount >= ReviewConsts.levelEntriesToShowReview) {
      return await _requestReviewIfAllowed(prefs);
    }
    return false;
  }

  Future<bool> _requestReviewIfAllowed(SharedPreferences prefs) async {
    if (!await _inAppReview.isAvailable()) {
      return false;
    }
    final lastRequestDateString = prefs.getString(
      ReviewConsts.lastReviewRequestDateKey,
    );
    if (lastRequestDateString != null) {
      final lastRequestDate = DateTime.parse(lastRequestDateString);
      final monthsSinceLastRequest =
          DateTime.now().difference(lastRequestDate).inDays ~/ 30;
      if (monthsSinceLastRequest < ReviewConsts.monthsBetweenReviews) {
        return false;
      }
    }
    try {
      await _inAppReview.requestReview();
      await prefs.setString(
        ReviewConsts.lastReviewRequestDateKey,
        DateTime.now().toIso8601String(),
      );
      await prefs.setInt(ReviewConsts.levelEntriesCountKey, 0);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<int> getLevelEntriesCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(ReviewConsts.levelEntriesCountKey) ?? 0;
  }

  Future<DateTime?> getLastReviewRequestDate() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(ReviewConsts.lastReviewRequestDateKey);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  Future<void> resetCounter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(ReviewConsts.levelEntriesCountKey, 0);
  }
}
