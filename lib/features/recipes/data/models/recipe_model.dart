import '../../domain/entities/recipe.dart';

class RecipeModel extends Recipe {
  const RecipeModel({
    required super.id,
    required super.name,
    required super.image,
    required super.prepTimeMinutes,
    required super.cookTimeMinutes,
    required super.difficulty,
    required super.rating,
    required super.ingredients,
    required super.instructions,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      prepTimeMinutes: json['prepTimeMinutes'] as int,
      cookTimeMinutes: json['cookTimeMinutes'] as int,
      difficulty: json['difficulty'] as String,
      rating: (json['rating'] as num).toDouble(),
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
    );
  }
}
