import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uho/models/dish.dart';
import 'package:uho/models/dish_global_rating.dart';

class DbClient {
  static Future<List<DishGlobalRating>> fetchGlobalRatings({int limit = 10}) async {
    try {
      final result = await Supabase.instance.client.from("dish")
        .select("*, rating:dish_global_rating(*)")
        .limit(limit);

      final ratings = result.map((json) {
        final dish = Dish.fromJson(json);
        return DishGlobalRating.fromJson(dish, json['rating'] as Map<String, dynamic>);
      }).toList();

      return ratings;
    } catch (e) {
      print("Error fetching global ratings: $e");
      return [];
    }
  }
}
