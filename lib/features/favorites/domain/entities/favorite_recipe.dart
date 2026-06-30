import 'package:recipe_app/features/recipes/domain/entities/recipe.dart';

class FavoriteRecipe {
  final int recipeId;
  final String name;
  final String image;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final String difficulty;
  final double rating;
  final List<String> ingredients;
  final List<String> instructions;
  final DateTime addedAt;

  const FavoriteRecipe({
    required this.recipeId,
    required this.name,
    required this.image,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.rating,
    required this.ingredients,
    required this.instructions,
    required this.addedAt,
  });


  Recipe toRecipe() {
    return Recipe(
      id: recipeId,
      name: name,
      image: image,
      prepTimeMinutes: prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes,
      difficulty: difficulty,
      rating: rating,
      ingredients: ingredients,
      instructions: instructions,
    );
  }
}
