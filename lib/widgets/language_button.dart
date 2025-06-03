// language_toggle_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/services/cubit/language/language_cubit.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        final languageCubit = context.read<LanguageCubit>();

        return Container(
          decoration: BoxDecoration(
            color: mainColor.withAlpha(50),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: mainColor.withAlpha(150)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                // blurStyle: BlurStyle.normal,
                spreadRadius: -6,
                offset: Offset(0, 4),
              ),
            ],
          ),

          child: GestureDetector(
            onTap: () {
              languageCubit.isArabic
                  ? languageCubit.setLanguage("en")
                  : languageCubit.setLanguage("ar");
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                languageCubit.currentLanguage == "en" ? "عربى" : "English",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
