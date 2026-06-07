import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_recipes.dart';
import 'recipes_state.dart';

class RecipesCubit extends Cubit<RecipesState> {
  final GetRecipes _getRecipes;

  RecipesCubit(this._getRecipes) : super(const RecipesInitial());

  Future<void> loadRecipes() async {
    emit(const RecipesLoading());
    try {
      final recipes = await _getRecipes();
      emit(RecipesLoaded(recipes));
    } catch (e) {
      emit(RecipesError(e.toString()));
    }
  }
}