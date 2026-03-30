import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uho/models/dish.dart';
import 'package:uho/models/dish_global_rating.dart';
import 'package:uho/models/dish_rating.dart';
import 'package:uho/models/group.dart';
import 'package:uho/models/profile.dart';

class DbClient {
  static Future<List<(Dish, DishGlobalRating)>> fetchGlobalRatings({
    int limit = 10,
  }) async {
    try {
      final result = await Supabase.instance.client
          .from("dishes")
          .select("*, rating:dish_global_ratings(*)")
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

  static Future<List<DishRating>> fetchDishRatings({
    String? dishId,
    String? groupId,
  }) async {
    try {
      final selectWithGroup = """
        *,
        user:profiles(username, ratings_count),
        relation:dish_rating_group_relations!inner(group_id)
      """;
      final selectBasic = """
        *,
        user:profiles(username, ratings_count)
      """;

      var query = Supabase.instance.client
          .from('dish_ratings')
          .select(groupId != null ? selectWithGroup : selectBasic);

      if (dishId != null) {
        query = query.eq('dish_id', dishId);
      }

      if (groupId != null) {
        query = query.eq('relation.group_id', groupId);
      }

      final result = await query;

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

      await Supabase.instance.client.from('dish_ratings').insert({
        'dish_id': dishId,
        'user_id': user.id,
        'overall_rating': overallRating,
        'taste_rating': tasteRating,
        'portion_size_rating': portionSizeRating,
        'description': description,
      });
    } catch (e) {
      print("Error inserting dish rating: $e");
      rethrow;
    }
  }

  static Future<List<Group>> fetchGroups() async {
    try {
      final result = await Supabase.instance.client
          .from('groups')
          .select('id, name, member_count, dish_ratings_count, owner_id');

      final groups = (result as List).map((json) {
        return Group.fromJson(json);
      }).toList();

      return groups;
    } catch (e) {
      print("Error fetching groups: $e");
      return [];
    }
  }

  static Future<List<Profile>> fetchUsers() async {
    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      var query = Supabase.instance.client
          .from('profiles')
          .select('user_id, username, ratings_count, description');

      if (currentUser != null) {
        query = query.neq('user_id', currentUser.id);
      }

      final result = await query;

      final users = (result as List).map((json) {
        return Profile.fromJson(json);
      }).toList();

      return users;
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  static Future<List<Profile>> fetchGroupMembers(
    String groupId, {
    List<String> includeUserIds = const [],
  }) async {
    try {
      final memberships = await Supabase.instance.client
          .from('group_memberships')
          .select('member_id')
          .eq('group_id', groupId);

      final memberIds = (memberships as List)
          .map((json) => json['member_id'] as String)
          .toSet()
          .toList();

      memberIds.addAll(includeUserIds.where((id) => id.isNotEmpty));

      if (memberIds.isEmpty) {
        return [];
      }

      final result = await Supabase.instance.client
          .from('profiles')
          .select('user_id, username, ratings_count, description')
          .inFilter('user_id', memberIds);

      final users = (result as List).map((json) {
        return Profile.fromJson(json);
      }).toList()
        ..sort((a, b) => a.username.compareTo(b.username));

      return users;
    } catch (e) {
      print("Error fetching group members: $e");
      return [];
    }
  }

  static Future<void> createGroup({
    required String name,
    List<String> userIds = const [],
  }) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final groupResponse = await Supabase.instance.client
          .from('groups')
          .insert({
        'name': name,
        'owner_id': user.id,
      }).select();

      if (groupResponse.isEmpty) {
        throw Exception("Failed to create group");
      }

      final groupId = groupResponse[0]['id'] as String;
      final selectedUserIds = userIds.where((id) => id != user.id).toSet().toList();

      // Insert group memberships for all selected user IDs
      if (selectedUserIds.isNotEmpty) {
        final memberships = selectedUserIds.map((userId) {
          return {
            'group_id': groupId,
            'member_id': userId,
          };
        }).toList();

        try {
          await Supabase.instance.client
              .from('group_memberships')
              .insert(memberships);
        } catch (e) {
          // Compensating rollback if memberships insert fails after group creation.
          try {
            await Supabase.instance.client
                .from('groups')
                .delete()
                .eq('id', groupId);
          } catch (rollbackError) {
            print("Error rolling back group creation: $rollbackError");
          }
          rethrow;
        }
      }
    } catch (e) {
      print("Error creating group: $e");
      rethrow;
    }
  }

  static Future<void> addUserToGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await Supabase.instance.client.from('group_memberships').insert({
        'group_id': groupId,
        'member_id': userId,
      });
    } catch (e) {
      print("Error adding user to group: $e");
      rethrow;
    }
  }

  static Future<void> removeUserFromGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await Supabase.instance.client
          .from('group_memberships')
          .delete()
          .eq('group_id', groupId)
          .eq('member_id', userId);
    } catch (e) {
      print("Error removing user from group: $e");
      rethrow;
    }
  }

  static Future<void> deleteGroup({
    required String groupId,
  }) async {
    try {
      await Supabase.instance.client
          .from('groups')
          .delete()
          .eq('id', groupId);
    } catch (e) {
      print("Error deleting group: $e");
      rethrow;
    }
  }

  static Future<void> leaveGroup({
    required String groupId,
    required String userId,
  }) async {
    try {
      await removeUserFromGroup(groupId: groupId, userId: userId);
    } catch (e) {
      print("Error leaving group: $e");
      rethrow;
    }
  }

  static Future<List<DishRating>> fetchGroupDishRatings(String groupId) async {
    return fetchDishRatings(groupId: groupId);
  }
}
