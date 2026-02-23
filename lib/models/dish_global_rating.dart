import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uho/models/dish.dart';

class DishGlobalRating {
  Dish dish;
  double? overallRating;
  double? tasteRating;
  double? portionSizeRating;
  int ratingsCount;

  DishGlobalRating(
    this.dish,
    this.overallRating,
    this.tasteRating,
    this.portionSizeRating,
    this.ratingsCount,
  );

  factory DishGlobalRating.fromJson(Dish dish, Map<String, dynamic> json) {
    return DishGlobalRating(
      dish,
      toDouble(json['overall_rating']),
      toDouble(json['taste_rating']),
      toDouble(json['portion_size_rating']),
      toInt(json['ratings_count'])!,
    );
  }
}
