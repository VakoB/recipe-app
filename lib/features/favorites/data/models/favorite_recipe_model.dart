import '../../domain/entities/favorite_recipe.dart';

class FavoriteRecipeModel extends FavoriteRecipe {
  const FavoriteRecipeModel({
    required super.recipeId,
    required super.name,
    required super.image,
    required super.prepTimeMinutes,
    required super.cookTimeMinutes,
    required super.difficulty,
    required super.rating,
    required super.ingredients,
    required super.instructions,
    required super.addedAt,
  });

  factory FavoriteRecipeModel.fromJson(Map<String, dynamic> json) {
    return FavoriteRecipeModel(
      recipeId: json['recipeId'] as int,
      name: json['name'] as String,
      image: json['image'] as String,
      prepTimeMinutes: json['prepTimeMinutes'] as int,
      cookTimeMinutes: json['cookTimeMinutes'] as int,
      difficulty: json['difficulty'] as String,
      rating: (json['rating'] as num).toDouble(),
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      addedAt: DateTime.parse(json['addedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'name': name,
      'image': image,
      'prepTimeMinutes': prepTimeMinutes,
      'cookTimeMinutes': cookTimeMinutes,
      'difficulty': difficulty,
      'rating': rating,
      'ingredients': ingredients,
      'instructions': instructions,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}
