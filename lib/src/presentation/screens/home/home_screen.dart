import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testflutterapp/src/bloc/food/food_bloc.dart';
import 'package:testflutterapp/src/bloc/order/order_bloc.dart';
import 'package:testflutterapp/src/bloc/restaurant/restaurant_bloc.dart';
import 'package:testflutterapp/src/bloc/theme/theme_bloc.dart';
import 'package:testflutterapp/src/data/models/food.dart';
import 'package:testflutterapp/src/data/models/restaurant.dart';
import 'package:testflutterapp/src/data/repositories/order_repository.dart';
import 'package:testflutterapp/src/presentation/screens/home/profile_screen.dart';
import 'package:testflutterapp/src/presentation/screens/order/order_list_screen.dart';
import 'package:testflutterapp/src/presentation/widgets/items/food_item.dart';
import 'package:testflutterapp/src/presentation/widgets/items/restaurant_item.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/app_styles.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final List<Restaurant> _restaurants = [];
  final List<Food> _foods = [];
  final List<Food> _filteredFoods = [];
  final TextEditingController _searchController = TextEditingController();
  final int _restaurantLimit = 5;
  final int _foodLimit = 5;
  late ScrollController _scrollController;
  double _patternOpacity = 1.0;
  final double _patternHeight = 180.0;
  String? _selectedCategoryId;
  final Map<String, String> _categoryMap = {
    'ngm36f2b0r3ttxJvyYC': 'Salads',
    'vegan_category_id': 'Vegan 🌱',
    'lowcarb_category_id': 'Low-Carb 🥑',
  };

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
    BlocProvider.of<RestaurantBloc>(context).add(
      LoadRestaurants(limit: _restaurantLimit, lastDocument: null),
    );
    BlocProvider.of<FoodBloc>(context).add(
      LoadFoods(limit: _foodLimit, lastDocument: null),
    );
    _filteredFoods.addAll(_foods);
  }

  void _handleScroll() {
    final double offset = _scrollController.offset;
    setState(() {
      _patternOpacity = (1 - offset / _patternHeight).clamp(0.0, 1.0);
    });
  }

  void _filterFoods() {
    _filteredFoods.clear();

    if (_searchController.text.isEmpty && _selectedCategoryId == null) {
      _filteredFoods.addAll(_foods);
      return;
    }

    _filteredFoods.addAll(_foods.where((food) {
      final matchesSearch = _searchController.text.isEmpty ||
          food.name.toLowerCase().contains(_searchController.text.toLowerCase());

      final matchesCategory = _selectedCategoryId == null ||
          food.category == _selectedCategoryId;

      return matchesSearch && matchesCategory;
    }));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundColor,
      body: _selectedIndex == 0
          ? _buildHomeBody(context)
          : _selectedIndex == 1
          ? const OrderListScreen()
          : const ProfileScreen(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          decoration: BoxDecoration(
            color: AppColors().cardColor,
            borderRadius: AppStyles.largeBorderRadius,
            boxShadow: [AppStyles().largeBoxShadow],
          ),
          child: ClipRRect(
            borderRadius: AppStyles.largeBorderRadius,
            child: NavigationBar(
              height: 70,
              backgroundColor: Colors.transparent,
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedIndex: _selectedIndex,
              destinations: [
                NavigationDestination(
                  icon: Opacity(
                    opacity: 0.5,
                    child: SvgPicture.asset("assets/svg/home.svg"),
                  ),
                  selectedIcon: SvgPicture.asset(
                    "assets/svg/home.svg",
                    color: AppColors.primaryColor,
                  ),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) {
                      return Badge(
                        backgroundColor: AppColors.errorColor,
                        isLabelVisible: OrderRepository.cart.isNotEmpty,
                        label: Text(
                          OrderRepository.cart.length.toString(),
                          style: CustomTextStyle.size14Weight400Text(Colors.white),
                        ),
                        offset: const Offset(10, -10),
                        child: Opacity(
                          opacity: 0.5,
                          child: SvgPicture.asset("assets/svg/cart.svg"),
                        ),
                      );
                    },
                  ),
                  selectedIcon: BlocBuilder<OrderBloc, OrderState>(
                    builder: (context, state) {
                      return Badge(
                        backgroundColor: AppColors.errorColor,
                        isLabelVisible: OrderRepository.cart.isNotEmpty,
                        label: Text(
                          OrderRepository.cart.length.toString(),
                          style: CustomTextStyle.size14Weight400Text(Colors.white),
                        ),
                        offset: const Offset(10, -10),
                        child: SvgPicture.asset(
                          "assets/svg/cart.svg",
                          color: AppColors.primaryColor,
                        ),
                      );
                    },
                  ),
                  label: "Cart",
                ),
                NavigationDestination(
                  icon: Opacity(
                    opacity: 0.5,
                    child: SvgPicture.asset("assets/svg/profile.svg"),
                  ),
                  selectedIcon: SvgPicture.asset(
                    "assets/svg/profile.svg",
                    color: AppColors.primaryColor,
                  ),
                  label: "Profile",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomeBody(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 70),
                _buildHeader(),
                const SizedBox(height: 50),
                _buildSearchField(),
                const SizedBox(height: 30),
                _buildPromoBanner(context),
                const SizedBox(height: 20),
                _buildRestaurantsSection(),
                const SizedBox(height: 30),
                _buildFoodsSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

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
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Find Your Healthy Food 🥗",
              style: CustomTextStyle.size22Weight600Text(),
            ),
          ],
        ),
        const SizedBox(height: 10),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Fresh, organic meals delivered fast 🚀\n",
                style: CustomTextStyle.size14Weight400Text(AppColors().secondaryTextColor),
              ),
              TextSpan(
                text: "Free delivery on orders > 80 dt",
                style: CustomTextStyle.size14Weight400Text(AppColors().secondaryTextColor)
                    .copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
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
        onChanged: (value) {
          _filterFoods();
        },
        decoration: InputDecoration(
          hintText: "Search healthy meals, restaurants...",
          hintStyle: CustomTextStyle.size14Weight400Text(AppColors().secondaryTextColor),
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
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildRestaurantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "🍴 Top Healthy Restaurants",
              style: CustomTextStyle.size16Weight400Text(),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/restaurants"),
              child: Row(
                children: [
                  Text(
                    "View All",
                    style: CustomTextStyle.size14Weight400Text(AppColors.primaryColor)
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16, color: AppColors.primaryColor),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        BlocBuilder<RestaurantBloc, RestaurantState>(
          builder: (context, state) {
            if (state is RestaurantsLoading) {
              return const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: RestaurantItemShimmer()),
                  SizedBox(width: 20),
                  Expanded(child: RestaurantItemShimmer()),
                ],
              );
            } else if (state is RestaurantsLoaded) {
              _restaurants.clear();
              _restaurants.addAll(state.restaurants);
            } else if (state is RestaurantsLoadingError) {
              return Center(child: Text(state.message));
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_restaurants.isNotEmpty)
                  Expanded(child: RestaurantItem(restaurant: _restaurants[0])),
                if (_restaurants.length > 1) ...[
                  const SizedBox(width: 20),
                  Expanded(child: RestaurantItem(restaurant: _restaurants[1])),
                ],
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildFoodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "🌟 Top  Healthy Meals",
              style: CustomTextStyle.size16Weight400Text(),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, "/foods"),
              child: Row(
                children: [
                  Text(
                    "View All",
                    style: CustomTextStyle.size14Weight400Text(AppColors.primaryColor)
                        .copyWith(decoration: TextDecoration.underline),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward, size: 16, color: AppColors.primaryColor),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Section de filtrage par catégories
        SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFoodCategory("All", null, _selectedCategoryId == null),
              ..._categoryMap.entries.map((entry) =>
                  _buildFoodCategory(entry.value, entry.key, _selectedCategoryId == entry.key)
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),

        BlocBuilder<FoodBloc, FoodState>(
          builder: (context, state) {
            if (state is FoodFetching) {
              return const Column(
                children: [
                  FoodItemShimmer(),
                  SizedBox(height: 15),
                  FoodItemShimmer(),
                  SizedBox(height: 15),
                  FoodItemShimmer(),
                ],
              );
            } else if (state is FoodFetched) {
              // Ne pas appeler setState ici
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _foods.clear();
                  _foods.addAll(state.foods);
                  _filterFoods();
                });
              });
            } else if (state is FoodError) {
              return Center(child: Text(state.message));
            }

            return _filteredFoods.isEmpty
                ? Center(
              child: Text(
                "No foods match your filters",
                style: CustomTextStyle.size14Weight400Text(
                  AppColors().secondaryTextColor,
                ),
              ),
            )
                : ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredFoods.length > _foodLimit ? _foodLimit : _filteredFoods.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: FoodItem(food: _filteredFoods[index]),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildFoodCategory(String label, String? categoryId, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = isActive ? null : categoryId;
          _filterFoods();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : AppColors().cardColor,
          borderRadius: AppStyles.defaultBorderRadius,
          border: Border.all(
            color: isActive ? Colors.transparent : AppColors().secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: CustomTextStyle.size14Weight400Text(
            isActive ? Colors.white : AppColors().secondaryTextColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, "/foods"),
      borderRadius: AppStyles.defaultBorderRadius,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryColor.withOpacity(0.8), AppColors.primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppStyles.defaultBorderRadius,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/svg/delivery.svg",
              width: 50,
              color: Colors.white,
              height: 70,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FREE DELIVERY",
                    style: CustomTextStyle.size14Weight600Text(Colors.white),
                  ),
                  Text(
                    "On all orders over 40 dt today!",
                    style: CustomTextStyle.size16Weight400Text(Colors.white.withOpacity(0.9)),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}