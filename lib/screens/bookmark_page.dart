import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_recipes/models/translatable_text.dart';
import 'package:meals_recipes/services/cubit/bookmark_cubit/bookmark_cubit.dart';
import 'package:meals_recipes/widgets/bookmark_button.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TranslatableText('saved recipes'),
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
                child: TranslatableText(
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
                          Stack(
                            children: [
                              ListTile(
                                title: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: handelImageError(
                                    image:
                                        BlocProvider.of<BookmarkCubit>(
                                          context,
                                        ).savedRecipes[index].imageUrl,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                right: 35,
                                child: BookmarkButton(
                                  dataModel:
                                      BlocProvider.of<BookmarkCubit>(
                                        context,
                                      ).savedRecipes[index],
                                ),
                              ),
                            ],
                          ),
                          ListTile(
                            title: TranslatableText(
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

Image handelImageError({required String image}) {
  return Image.network(
    image,
    height: 170,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[300],
        ),
        child: Image.asset(
          'assets/images/no_Internet.jpeg', // Your local fallback image
          height: 170,
          fit: BoxFit.cover,
        ),
      );
    },
    loadingBuilder: (context, child, loadingProgress) {
      if (loadingProgress == null) return child;
      return Container(
        height: 170,
        child: Center(
          child: CircularProgressIndicator(
            value:
                loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
          ),
        ),
      );
    },
  );
}
