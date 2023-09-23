import 'package:flutter/material.dart';

import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/main_drawer.dart';

const kInitalFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegan: false,
  Filter.vegeterian: false
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectPageIndex = 0;
  final List<Meal> _favoriteMeal = [];
  Map<Filter, bool> _selectFilters = kInitalFilters;

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeal.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeal.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite.');
    } else {
      setState(() {
        _favoriteMeal.add(meal);
      });
      _showInfoMessage('Marked as a favorite.');
    }
  }

  void _selectPage(index) {
    setState(() {
      _selectPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersSceen(currentFilters: _selectFilters),
        ),
      );
      setState(() {
        _selectFilters = result ?? kInitalFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_selectFilters[Filter.vegeterian]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activeScreen = CategoriesScreen(
      onTogglefavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectPageIndex == 1) {
      activeScreen = MealsScreen(
        meals: _favoriteMeal,
        onTogglefavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(onSelectScreen: _setScreen),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites')
        ],
      ),
    );
  }
}
