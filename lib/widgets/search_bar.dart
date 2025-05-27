import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/models/translatable_text.dart';
import 'package:meals_recipes/services/cubit/language/language_cubit.dart';
import 'package:meals_recipes/services/cubit/search_cubit/search_cubit.dart';
import 'package:meals_recipes/services/models/recipes_model.dart';
import 'package:meals_recipes/services/recipes_services.dart';

class SearchBarWidget extends StatelessWidget {
  SearchBarWidget({super.key});
  final TextEditingController textcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchSuccess) {}
      },
      builder: (context, state) {
        final languageCubit = context.read<LanguageCubit>();
        return Column(
          children: [
            TextFormField(
              controller: textcontroller,
              // focusNode: FocusNode(),
              // autofocus: false,
              onTap: () {
                BlocProvider.of<SearchCubit>(context).steadySearchResults();
              },
              onChanged: (value) async {
                BlocProvider.of<SearchCubit>(
                  context,
                ).searchRecipes(search: value);
                if (value.isEmpty) {
                  BlocProvider.of<SearchCubit>(context).clearSearchResults();
                  FocusManager.instance.primaryFocus?.unfocus();
                  textcontroller.clear();
                  return;
                }

                if (BlocProvider.of<LanguageCubit>(context).isArabic) {
                  // Translate search text if in Arabic
                  final searchTerm = await languageCubit.translateForSearch(
                    value,
                  );
                  // Search with translated term
                  BlocProvider.of<SearchCubit>(
                    context,
                  ).searchRecipes(search: searchTerm);
                }
              },
              // design of the text field
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: greyColor),
                hintText:
                    languageCubit.isArabic ? "ابحث عن وصفات" : "Search recipes",
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontVariations: [FontVariation('wght', 400)],
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: greyColor, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: darkmainColor, width: 2),
                ),
              ),
            ),
            if (state is SearchSuccess &&
                BlocProvider.of<SearchCubit>(context).searchResults.isNotEmpty)
              Container(
                height: 200, // Adjust height as needed
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount:
                      BlocProvider.of<SearchCubit>(
                        context,
                      ).searchResults.length,
                  itemBuilder: (context, index) {
                    return BlocProvider.of<SearchCubit>(
                          context,
                        ).searchResults.isEmpty
                        ? SizedBox()
                        : ListTile(
                          onTap: () {
                            RecipesModel recipedate = RecipesModel(
                              id: 0,
                              title: '',
                              imageUrl: '',
                              description: '',
                              cookingTime: "0",
                              readyInMinutes: "0",
                              ingredients: [],
                              steps: [],
                              servings: 0,
                              diets: [],
                              dishType: [],
                              equipment: [],
                              favorite: false,
                              healthy: false,
                            );
                            RecipesServices()
                                .fetchRecipeById(
                                  id:
                                      BlocProvider.of<SearchCubit>(
                                        context,
                                      ).searchResults[index]["id"],
                                )
                                .then((value) {
                                  recipedate = value;
                                  context.push(
                                    "/recipeInfo",
                                    extra: recipedate,
                                  );
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  textcontroller.clear();
                                  BlocProvider.of<SearchCubit>(
                                    context,
                                  ).clearSearchResults();
                                });
                          },
                          leading: Image.network(
                            BlocProvider.of<SearchCubit>(
                              context,
                            ).searchResults[index]['image'],
                            width: 50,
                            height: 50,
                          ),
                          title: TranslatableText(
                            BlocProvider.of<SearchCubit>(
                              context,
                            ).searchResults[index]['title'],
                          ),
                        );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
