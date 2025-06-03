import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/models/translatable_text.dart';
import 'package:meals_recipes/services/cubit/language/language_cubit.dart';
import 'package:meals_recipes/services/cubit/recipes_cubit/recipes_cubit.dart';

class UnitToggleButton extends StatelessWidget {
  const UnitToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipesCubit, RecipesState>(
      builder: (context, state) {
        final recipcubit = context.read<RecipesCubit>();

        return Container(
          width: 120, // fixed width for toggle container
          height: 40,
          decoration: BoxDecoration(
            color: mainColor.withAlpha(50),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: mainColor.withAlpha(150)),
          ),
          child: Stack(
            children: [
              // Sliding selector
              AnimatedAlign(
                alignment:
                    BlocProvider.of<LanguageCubit>(context).isArabic
                        ? recipcubit.ismetric
                            ? Alignment.centerRight
                            : Alignment.centerLeft
                        : recipcubit.ismetric
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Container(
                  width: 60,
                  margin: EdgeInsets.all(2), // small margin inside container
                  decoration: BoxDecoration(
                    color: mainColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              // Row of two text buttons on top
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        recipcubit.unitToggleButton();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: TranslatableText(
                          'metric',
                          style: TextStyle(
                            color:
                                recipcubit.ismetric ? Colors.white : mainColor,
                            fontWeight:
                                recipcubit.ismetric
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!recipcubit.isUS) {
                          recipcubit.unitToggleButton();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        child: TranslatableText(
                          'units',
                          style: TextStyle(
                            color: recipcubit.isUS ? Colors.white : mainColor,
                            fontWeight:
                                recipcubit.isUS
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
