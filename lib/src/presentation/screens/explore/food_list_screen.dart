import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testflutterapp/src/bloc/food/food_bloc.dart';
import 'package:testflutterapp/src/data/models/food.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/back_button.dart';
import 'package:testflutterapp/src/presentation/widgets/items/food_item.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/app_styles.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';

class FoodListScreen extends StatefulWidget {
  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final ScrollController _scrollController = ScrollController();
  DocumentSnapshot? _lastDocument;
  final List<Food> _foods = [];
  List<Food> _filteredFoods = [];
  final TextEditingController _searchController = TextEditingController();
  final int _foodLimit = 5;
  double _patternOpacity = 1.0;
  final double _patternHeight = 180.0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FoodBloc>(context).add(
      LoadFoods(limit: 20, lastDocument: _lastDocument),
    );

    _scrollController.addListener(_handleScroll);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        BlocProvider.of<FoodBloc>(context).add(
          FetchMoreFoods(limit: _foodLimit, lastDocument: _lastDocument),
        );
      }
    });
  }

  void _handleScroll() {
    final double offset = _scrollController.offset;
    setState(() {
      _patternOpacity = (1 - offset / _patternHeight).clamp(0.0, 1.0);
    });
  }

  void _filterFoods(String value) {
    setState(() {
      _filteredFoods = _foods
          .where((food) => food.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FoodBloc, FoodState>(
      listener: (context, state) {
        if (state is FoodError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is FoodMoreFetched) {
          _lastDocument = state.lastDocument;
          setState(() {
            _foods.addAll(state.foods.where((food) => !_foods.contains(food)));
            _filteredFoods = _foods;
          });
        }
        if (state is FoodFetched) {
          _lastDocument = state.lastDocument;
          setState(() {
            _foods.addAll(state.foods);
            _filteredFoods = _foods;
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
                        "Discover Healthy Foods 🥗",
                        style: CustomTextStyle.size22Weight600Text(),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Fresh, organic meals for a healthier you",
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
                          onChanged: _filterFoods,
                          decoration: InputDecoration(
                            hintText: "Search healthy meals...",
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
                      Text(
                        "🌟 All Healthy Meals",
                        style: CustomTextStyle.size16Weight400Text(),
                      ),
                      const SizedBox(height: 20),
                      BlocBuilder<FoodBloc, FoodState>(
                        builder: (context, state) {
                          if (state is FoodFetching && _foods.isEmpty) {
                            return const Column(
                              children: [
                                FoodItemShimmer(),
                                SizedBox(height: 15),
                                FoodItemShimmer(),
                                SizedBox(height: 15),
                                FoodItemShimmer(),
                              ],
                            );
                          }
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: _filteredFoods.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: FoodItem(food: _filteredFoods[index]),
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