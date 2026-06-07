import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:recipe_app/core/constants/app_assets.dart';
import 'package:recipe_app/core/di/injection_container.dart';
import 'package:recipe_app/features/recipes/domain/entities/recipe.dart';
import 'package:recipe_app/features/recipes/presentation/cubit/recipes_cubit.dart';
import 'package:recipe_app/features/recipes/presentation/cubit/recipes_state.dart';
import 'package:recipe_app/features/recipes/presentation/pages/recipe_details_page.dart';

import '../widgets/category_chips.dart';
import '../widgets/featured_recipe_card.dart';
import '../widgets/recipe_grid_card.dart';
import '../widgets/recipe_search_bar.dart';

// final mockFeatured = Recipe(
//   name: 'Spaghetti Carbonara',
//   image: '🍝',
//   prepTimeMinutes: 25,
//   difficulty: 'Easy',
// );

// final mockRecipes = [
//   Recipe(
//     name: 'Greek Salad',
//     image: '🥗',
//     prepTimeMinutes: 15,
//     difficulty: 'Easy',
//   ),
//   Recipe(
//     name: 'Ramen Bowl',
//     image: '🍜',
//     prepTimeMinutes: 45,
//     difficulty: 'Medium',
//   ),
//   Recipe(
//     name: 'Chicken Curry',
//     image: '🥘',
//     prepTimeMinutes: 40,
//     difficulty: 'Medium',
//   ),
//   Recipe(
//     name: 'Fluffy Pancakes',
//     image: '🥞',
//     prepTimeMinutes: 20,
//     difficulty: 'Easy',
//   ),
// ];

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RecipesCubit>()..loadRecipes(),
      child: const _RecipesView(),
    );
  }
}

class _RecipesView extends StatelessWidget {
  const _RecipesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<RecipesCubit, RecipesState>(
          builder: (context, state) {
            return switch (state) {
              RecipesInitial() || RecipesLoading() => Center(
                child: Lottie.asset(AppAssets.loadingAnimation),
              ),

              RecipesError() => Center(child: Text(state.message)),

              RecipesLoaded() => _RecipesContent(recipes: state.recipes),
            };
          },
        ),
      ),
    );
  }
}

class _RecipesContent extends StatelessWidget {
  final List<Recipe> recipes;

  const _RecipesContent({required this.recipes});

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) {
      return const Center(child: Text('No recipes found'));
    }

    final featuredRecipe = recipes.first;
    final popularRecipes = recipes.skip(1).toList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Recipes',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  'What are you cooking today?',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        const SliverToBoxAdapter(child: RecipeSearchBar()),

        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        const SliverToBoxAdapter(child: CategoryChips()),

        const SliverToBoxAdapter(child: SizedBox(height: 14)),

        SliverToBoxAdapter(
          child: FeaturedRecipeCard(
            recipe: featuredRecipe,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecipeDetailsPage(recipe: featuredRecipe),
                ),
              );
            },
          ),
        ),

        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
            child: Text(
              'Popular',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final recipe = popularRecipes[index];

              return RecipeGridCard(
                recipe: recipe,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailsPage(recipe: recipe),
                    ),
                  );
                },
                index: index,
              );
            }, childCount: popularRecipes.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}
