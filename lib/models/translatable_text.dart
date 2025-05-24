// translatable_text.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/services/cubit/language/language_cubit.dart';

class TranslatableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final String? fromLanguage;
  final bool? softWrap;

  const TranslatableText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fromLanguage,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, state) {
        return FutureBuilder<String>(
          future: context.read<LanguageCubit>().translateText(
            text,
            fromLanguage: fromLanguage,
          ),
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? text,
              style: style,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
              softWrap: softWrap,
            );
          },
        );
      },
    );
  }
}
