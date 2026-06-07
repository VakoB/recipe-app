import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/recipes/data/datasources/recipe_remote_datasource.dart';
import '../../features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../features/recipes/domain/repositories/recipe_repository.dart';
import '../../features/recipes/domain/usecases/get_recipes.dart';
import '../../features/recipes/presentation/cubit/recipes_cubit.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {

  sl.registerLazySingleton<Dio>(() => DioClient.create());

  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(sl()),
  );
 
  sl.registerLazySingleton(() => GetRecipes(sl()));

  sl.registerFactory(() => RecipesCubit(sl()));
}