import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key,
      required this.onTogglefavorite,
      required this.availableMeals});
  final void Function(Meal meal) onTogglefavorite;
  final List<Meal> availableMeals;

  void _onSelectCategory(BuildContext context, Category category) {
    final filteredList = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      // Navigator.push(contex, route) alternate way of doing this
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
            title: category.title,
            meals: filteredList,
            onTogglefavorite: onTogglefavorite),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 3 / 2),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _onSelectCategory(context, category);
            },
          )
      ],
    );
  }
}