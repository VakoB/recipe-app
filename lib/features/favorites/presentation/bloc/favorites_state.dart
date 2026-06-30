import 'package:flutter/foundation.dart';
import '../../domain/entities/favorite_recipe.dart';

@immutable
sealed class FavoritesState {
  const FavoritesState();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteRecipe> favorites;
  const FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);
}
