import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/extention/extentions.dart';
import 'package:meals_recipes/models/translatable_text.dart';
import 'package:meals_recipes/services/cubit/language/language_cubit.dart';
import 'package:meals_recipes/services/cubit/recipes_cubit/recipes_cubit.dart';
import 'package:meals_recipes/widgets/bookmark_button.dart';
import 'package:meals_recipes/widgets/language_button.dart';
import 'package:meals_recipes/widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          return Directionality(
            textDirection:
                context.read<LanguageCubit>().isArabic
                    ? TextDirection.rtl
                    : TextDirection.ltr,
            child: BlocConsumer<RecipesCubit, RecipesState>(
              listener: (context, state) {
                if (state is RecipesSuccess) {
                  BlocProvider.of<RecipesCubit>(context).getCategoryRecipes();
                }
              },
              builder: (context, state) {
                return Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 30, 8, 0),
                    child:
                        state is RecipesLoading
                            ? Center(child: CircularProgressIndicator())
                            : state is RecipesFauiler
                            ? Center(
                              child: TranslatableText(
                                state.errorMessage,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontVariations: [FontVariation('wght', 700)],
                                ),
                              ),
                            )
                            : SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      TranslatableText(
                                        "Find best recipes\nfor cooking",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontVariations: [
                                            FontVariation('wght', 700),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      LanguageToggleButton(),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  SearchBarWidget(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    child: TranslatableText(
                                      "Recipe of the day",
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontVariations: [
                                          FontVariation('wght', 700),
                                        ],
                                      ),
                                    ),
                                  ),
                                  state is RecipesLoading
                                      ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                            0.305,
                                        child: BlocBuilder<
                                          RecipesCubit,
                                          RecipesState
                                        >(
                                          builder: (context, state) {
                                            return GestureDetector(
                                              onTap:
                                                  () => context.push(
                                                    "/recipeInfo",
                                                    // pass the recipe model to the next screen using extra
                                                    extra:
                                                        BlocProvider.of<
                                                          RecipesCubit
                                                        >(
                                                          context,
                                                        ).randomRecipes[0],
                                                  ),
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height:
                                                        MediaQuery.sizeOf(
                                                          context,
                                                        ).height *
                                                        0.305,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          BlocProvider.of<
                                                                RecipesCubit
                                                              >(context)
                                                              .randomRecipes[0]
                                                              .imageUrl,
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top:
                                                        MediaQuery.sizeOf(
                                                          context,
                                                        ).height *
                                                        0.305 *
                                                        .6,
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      color: mainColor
                                                          .withAlpha(160),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 5,
                                                              horizontal: 10,
                                                            ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            TranslatableText(
                                                              BlocProvider.of<
                                                                    RecipesCubit
                                                                  >(context)
                                                                  .randomRecipes[0]
                                                                  .title
                                                                  .capitalizeByWord(),
                                                              style: TextStyle(
                                                                color:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 19,
                                                                fontVariations: [
                                                                  FontVariation(
                                                                    'wght',
                                                                    700,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Icon(
                                                                  Icons.timer,
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                ),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                TranslatableText(
                                                                  "${BlocProvider.of<RecipesCubit>(context).randomRecipes[0].readyInMinutes} Min",
                                                                  style: TextStyle(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                    fontSize:
                                                                        17,
                                                                    fontVariations: [
                                                                      FontVariation(
                                                                        'wght',
                                                                        600,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 10,
                                                    right: 10,
                                                    child: BookmarkButton(
                                                      dataModel:
                                                          BlocProvider.of<
                                                            RecipesCubit
                                                          >(
                                                            context,
                                                          ).randomRecipes.first,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 20,
                                    ),
                                    child: Row(
                                      children: [
                                        Row(
                                          children: [
                                            TranslatableText(
                                              "Recipes",
                                              style: TextStyle(
                                                fontSize: 25,
                                                fontVariations: [
                                                  FontVariation('wght', 700),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        GestureDetector(
                                          onTap:
                                              () => context.push("/allRecipes"),
                                          child: Row(
                                            children: [
                                              TranslatableText(
                                                "See all ",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontVariations: [
                                                    FontVariation('wght', 600),
                                                  ],
                                                  color: mainColor,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_rounded,
                                                color: mainColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // the horizontal list view of recipes
                                  state is RecipesLoading
                                      ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                      : SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                            0.305,
                                        child: BlocBuilder<
                                          RecipesCubit,
                                          RecipesState
                                        >(
                                          builder: (context, state) {
                                            return ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  (BlocProvider.of<
                                                    RecipesCubit
                                                  >(
                                                    context,
                                                  ).randomRecipes.length) -
                                                  1,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 17,
                                                      ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print("====>");
                                                          print(
                                                            BlocProvider.of<
                                                                  RecipesCubit
                                                                >(context)
                                                                .randomRecipes
                                                                .length,
                                                          );
                                                          print("<====");

                                                          context.push(
                                                            "/recipeInfo",
                                                            // pass the recipe model to the next screen using extra
                                                            extra:
                                                                BlocProvider.of<
                                                                  RecipesCubit
                                                                >(
                                                                  context,
                                                                ).randomRecipes[index +
                                                                    1],
                                                          );
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              width:
                                                                  MediaQuery.sizeOf(
                                                                    context,
                                                                  ).width *
                                                                  .7,
                                                              height:
                                                                  MediaQuery.sizeOf(
                                                                    context,
                                                                  ).height *
                                                                  .26,
                                                              decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      10,
                                                                    ),
                                                                image: DecorationImage(
                                                                  image: NetworkImage(
                                                                    BlocProvider.of<
                                                                          RecipesCubit
                                                                        >(context)
                                                                        .randomRecipes[index +
                                                                            1]
                                                                        .imageUrl,
                                                                  ),
                                                                  fit:
                                                                      BoxFit
                                                                          .cover,
                                                                ),
                                                                color:
                                                                    mainColor,
                                                              ),
                                                            ),
                                                            Positioned(
                                                              top: 10,
                                                              right: 10,
                                                              child: BookmarkButton(
                                                                dataModel:
                                                                    BlocProvider.of<
                                                                      RecipesCubit
                                                                    >(
                                                                      context,
                                                                    ).randomRecipes[index +
                                                                        1],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                              context,
                                                            ).width *
                                                            .5,
                                                        child: TranslatableText(
                                                          BlocProvider.of<
                                                                RecipesCubit
                                                              >(context)
                                                              .randomRecipes[index +
                                                                  1]
                                                              .title
                                                              .capitalizeByWord(),
                                                          style: TextStyle(
                                                            fontSize: 19,
                                                            fontVariations: [
                                                              FontVariation(
                                                                'wght',
                                                                600,
                                                              ),
                                                            ],
                                                          ),
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
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
                                  SizedBox(height: 40),
                                ],
                              ),
                            ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    // backgroundColor: mainColor,
                    onPressed: () {
                      context.push("/bookmark");
                    },
                    child: const Icon(Icons.bookmark, size: 30),
                  ),
                );
              },
            ),
          );
        },
      ),
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
                                child: TranslatableText(
                                  BlocProvider.of<RecipesCubit>(
                                    context,
                                  ).allRecipes[index].title.capitalizeByWord(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontVariations: [
                                      FontVariation('wght', 700),
                                    ],
                                  ),
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
                                        TranslatableText(
                                          "Time",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: greyColor,
                                            fontVariations: [
                                              FontVariation('wght', 600),
                                            ],
                                          ),
                                        ),
                                        TranslatableText(
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
              child: TranslatableText(
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
