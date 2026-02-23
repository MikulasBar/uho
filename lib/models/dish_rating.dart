
import 'package:supabase_flutter/supabase_flutter.dart';

class DishRating {
  String userName;
  double overallRating;
  double tasteRating;
  double portionSizeRating;
  String description;

  int? userRatingCount;

  DishRating(
    this.userName,
    this.overallRating,
    this.tasteRating,
    this.portionSizeRating,
    this.description,
    { this.userRatingCount } 
  );

  factory DishRating.fromJson(Map<String, dynamic> json) {
    return DishRating(
      json['user_name'] as String,
      toDouble(json['overall_rating'])!,
      toDouble(json['taste_rating'])!,
      toDouble(json['portion_size_rating'])!,
      json['description'] as String,
      userRatingCount: toInt(json['user_rating_count']),
    );
  }
}