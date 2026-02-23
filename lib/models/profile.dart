

class Profile {
  final String user_id;
  final String username;
  final int ratingsCount;
  final String description;

  Profile({
    required this.user_id,
    required this.username,
    required this.ratingsCount,
    required this.description,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      user_id: json['user_id'] as String,
      username: json['username'] as String,
      ratingsCount: json['ratings_count'] as int,
      description: json['description'] as String,
    );
  }
}