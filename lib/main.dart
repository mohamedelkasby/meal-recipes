import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/routes.dart';
import 'package:meals_recipes/services/cubit/recipes_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RecipesCubit(),
      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        // themeMode: ThemeMode.system,
        // darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData(
          fontFamily: "Inter",
          // useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: mainColor,
            // surface: const Color(0xffE23E3E),
            // onSurface: const Color(0xffE23E3E),
          ),
        ),

        // home: const WelcomePage(),
        routerConfig: routes,
      ),
    );
  }
}
