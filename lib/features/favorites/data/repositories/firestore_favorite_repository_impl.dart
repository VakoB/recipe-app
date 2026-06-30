import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/favorite_recipe.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../models/favorite_recipe_model.dart';

class FirestoreFavoriteRepositoryImpl implements FavoriteRepository {
  final FirebaseFirestore _firestore;

  const FirestoreFavoriteRepositoryImpl(this._firestore);

  CollectionReference<Map<String, dynamic>> _favoritesRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('favorites');
  }

  @override
  Stream<List<FavoriteRecipe>> watchFavorites(String uid) {
    return _favoritesRef(uid)
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FavoriteRecipeModel.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<bool> isFavorite(String uid, int recipeId) async {
    final doc = await _favoritesRef(uid).doc(recipeId.toString()).get();
    return doc.exists;
  }

  @override
  Future<void> addFavorite(String uid, FavoriteRecipe recipe) async {
    final model = FavoriteRecipeModel(
      recipeId: recipe.recipeId,
      name: recipe.name,
      image: recipe.image,
      prepTimeMinutes: recipe.prepTimeMinutes,
      cookTimeMinutes: recipe.cookTimeMinutes,
      difficulty: recipe.difficulty,
      addedAt: recipe.addedAt,
      rating: recipe.rating,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
    );
    await _favoritesRef(
      uid,
    ).doc(recipe.recipeId.toString()).set(model.toJson());
  }

  @override
  Future<void> removeFavorite(String uid, int recipeId) async {
    await _favoritesRef(uid).doc(recipeId.toString()).delete();
  }
}
