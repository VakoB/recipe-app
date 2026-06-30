import '../../domain/entities/recipe.dart';
import '../../domain/repositories/recipe_repository.dart';
import '../datasources/recipe_remote_datasource.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  const RecipeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Recipe>> getRecipes() async {
    return remoteDataSource.getRecipes();
  }
}