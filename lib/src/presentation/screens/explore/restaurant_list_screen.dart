import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testflutterapp/src/bloc/restaurant/restaurant_bloc.dart';
import 'package:testflutterapp/src/data/models/restaurant.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/back_button.dart';
import 'package:testflutterapp/src/presentation/widgets/items/restaurant_item.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/app_styles.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';

class RestaurantListScreen extends StatefulWidget {
  const RestaurantListScreen({super.key});

  @override
  State<RestaurantListScreen> createState() => _RestaurantListScreenState();
}

class _RestaurantListScreenState extends State<RestaurantListScreen> {
  List<Restaurant> _restaurants = [];
  List<Restaurant> _filteredRestaurants = [];
  final TextEditingController _searchController = TextEditingController();
  final int _restaurantLimit = 10;
  double _patternOpacity = 1.0;
  final double _patternHeight = 180.0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RestaurantBloc>(context).add(
      LoadRestaurants(limit: _restaurantLimit, lastDocument: null),
    );
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final double offset = _scrollController.offset;
    setState(() {
      _patternOpacity = (1 - offset / _patternHeight).clamp(0.0, 1.0);
    });
  }

  void _filterRestaurants(String value) {
    setState(() {
      _filteredRestaurants = _restaurants
          .where((restaurant) => restaurant.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RestaurantBloc, RestaurantState>(
      listener: (context, state) {
        if (state is RestaurantsLoadingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorColor,
            ),
          );
        } else if (state is RestaurantsLoaded) {
          setState(() {
            _restaurants = state.restaurants;
            _filteredRestaurants = state.restaurants;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors().backgroundColor,
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: _patternOpacity,
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white.withOpacity(0.8)],
                      stops: [0.0, 1.0],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: SizedBox(
                    height: _patternHeight,
                    child: SvgPicture.asset(
                      "assets/svg/pattern-big.svg",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const CustomBackButton(),
                      const SizedBox(height: 30),
                      Text(
                        "Top Healthy Restaurants 🍴",
                        style: CustomTextStyle.size22Weight600Text(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Discover the best places for healthy eating",
                        style: CustomTextStyle.size14Weight400Text(
                            AppColors().secondaryTextColor),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors().cardColor,
                          borderRadius: AppStyles.defaultBorderRadius,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _filterRestaurants,
                          decoration: InputDecoration(
                            hintText: "Search restaurants...",
                            hintStyle: CustomTextStyle.size14Weight400Text(
                                AppColors().secondaryTextColor),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                "assets/svg/search.svg",
                                color: AppColors().secondaryTextColor,
                              ),
                            ),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: SvgPicture.asset(
                                "assets/svg/leaf.svg",
                                color: AppColors.primaryColor,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderRadius: AppStyles.defaultBorderRadius,
                              borderSide: BorderSide.none,
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      BlocBuilder<RestaurantBloc, RestaurantState>(
                        builder: (context, state) {
                          if (state is RestaurantsLoading) {
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              itemCount: _restaurantLimit,
                              itemBuilder: (context, index) {
                                return const RestaurantItemShimmer();
                              },
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.9,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: _filteredRestaurants.length,
                            itemBuilder: (context, index) {
                              return RestaurantItem(
                                restaurant: _filteredRestaurants[index],
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}