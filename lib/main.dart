import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/routes.dart';
import 'package:meals_recipes/services/cubit/bookmark_cubit/bookmark_cubit.dart';
import 'package:meals_recipes/services/cubit/connectivity_cubit/connectivity_cubit.dart';
import 'package:meals_recipes/services/cubit/language/language_cubit.dart';
import 'package:meals_recipes/services/cubit/recipes_cubit/recipes_cubit.dart';
import 'package:meals_recipes/services/cubit/search_cubit/search_cubit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => RecipesCubit(), lazy: false),
        BlocProvider(create: (context) => SearchCubit()),
        BlocProvider(create: (context) => BookmarkCubit(), lazy: false),
        BlocProvider(create: (context) => LanguageCubit(), lazy: false),
        BlocProvider(create: (context) => ConnectivityCubit(), lazy: false),
      ],

      child: MaterialApp.router(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        // themeMode: ThemeMode.system,
        // darkTheme: ThemeData.dark(useMaterial3: true),
        theme: ThemeData(
          fontFamily: "Inter",
          // useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        ),

        routerConfig: routes,
      ),
    );
  }
}
