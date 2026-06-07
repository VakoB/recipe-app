import 'package:dio/dio.dart';
import '../models/recipe_model.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> getRecipes();
  Future<RecipeModel> getRecipeDetail(int id);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio dio;

  const RecipeRemoteDataSourceImpl(this.dio);

  @override
  Future<List<RecipeModel>> getRecipes() async {
    final response = await dio.get('/recipes');
    final data = response.data as Map<String, dynamic>;
    final recipes = data['recipes'] as List<dynamic>;

    return recipes
        .map((e) => RecipeModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<RecipeModel> getRecipeDetail(int id) async {
    final response = await dio.get('/recipes/$id');
    return RecipeModel.fromJson(response.data);
  }
}
