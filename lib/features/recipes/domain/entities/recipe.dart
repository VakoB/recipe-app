class Recipe {
  final int id;
  final String name;
  final String image;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final String difficulty; 
  final double rating;
  final List<String> ingredients;
  final List<String> instructions;

  const Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.difficulty,
    required this.rating,
    required this.ingredients,
    required this.instructions,
  });
}