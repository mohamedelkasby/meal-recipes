import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/extention/extentions.dart';
import 'package:meals_recipes/models/translatable_text.dart';
import 'package:meals_recipes/services/cubit/connectivity_cubit/connectivity_cubit.dart';
import 'package:meals_recipes/services/cubit/language/language_cubit.dart';
import 'package:meals_recipes/services/cubit/recipes_cubit/recipes_cubit.dart';
import 'package:meals_recipes/widgets/bookmark_button.dart';
import 'package:meals_recipes/widgets/handle_image_error.dart';
import 'package:meals_recipes/widgets/language_button.dart';
import 'package:meals_recipes/widgets/search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    RegExp minExpression = RegExp(r'(\d+)\s*(?=minutes)', caseSensitive: false);
    Match? matchedTime = minExpression.firstMatch(
      BlocProvider.of<RecipesCubit>(context).randomRecipes[0].description,
    );
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
                  body: Stack(
                    children: [
                      Padding(
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
                                      fontVariations: [
                                        FontVariation('wght', 700),
                                      ],
                                    ),
                                  ),
                                )
                                : SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          SizedBox(width: 15),
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
                                          : Center(
                                            child: SizedBox(
                                              height:
                                                  MediaQuery.sizeOf(
                                                    context,
                                                  ).height *
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
                                                        SizedBox(
                                                          height:
                                                              MediaQuery.sizeOf(
                                                                context,
                                                              ).height *
                                                              0.305,
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            child: handleImageError(
                                                              urlImage:
                                                                  BlocProvider.of<
                                                                        RecipesCubit
                                                                      >(context)
                                                                      .randomRecipes[0]
                                                                      .imageUrl,

                                                              errorImage:
                                                                  Image.asset(
                                                                    "assets/images/no_Internet.jpeg",
                                                                  ),
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
                                                                    horizontal:
                                                                        10,
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
                                                                      fontSize:
                                                                          19,
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
                                                                        Icons
                                                                            .timer,
                                                                        color:
                                                                            Colors.white,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      TranslatableText(
                                                                        "${matchedTime?.group(1) ?? BlocProvider.of<RecipesCubit>(context).randomRecipes[0].readyInMinutes} Min",
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.white,
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

                                                          child:
                                                              BlocProvider.of<
                                                                            RecipesCubit
                                                                          >(context)
                                                                          .randomRecipes
                                                                          .first
                                                                          .title ==
                                                                      ""
                                                                  ? SizedBox()
                                                                  : BookmarkButton(
                                                                    dataModel:
                                                                        BlocProvider.of<
                                                                          RecipesCubit
                                                                        >(context).randomRecipes.first,
                                                                  ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
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
                                                      FontVariation(
                                                        'wght',
                                                        700,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const Spacer(),
                                            GestureDetector(
                                              onTap:
                                                  () => context.push(
                                                    "/allRecipes",
                                                  ),
                                              child: Row(
                                                children: [
                                                  TranslatableText(
                                                    "See all ",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontVariations: [
                                                        FontVariation(
                                                          'wght',
                                                          600,
                                                        ),
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
                                                MediaQuery.sizeOf(
                                                  context,
                                                ).height *
                                                0.305,
                                            child: BlocBuilder<
                                              RecipesCubit,
                                              RecipesState
                                            >(
                                              builder: (context, state) {
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      (BlocProvider.of<
                                                        RecipesCubit
                                                      >(
                                                        context,
                                                      ).randomRecipes.length) -
                                                      1,
                                                  itemBuilder: (
                                                    context,
                                                    index,
                                                  ) {
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
                                                                    color:
                                                                        mainColor,
                                                                  ),
                                                                  child: ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    child: handleImageError(
                                                                      urlImage:
                                                                          BlocProvider.of<
                                                                            RecipesCubit
                                                                          >(context).randomRecipes[index + 1].imageUrl,
                                                                      errorImage:
                                                                          Image.asset(
                                                                            "assets/images/no_Internet.jpeg",
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
                                                                        >(context).randomRecipes[index + 1],
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
                      // No Internet Banner
                      BlocListener<ConnectivityCubit, ConnectivityState>(
                        listener: (context, state) {
                          if (state is ConnectivityConnected) {
                            // Show a brief "Connected" message when internet is restored
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.wifi,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 8),
                                    TranslatableText(
                                      "Internet connection restored",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).size.height - 175,
                                  left: 16,
                                  right: 16,
                                ),
                              ),
                            );
                            // this line to get the random recipres if there is no recepes after reconnect
                            if (BlocProvider.of<RecipesCubit>(
                                  context,
                                ).randomRecipes.length <=
                                1) {
                              BlocProvider.of<RecipesCubit>(
                                context,
                              ).getRandomRecipes();
                            }
                            // this line to get the all recipres if there is no recepes after reconnect
                            if (BlocProvider.of<RecipesCubit>(
                              context,
                            ).allRecipes.isEmpty) {
                              BlocProvider.of<RecipesCubit>(
                                context,
                              ).getAllRecipes();
                            }
                          }
                        },
                        child: BlocBuilder<
                          ConnectivityCubit,
                          ConnectivityState
                        >(
                          builder: (context, connectivityState) {
                            // connectivityState = ConnectivityDisconnected();
                            // print(connectivityState);
                            if (connectivityState is ConnectivityDisconnected) {
                              return Positioned(
                                top: MediaQuery.of(context).padding.top,
                                left: 0,
                                right: 0,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  height: 50,
                                  color: Colors.red,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.wifi_off,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: TranslatableText(
                                            "No internet connection",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontVariations: [
                                                FontVariation('wght', 600),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
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
