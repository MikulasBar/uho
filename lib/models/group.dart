

class Group {
    final String id;
    final String name;
    final int memberCount;
    final int dishRatingsCount;
    final String ownerId;

  Group({
    required this.id,
    required this.name,
    required this.memberCount,
    required this.dishRatingsCount,
    required this.ownerId,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as String,
      name: json['name'] as String,
      memberCount: json['member_count'] as int,
      dishRatingsCount: json['dish_ratings_count'] as int,
      ownerId: json['owner_id'] as String,
    );
  }
}