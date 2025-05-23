import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_recipes/services/cubit/bookmark_cubit/bookmark_cubit.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('saved recipes'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<BookmarkCubit, BookmarkState>(
        builder: (context, state) {
          return BlocProvider.of<BookmarkCubit>(context).savedRecipes.isEmpty
              ? const Center(
                child: Text(
                  'No saved recipes',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              )
              : ListView.builder(
                itemCount:
                    BlocProvider.of<BookmarkCubit>(
                      context,
                    ).savedRecipes.length, // Example item count
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.push(
                        '/recipeInfo',
                        extra:
                            BlocProvider.of<BookmarkCubit>(
                              context,
                            ).savedRecipes[index],
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.all(5),
                      child: ListBody(
                        children: [
                          ListTile(
                            title: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                BlocProvider.of<BookmarkCubit>(
                                  context,
                                ).savedRecipes[index].imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              BlocProvider.of<BookmarkCubit>(
                                context,
                              ).savedRecipes[index].title,
                              style: const TextStyle(
                                fontSize: 20,
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
