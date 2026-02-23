import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uho/models/dish.dart';
import 'package:uho/models/dish_global_rating.dart';
import 'package:uho/models/dish_rating.dart';

class DbClient {
  static Future<List<(Dish, DishGlobalRating)>> fetchGlobalRatings({
    int limit = 10,
  }) async {
    try {
      final result = await Supabase.instance.client
          .from("dish")
          .select("*, rating:dish_global_rating(*)")
          .limit(limit);

      final ratings = result.map((json) {
        final dish = Dish.fromJson(json);
        final rating = DishGlobalRating.fromJson(
          json['rating'] as Map<String, dynamic>,
        );
        return (dish, rating);
      }).toList();

      return ratings;
    } catch (e) {
      print("Error fetching global ratings: $e");
      return [];
    }
  }

  static Future<List<DishRating>> fetchDishRatings(String dishId) async {
    try {
      // Select ratings for this dish, joined with profiles to get username
      final result = await Supabase.instance.client
          .from('dish_rating')
          .select("""
            *,
            user:profiles(username, ratings_count)
          """)
          .eq('dish_id', dishId);

      final ratings = (result as List).map((json) {
        final rating = DishRating.fromJson({
          'user_name': json['user']?['username'] ?? 'Unknown',
          'user_rating_count': json['user']?['ratings_count'],
          'overall_rating': json['overall_rating'],
          'taste_rating': json['taste_rating'],
          'portion_size_rating': json['portion_size_rating'],
          'description': json['description'] ?? '',
        });
        return rating;
      }).toList();

      return ratings;
    } catch (e) {
      print("Error fetching dish ratings: $e");
      return [];
    }
  }

  static Future<void> insertDishRating({
    required String dishId,
    required double overallRating,
    required double tasteRating,
    required double portionSizeRating,
    required String description,
  }) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      await Supabase.instance.client.from('dish_rating').insert({
        'dish_id': dishId,
        'user_id': user.id,
        'overall_rating': overallRating,
        'taste_rating': tasteRating,
        'portion_size_rating': portionSizeRating,
        'description': description,
        // 'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print("Error inserting dish rating: $e");
      rethrow;
    }
  }
}
