import 'package:flutter/foundation.dart';
import '../../domain/entities/recipe.dart';

@immutable
sealed class RecipesState {
  const RecipesState();
}

class RecipesInitial extends RecipesState {
  const RecipesInitial();
}

class RecipesLoading extends RecipesState {
  const RecipesLoading();
}

class RecipesLoaded extends RecipesState {
  final List<Recipe> recipes;
  const RecipesLoaded(this.recipes);
}

class RecipesError extends RecipesState {
  final String message;
  const RecipesError(this.message);
}