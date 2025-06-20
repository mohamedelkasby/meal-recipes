import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:html/parser.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/extention/extentions.dart';
import 'package:meals_recipes/models/translatable_text.dart';
import 'package:meals_recipes/services/cubit/language/language_cubit.dart';
import 'package:meals_recipes/services/cubit/recipes_cubit/recipes_cubit.dart';
import 'package:meals_recipes/services/models/recipes_model.dart';
import 'package:meals_recipes/widgets/bookmark_button.dart';
import 'package:meals_recipes/widgets/expandable_text.dart';
import 'package:meals_recipes/widgets/handle_image_error.dart';
import 'package:meals_recipes/widgets/icon_with_icon.dart';
import 'package:meals_recipes/widgets/no_internet_banner.dart';
import 'package:meals_recipes/widgets/unit_toggle_button.dart';

class RecipeInformation extends StatefulWidget {
  const RecipeInformation({super.key, required this.recipesModel});

  final RecipesModel recipesModel;

  @override
  State<RecipeInformation> createState() => _RecipeInformationState();
}

class _RecipeInformationState extends State<RecipeInformation> {
  late int servings;
  @override
  void initState() {
    servings = widget.recipesModel.servings;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueEquipment = widget.recipesModel.equipment.toSet().toList();
    RegExp caloriesExpression = RegExp(
      r'(\d+)\s*(?=calories)',
      caseSensitive: false,
    );
    Match? calories = caloriesExpression.firstMatch(
      widget.recipesModel.description,
    );
    RegExp minutsExpression = RegExp(
      r'(\d+)\s*(?=minutes)',
      caseSensitive: false,
    );
    Match? minuts = minutsExpression.firstMatch(
      widget.recipesModel.description,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        top: true,
        bottom: false,
        child: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, state) {
            return Directionality(
              textDirection:
                  context.read<LanguageCubit>().isArabic
                      ? TextDirection.rtl
                      : TextDirection.ltr,

              child: Scaffold(
                body: Stack(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.4,
                      width: double.infinity,
                      child: handleImageError(
                        urlImage: widget.recipesModel.imageUrl,
                        errorImage: Image.asset(
                          "assets/images/no_Internet.jpeg",
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      left: 20,
                      right: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                          widget.recipesModel.title == ""
                              ? SizedBox()
                              : BookmarkButton(dataModel: widget.recipesModel),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.4 - 40,
                        ),

                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 10,
                                right: 10,
                              ),
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 20,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Container(
                                          width: 60,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (widget.recipesModel.healthy)
                                            Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.green,
                                                  ),
                                                  child: const Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                TranslatableText(
                                                  "healthy"
                                                      .capitalizeFirstLetter(),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (widget.recipesModel.favorite)
                                            Row(
                                              children: [
                                                const SizedBox(width: 20),
                                                Container(
                                                  width: 30,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red,
                                                  ),
                                                  child: const Icon(
                                                    Icons.favorite,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                TranslatableText(
                                                  "popular"
                                                      .capitalizeFirstLetter(),
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      TranslatableText(
                                        widget.recipesModel.title,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            textWithIcon(
                                              icon: Icon(
                                                Icons.timer_outlined,
                                                color: greyColor,
                                              ),
                                              text:
                                                  '${minuts?.group(1) ?? widget.recipesModel.readyInMinutes} mins',
                                            ),
                                            textWithIcon(
                                              icon: Icon(
                                                Icons.restaurant_menu,
                                                color: greyColor,
                                              ),
                                              text:
                                                  '${widget.recipesModel.servings} servings',
                                            ),
                                            textWithIcon(
                                              icon: Icon(Icons.abc),
                                              svgImg: "assets/images/fire.svg",
                                              text:
                                                  '${calories?.group(1) ?? "NA"} Kcal',
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 15),
                                      widget.recipesModel.diets.isNotEmpty
                                          ? TranslatableText(
                                            "diets".capitalizeFirstLetter(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          )
                                          : SizedBox(),
                                      SizedBox(
                                        height:
                                            widget.recipesModel.diets.isNotEmpty
                                                ? 10
                                                : 0,
                                      ),
                                      widget.recipesModel.diets.isNotEmpty
                                          ? Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: TranslatableText(
                                              widget.recipesModel.diets.join(
                                                ', ',
                                              ),
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                          : SizedBox(),
                                      const SizedBox(height: 20),

                                      TranslatableText(
                                        "description".capitalizeFirstLetter(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10),

                                      ExpandableText(
                                        text:
                                            parse(
                                              widget.recipesModel.description,
                                            ).body?.text ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TranslatableText(
                                            "Serving".capitalizeFirstLetter(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Text(
                                            "(   ${servings.toString()}   )",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Row(
                                            children: [
                                              Container(
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.green,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.add,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      servings++;
                                                    });
                                                  },
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Container(
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: mainColor,
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.remove,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (servings > 1) {
                                                        servings--;
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TranslatableText(
                                            "ingredients"
                                                .capitalizeFirstLetter(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          UnitToggleButton(),
                                        ],
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            widget
                                                .recipesModel
                                                .ingredients
                                                .length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 5,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Left side: Image and Ingredient Name
                                                Flexible(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 80,
                                                        height: 80,
                                                        child: handleImageError(
                                                          urlImage:
                                                              "https://spoonacular.com/cdn/ingredients_100x100/${widget.recipesModel.ingredients[index].image}",
                                                          errorImage:
                                                              SvgPicture.asset(
                                                                "assets/images/no_image.svg",
                                                              ),
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 15),
                                                      Flexible(
                                                        child: TranslatableText(
                                                          widget
                                                              .recipesModel
                                                              .ingredients[index]
                                                              .originalName
                                                              .capitalizeByWord(),
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          maxLines: 2,
                                                          softWrap: true,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Right side: Amount and Unit
                                                BlocConsumer<
                                                  RecipesCubit,
                                                  RecipesState
                                                >(
                                                  listener: (context, state) {},
                                                  buildWhen:
                                                      (previous, current) =>
                                                          current
                                                              is UnitTypeChanged,
                                                  builder: (context, state) {
                                                    RecipesCubit recipeBloc =
                                                        context
                                                            .read<
                                                              RecipesCubit
                                                            >();

                                                    String amount = "";
                                                    String unit = "";
                                                    if (recipeBloc.ismetric) {
                                                      amount =
                                                          ((double.parse(
                                                                    widget
                                                                        .recipesModel
                                                                        .ingredients[index]
                                                                        .metricAmount,
                                                                  )) /
                                                                  (widget
                                                                      .recipesModel
                                                                      .servings) *
                                                                  servings)
                                                              .formatted;
                                                      unit =
                                                          widget
                                                              .recipesModel
                                                              .ingredients[index]
                                                              .metricUnit;
                                                    } else if (recipeBloc
                                                        .isUS) {
                                                      amount =
                                                          ((double.parse(
                                                                    widget
                                                                        .recipesModel
                                                                        .ingredients[index]
                                                                        .usAmount,
                                                                  )) /
                                                                  (widget
                                                                      .recipesModel
                                                                      .servings) *
                                                                  servings)
                                                              .formatted;

                                                      unit =
                                                          widget
                                                              .recipesModel
                                                              .ingredients[index]
                                                              .usUnit;
                                                    }
                                                    return Row(
                                                      children: [
                                                        Text(
                                                          amount,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        TranslatableText(
                                                          unit,
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 16,
                                                                color:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      TranslatableText(
                                        "equipment".capitalizeFirstLetter(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: uniqueEquipment.length,
                                        itemBuilder: (context, index) {
                                          return Row(
                                            children: [
                                              SizedBox(
                                                width: 80,
                                                height: 80,
                                                child: handleImageError(
                                                  urlImage:
                                                      '${uniqueEquipment[index].image}',
                                                  errorImage: SvgPicture.asset(
                                                    "assets/images/no_image.svg",
                                                  ),
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                              const SizedBox(width: 15),
                                              TranslatableText(
                                                uniqueEquipment[index].name
                                                    .capitalizeByWord(),
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                      TranslatableText(
                                        "steps".capitalizeFirstLetter(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount:
                                            widget.recipesModel.steps.length,
                                        itemBuilder: (context, index) {
                                          return TranslatableText(
                                            "${index + 1} - ${widget.recipesModel.steps[index].description}",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // No Internet Banner
                    noInternetBanner(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
