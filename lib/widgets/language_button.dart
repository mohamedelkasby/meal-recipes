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
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLanguageOption(
                context,
                'EN',
                'en',
                languageCubit.isEnglish,
                languageCubit,
              ),
              _buildLanguageOption(
                context,
                'عربي',
                'ar',
                languageCubit.isArabic,
                languageCubit,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String label,
    String languageCode,
    bool isSelected,
    LanguageCubit cubit,
  ) {
    return GestureDetector(
      onTap: () => cubit.setLanguage(languageCode),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? mainColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : mainColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
