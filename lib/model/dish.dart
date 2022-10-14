class Dish {
  final String id;
  final String imageUrl;
  final String dishName;
  final double dishPrice;

  Dish(
      {required this.id,
      required this.imageUrl,
      required this.dishName,
      required this.dishPrice});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'dishName': dishName,
      'dishPrice': dishPrice.toString()
    };
  }

  factory Dish.fromMap(Map map) {
    return Dish(
      id: map['id'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      dishName: map['dishName'] ?? '',
      dishPrice: double.parse(map['dishPrice'] ?? '0.0'),
    );
  }
}
