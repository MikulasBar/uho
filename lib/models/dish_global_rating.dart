import 'package:supabase_flutter/supabase_flutter.dart';

class DishGlobalRating {
  double? overallRating;
  double? tasteRating;
  double? portionSizeRating;
  int ratingsCount;

  DishGlobalRating(
    this.overallRating,
    this.tasteRating,
    this.portionSizeRating,
    this.ratingsCount,
  );

  factory DishGlobalRating.fromJson(Map<String, dynamic> json) {
    return DishGlobalRating(
      toDouble(json['overall_rating']),
      toDouble(json['taste_rating']),
      toDouble(json['portion_size_rating']),
      toInt(json['ratings_count'])!,
    );
  }
}
