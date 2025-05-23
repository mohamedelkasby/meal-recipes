import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/services/cubit/bookmark_cubit/bookmark_cubit.dart';
import 'package:meals_recipes/services/models/recipes_model.dart';

class BookmarkButton extends StatelessWidget {
  const BookmarkButton({super.key, required this.dataModel});
  final RecipesModel dataModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookmarkCubit, BookmarkState>(
      builder: (context, state) {
        // Get the cubit instance
        final bookmarkCubit = context.read<BookmarkCubit>();

        // Check if this specific recipe is saved
        bool isCurrentRecipeSaved = bookmarkCubit.isRecipeSaved(dataModel);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon:
                isCurrentRecipeSaved
                    ? Icon(Icons.bookmark_added, size: 28, color: Colors.green)
                    : Icon(Icons.bookmark_add_outlined, size: 28),
            onPressed: () async {
              // Show loading indicator if needed
              await bookmarkCubit.toggleSave(dataModel: dataModel);

              // Optional: Show snackbar confirmation
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isCurrentRecipeSaved
                          ? 'Recipe removed from bookmarks'
                          : 'Recipe added to bookmarks',
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
