import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_recipes/services/cubit/recipes_cubit/recipes_cubit.dart';
import 'package:meals_recipes/widgets/bookmark_button.dart';

class AllRecipes extends StatelessWidget {
  const AllRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Recipes'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<RecipesCubit, RecipesState>(
        builder: (context, state) {
          return ListView.builder(
            itemCount:
                BlocProvider.of<RecipesCubit>(
                  context,
                ).allRecipes.length, // Example item count
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  context.push(
                    '/recipeInfo',
                    extra:
                        BlocProvider.of<RecipesCubit>(
                          context,
                        ).allRecipes[index],
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(5),
                  child: ListBody(
                    children: [
                      Stack(
                        children: [
                          ListTile(
                            title: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                height: 170,
                                BlocProvider.of<RecipesCubit>(
                                  context,
                                ).allRecipes[index].imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 35,
                            child: BookmarkButton(
                              dataModel:
                                  BlocProvider.of<RecipesCubit>(
                                    context,
                                  ).allRecipes[index],
                            ),
                          ),
                        ],
                      ),
                      ListTile(
                        title: Text(
                          BlocProvider.of<RecipesCubit>(
                            context,
                          ).allRecipes[index].title,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
