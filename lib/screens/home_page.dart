import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/extention/extentions.dart';
import 'package:meals_recipes/services/cubit/recipes_cubit.dart';
import 'package:meals_recipes/widgets/category_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RecipesCubit, RecipesState>(
      listener: (context, state) {
        if (state is RecipesSuccess) {
          print("==========> $state <============");
          BlocProvider.of<RecipesCubit>(context).getCategoryRecipes();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Find best recipes\nfor cooking",
                    style: TextStyle(
                      fontSize: 24,
                      fontVariations: [FontVariation('wght', 700)],
                    ),
                  ),
                  const SizedBox(height: 25),
                  SearchWidget(),
                  categoryHeader(
                    title: "trending now ",
                    isIcon: true,
                    isSeeAll: true,
                  ),
                  // the horizontal list view of recipes
                  state is RecipesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.305,
                        child: BlocBuilder<RecipesCubit, RecipesState>(
                          builder: (context, state) {
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 17),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap:
                                            () => context.push(
                                              "/recipeInfo",
                                              // pass the recipe model to the next screen using extra
                                              extra:
                                                  BlocProvider.of<RecipesCubit>(
                                                    context,
                                                  ).allRecipes[index],
                                            ),
                                        child: Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
                                              .7,
                                          height:
                                              MediaQuery.sizeOf(
                                                context,
                                              ).height *
                                              .26,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                BlocProvider.of<RecipesCubit>(
                                                  context,
                                                ).allRecipes[index].imageUrl,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                            color: mainColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                            .5,
                                        child: Text(
                                          BlocProvider.of<RecipesCubit>(context)
                                              .allRecipes[index]
                                              .title
                                              .capitalizeByWord(),
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontVariations: [
                                              FontVariation('wght', 600),
                                            ],
                                          ),
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                  categoryHeader(title: "popular category"),

                  // the horizontal list view of categories
                  state is RecipesLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Categories(),
                  SizedBox(height: 20),

                  // the  list view of recipes
                  // RecipeAvatar(),
                  categoryHeader(title: "recent recipe", isSeeAll: true),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class RecipeAvatar extends StatelessWidget {
  const RecipeAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        return SizedBox(
          height: width * .855,
          child: ListView.builder(
            // shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 20),

                child: SizedBox(
                  width: width * .56,

                  child: Stack(
                    // clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        top: width * .23,

                        child: Container(
                          width: width * .56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),

                            color: lightgreyColor,
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: width * .23),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                child: Text(
                                  BlocProvider.of<RecipesCubit>(
                                    context,
                                  ).allRecipes[index].title.capitalizeByWord(),
                                  // "first recipe name sad"
                                  //     .capitalizeByWord(),
                                  textAlign: TextAlign.center,

                                  style: TextStyle(
                                    fontSize: 19,
                                    fontVariations: [
                                      FontVariation('wght', 700),
                                    ],
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  18,
                                  0,
                                  18,
                                  15,
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Time",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: greyColor,
                                            fontVariations: [
                                              FontVariation('wght', 600),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          "${BlocProvider.of<RecipesCubit>(context).allRecipes[index].readyInMinutes} Min",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontVariations: [
                                              FontVariation('wght', 650),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        Icons.bookmark_border_rounded,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // the circle avatar
                      Positioned(
                        top: 0,
                        left: width * .055,

                        child: Container(
                          width: width * .45,
                          height: width * .45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                BlocProvider.of<RecipesCubit>(
                                  context,
                                ).allRecipes[index].imageUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.055,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: BlocProvider.of<RecipesCubit>(context).categories.length,

        itemBuilder: (context, index) {
          return Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: mainColor,
              ),
              child: Text(
                BlocProvider.of<RecipesCubit>(
                  context,
                ).categories[index].capitalizeByWord(),
                style: TextStyle(
                  fontSize: 16,
                  fontVariations: [FontVariation('wght', 700)],
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search, color: greyColor),
        hintText: "Search recipes",
        hintStyle: TextStyle(
          fontSize: 16,
          fontVariations: [FontVariation('wght', 400)],
          color: Colors.grey,
        ),
        // filled: true,
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
    );
  }
}
