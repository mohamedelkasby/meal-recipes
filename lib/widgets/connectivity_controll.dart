import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/models/translatable_text.dart';
import 'package:meals_recipes/services/cubit/connectivity_cubit/connectivity_cubit.dart';
import 'package:meals_recipes/services/cubit/recipes_cubit/recipes_cubit.dart';
import 'package:meals_recipes/widgets/no_internet_banner.dart';

BlocListener<ConnectivityCubit, ConnectivityState> connectivityControll() {
  return BlocListener<ConnectivityCubit, ConnectivityState>(
    listener: (context, state) {
      if (state is ConnectivityConnected) {
        // Show a brief "Connected" message when internet is restored
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.wifi, color: Colors.white, size: 16),
                SizedBox(width: 8),
                TranslatableText(
                  "Internet connection restored",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height - 175,
              left: 16,
              right: 16,
            ),
          ),
        );
        // this line to get the random recipres if there is no recepes after reconnect
        if (BlocProvider.of<RecipesCubit>(context).randomRecipes.length <= 1) {
          BlocProvider.of<RecipesCubit>(context).getRandomRecipes();
        }
        // this line to get the all recipes if there is no recipes after reconnect
        if (BlocProvider.of<RecipesCubit>(context).allRecipes.isEmpty) {
          BlocProvider.of<RecipesCubit>(context).getAllRecipes();
        }
      }
    },
    child: noInternetBanner(),
  );
}
