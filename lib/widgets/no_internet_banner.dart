import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meals_recipes/models/translatable_text.dart';
import 'package:meals_recipes/services/cubit/connectivity_cubit/connectivity_cubit.dart';

BlocBuilder<ConnectivityCubit, ConnectivityState> noInternetBanner() {
  return BlocBuilder<ConnectivityCubit, ConnectivityState>(
    builder: (context, connectivityState) {
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
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Icon(Icons.wifi_off, color: Colors.white, size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: TranslatableText(
                      "No internet connection",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontVariations: [FontVariation('wght', 600)],
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
  );
}
