import 'package:go_router/go_router.dart';
import 'package:meals_recipes/screens/all_recipes.dart';
import 'package:meals_recipes/screens/bookmark_page.dart';
import 'package:meals_recipes/screens/home_page.dart';
import 'package:meals_recipes/screens/recipe_information.dart';
import 'package:meals_recipes/screens/welcome_page.dart';
import 'package:meals_recipes/services/models/recipes_model.dart';

final GoRouter routes = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'welcome page',
      builder: (context, state) => const WelcomePage(),
    ),
    GoRoute(
      path: '/home',
      name: 'home page',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/recipeInfo',
      builder: (context, state) {
        // Extract the RecipesModel from the state extra
        final RecipesModel recipesModel = state.extra as RecipesModel;
        return RecipeInformation(recipesModel: recipesModel);
      },
    ),
    GoRoute(
      path: '/allRecipes',
      builder: (context, state) {
        // Extract the RecipesModel from the state extra
        return AllRecipes();
      },
    ),
    GoRoute(
      path: '/bookmark',
      builder: (context, state) {
        // Extract the RecipesModel from the state extra
        return BookmarkPage();
      },
    ),
  ],
);
