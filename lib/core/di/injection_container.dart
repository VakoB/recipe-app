import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_app/features/auth/data/repositories/firebase_auth_repository_impl.dart';
import 'package:recipe_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:recipe_app/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:recipe_app/features/favorites/data/repositories/firestore_favorite_repository_impl.dart';
import 'package:recipe_app/features/favorites/domain/repositories/favorite_repository.dart';
import 'package:recipe_app/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:recipe_app/features/user_profile/data/repositories/firestore_user_profile_repository_impl.dart';
import 'package:recipe_app/features/user_profile/domain/repositories/user_profile_repository.dart';

import '../../features/recipes/data/datasources/recipe_remote_datasource.dart';
import '../../features/recipes/data/repositories/recipe_repository_impl.dart';
import '../../features/recipes/domain/repositories/recipe_repository.dart';
import '../../features/recipes/domain/usecases/get_recipes.dart';
import '../../features/recipes/presentation/cubit/recipes_cubit.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  sl.registerLazySingleton<Dio>(() => DioClient.create());

  // user profile
  sl.registerLazySingleton<UserProfileRepository>(
    () => FirestoreUserProfileRepositoryImpl(sl()),
  );

  // auth feature
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => AuthCubit(sl(), sl()));

  //favourites
  sl.registerLazySingleton<FavoriteRepository>(
    () => FirestoreFavoriteRepositoryImpl(sl()),
  );
  sl.registerFactoryParam<FavoritesCubit, String, void>(
    (uid, _) => FavoritesCubit(sl(), uid),
  );

  //recipes
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<RecipeRepository>(() => RecipeRepositoryImpl(sl()));

  sl.registerLazySingleton(() => GetRecipes(sl()));

  sl.registerFactory(() => RecipesCubit(sl()));
}
