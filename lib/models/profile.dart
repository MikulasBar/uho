

class Profile {
  final String id;
  final String username;
  final int ratingsCount;
  final String description;

  Profile({
    required this.id,
    required this.username,
    required this.ratingsCount,
    required this.description,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      username: json['username'] as String,
      ratingsCount: json['ratings_count'] as int,
      description: json['description'] as String,
    );
  }
}