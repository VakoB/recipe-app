import 'package:flutter/material.dart';
import 'package:recipe_app/features/recipes/domain/entities/recipe.dart';
import 'package:recipe_app/features/recipes/presentation/widgets/recipe_stat_tile.dart';

class RecipeDetailsPage extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailsPage({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final totalTime =
        recipe.prepTimeMinutes;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                recipe.image,
                fit: BoxFit.cover,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    recipe.difficulty,
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: RecipeStatTile(
                          icon: Icons.schedule,
                          label: '$totalTime min',
                        ),
                      ),
                      Expanded(
                        child: RecipeStatTile(
                          icon: Icons.star,
                          label:
                              recipe.rating.toString(),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  IngredientsSection(
                    ingredients:
                        recipe.ingredients,
                  ),

                  const SizedBox(height: 24),

                  InstructionsSection(
                    instructions:
                        recipe.instructions,
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class IngredientsSection extends StatelessWidget {
  final List<String> ingredients;

  const IngredientsSection({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...ingredients.map(
          (item) => Padding(
            padding:
                const EdgeInsets.only(bottom: 8),
            child: Text('• $item'),
          ),
        ),
      ],
    );
  }
}

class InstructionsSection extends StatelessWidget {
  final List<String> instructions;

  const InstructionsSection({
    super.key,
    required this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Instructions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...instructions.asMap().entries.map(
          (entry) {
            return Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 12,
              ),
              child: Text(
                '${entry.key + 1}. ${entry.value}',
              ),
            );
          },
        ),
      ],
    );
  }
}