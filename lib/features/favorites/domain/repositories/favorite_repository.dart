import '../entities/favorite_recipe.dart';

abstract class FavoriteRepository {
  Stream<List<FavoriteRecipe>> watchFavorites(String uid);
  Future<bool> isFavorite(String uid, int recipeId);
  Future<void> addFavorite(String uid, FavoriteRecipe recipe);
  Future<void> removeFavorite(String uid, int recipeId);
}