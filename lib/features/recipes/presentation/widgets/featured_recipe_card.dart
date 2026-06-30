import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/features/favorites/domain/entities/favorite_recipe.dart';
import 'package:recipe_app/features/favorites/presentation/bloc/favorites_cubit.dart';
import 'package:recipe_app/features/favorites/presentation/bloc/favorites_state.dart';
import '../../domain/entities/recipe.dart';

class FeaturedRecipeCard extends StatefulWidget {
  final Recipe recipe;
  final VoidCallback onTap;

  const FeaturedRecipeCard({
    super.key,
    required this.recipe,
    required this.onTap,
  });

  @override
  State<FeaturedRecipeCard> createState() => _FeaturedRecipeCardState();
}

class _FeaturedRecipeCardState extends State<FeaturedRecipeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool _started = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.recipe.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) {
                          if (frame != null && !_started) {
                            _started = true;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (mounted) _controller.forward();
                            });
                          }
                          return child;
                        },
                  ),
                ),

                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          '⭐ Featured',
                          style: TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.recipe.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.recipe.prepTimeMinutes + widget.recipe.cookTimeMinutes} min · ${widget.recipe.difficulty}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: 6,
                  right: 6,
                  child: BlocBuilder<FavoritesCubit, FavoritesState>(
                    builder: (context, state) {
                      final isFavorite =
                          state is FavoritesLoaded &&
                          state.favorites.any(
                            (f) => f.recipeId == widget.recipe.id,
                          );

                      return GestureDetector(
                        onTap: () {
                          context.read<FavoritesCubit>().toggleFavorite(
                            FavoriteRecipe(
                              recipeId: widget.recipe.id,
                              name: widget.recipe.name,
                              image: widget.recipe.image,
                              prepTimeMinutes: widget.recipe.prepTimeMinutes,
                              cookTimeMinutes: widget.recipe.cookTimeMinutes,
                              difficulty: widget.recipe.difficulty,
                              addedAt: DateTime.now(),
                              rating: widget.recipe.rating,
                              ingredients: widget.recipe.ingredients,
                              instructions: widget.recipe.instructions,
                            ),
                          );
                        },
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 14,
                            color: const Color(0xFFD4537E),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
