

class Dish {
  String id;
  String name;

  Dish(this.id, this.name);

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      json['id'] as String,
      json['name'] as String,
    );
  }
}