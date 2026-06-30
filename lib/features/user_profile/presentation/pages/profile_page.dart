import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/recipes/presentation/pages/recipe_details_page.dart';

import '../../../../core/di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_cubit.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../favorites/domain/entities/favorite_recipe.dart';
import '../../../favorites/presentation/bloc/favorites_cubit.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../../favorites/presentation/widgets/favorite_recipe_card.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../widgets/profile_header.dart';
import '../widgets/logout_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      return const Scaffold(body: Center(child: Text('Not logged in')));
    }
    final uid = authState.user.uid;

    return BlocProvider<FavoritesCubit>(
      create: (_) => sl<FavoritesCubit>(param1: uid),
      child: _ProfileView(uid: uid),
    );
  }
}

class _ProfileView extends StatelessWidget {
  final String uid;
  const _ProfileView({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<UserProfile?>(
          future: sl<UserProfileRepository>().getProfile(uid),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final profile = snapshot.data!;

            return BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                final favorites = state is FavoritesLoaded
                    ? state.favorites
                    : <FavoriteRecipe>[];

                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ProfileHeader(
                          profile: profile,
                          favoritesCount: favorites.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 20)),
                    SliverToBoxAdapter(
                      child: LogoutButton(
                        onPressed: () => context.read<AuthCubit>().logout(),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 10),
                        child: Text(
                          'Your favorites',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    if (state is FavoritesLoading)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                      )
                    else if (favorites.isEmpty)
                      const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(
                            child: Text(
                              'No favorites yet. tap the heart on any recipe to save it here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: Builder(
                          builder: (context) {
                            final screenWidth = MediaQuery.of(
                              context,
                            ).size.width;
                            final crossAxisCount = screenWidth < 600
                                ? 2
                                : screenWidth < 900
                                ? 3
                                : 4;

                            return SliverGrid(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final favorite = favorites[index];
                                return FavoriteRecipeCard(
                                  favorite: favorite,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RecipeDetailsPage(
                                          recipe: favorite.toRecipe(),
                                        ),
                                      ),
                                    );
                                  },
                                  onUnfavorite: () => context
                                      .read<FavoritesCubit>()
                                      .toggleFavorite(favorite),
                                );
                              }, childCount: favorites.length),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 0.85,
                                  ),
                            );
                          },
                        ),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
