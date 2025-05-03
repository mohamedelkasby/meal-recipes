import 'package:flutter/material.dart';
import 'package:meals_recipes/extention/colors.dart';
import 'package:meals_recipes/extention/extentions.dart';
import 'package:meals_recipes/widgets/category_header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Find best recipes\nfor cooking",
                style: TextStyle(
                  fontSize: 24,
                  fontVariations: [FontVariation('wght', 700)],
                ),
              ),
              const SizedBox(height: 25),
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: greyColor),
                  hintText: "Search recipes",
                  hintStyle: TextStyle(
                    fontSize: 16,
                    fontVariations: [FontVariation('wght', 400)],
                    color: Colors.grey,
                  ),
                  // filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: greyColor, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: darkmainColor, width: 2),
                  ),
                ),
              ),
              categoryHeader(
                title: "trending now ",
                isIcon: true,
                isSeeAll: true,
              ),
              // the horizontal list view of recipes
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.305,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 17),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * .7,
                            height: MediaQuery.sizeOf(context).height * .26,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: mainColor,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * .5,
                            child: Text(
                              "this is recipe",
                              style: TextStyle(
                                fontSize: 19,
                                fontVariations: [FontVariation('wght', 600)],
                              ),
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              categoryHeader(title: "popular category"),

              // the horizontal list view of categories
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.055,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,

                  itemBuilder: (context, index) {
                    return Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: mainColor,
                        ),
                        child: Text(
                          "recipe category".capitalizeFirstLetter(),
                          style: TextStyle(
                            fontSize: 16,
                            fontVariations: [FontVariation('wght', 700)],
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),

              // the  list view of recipes
              LayoutBuilder(
                builder: (context, constraints) {
                  final double width = constraints.maxWidth;
                  return SizedBox(
                    height: width * .855,
                    child: ListView.builder(
                      // shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 20),

                          child: SizedBox(
                            width: width * .56,

                            child: Stack(
                              // clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: width * .23,

                                  child: Container(
                                    width: width * .56,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: lightgreyColor,
                                    ),
                                    child: Column(
                                      children: [
                                        SizedBox(height: width * .23),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 15,
                                          ),
                                          child: Text(
                                            "first recipe name sad"
                                                .capitalizeByWord(),
                                            textAlign: TextAlign.center,

                                            style: TextStyle(
                                              fontSize: 19,
                                              fontVariations: [
                                                FontVariation('wght', 700),
                                              ],
                                            ),
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                            18,
                                            0,
                                            18,
                                            15,
                                          ),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Time",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: greyColor,
                                                      fontVariations: [
                                                        FontVariation(
                                                          'wght',
                                                          600,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Text(
                                                    "20 Min",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontVariations: [
                                                        FontVariation(
                                                          'wght',
                                                          650,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Spacer(),
                                              CircleAvatar(
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.bookmark_border_rounded,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // the circle avatar
                                Positioned(
                                  top: 0,
                                  left: width * .055,

                                  child: Container(
                                    width: width * .45,
                                    height: width * .45,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: mainColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
              categoryHeader(title: "recent recipe"),
            ],
          ),
        ),
      ),
    );
  }
}
