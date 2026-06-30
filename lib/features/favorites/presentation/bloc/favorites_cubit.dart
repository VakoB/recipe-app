import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/favorite_recipe.dart';
import '../../domain/repositories/favorite_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoriteRepository _repository;
  final String uid;
  StreamSubscription? _subscription;

  FavoritesCubit(this._repository, this.uid) : super(const FavoritesLoading()) {
    _subscription = _repository
        .watchFavorites(uid)
        .listen(
          (favorites) => emit(FavoritesLoaded(favorites)),
          onError: (e) => emit(FavoritesError(e.toString())),
        );
  }

  Future<void> toggleFavorite(FavoriteRecipe recipe) async {
    final isFav = await _repository.isFavorite(uid, recipe.recipeId);
    if (isFav) {
      await _repository.removeFavorite(uid, recipe.recipeId);
    } else {
      await _repository.addFavorite(uid, recipe);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
