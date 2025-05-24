import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/widgets/white_text.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Container(color: Colors.black),
            ShaderMask(
              shaderCallback:
                  (bounds) => LinearGradient(
                    stops: [0.5, 1],
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
              blendMode: BlendMode.dstOut,
              child: Image.asset(
                'assets/images/welcomBackground.png',

                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.white),
                      whiteText("  60K+", size: 20, weight: 700),
                      whiteText("  Premium Recipes", size: (20), weight: 500),
                    ],
                  ),
                  Column(
                    children: [
                      Align(
                        child: whiteText(
                          'Let\'s\ncooking',
                          size: 65,
                          weight: 700,
                          align: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withAlpha(80),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: whiteText(
                            '  find best recipes for cooking  ',
                            size: 20,
                            weight: 600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => {context.go('/home')},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            whiteText(
                              'Start Cooking   ',
                              size: 20,
                              weight: 700,
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 25,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
