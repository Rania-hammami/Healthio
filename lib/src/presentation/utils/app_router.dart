import 'package:flutter/material.dart';
import 'package:testflutterapp/src/data/models/food.dart';
import 'package:testflutterapp/src/data/models/order.dart';
import 'package:testflutterapp/src/data/models/restaurant.dart';
import 'package:testflutterapp/src/presentation/screens/auth/forgot_password_screen.dart';
import 'package:testflutterapp/src/presentation/screens/auth/login_screen.dart';
import 'package:testflutterapp/src/presentation/screens/auth/register_process_screen.dart';
import 'package:testflutterapp/src/presentation/screens/auth/register_screen.dart';
import 'package:testflutterapp/src/presentation/screens/auth/register_success_screen.dart';
import 'package:testflutterapp/src/presentation/screens/auth/set_location_screen.dart';
import 'package:testflutterapp/src/presentation/screens/auth/upload_photo_screen.dart';
import 'package:testflutterapp/src/presentation/screens/explore/food_details_screen.dart';
import 'package:testflutterapp/src/presentation/screens/explore/food_list_screen.dart';
import 'package:testflutterapp/src/presentation/screens/explore/restaurant_details_screen.dart';
import 'package:testflutterapp/src/presentation/screens/explore/restaurant_list_screen.dart';
import 'package:testflutterapp/src/presentation/screens/home/home_screen.dart';
import 'package:testflutterapp/src/presentation/screens/home/settings_screen.dart';
import 'package:testflutterapp/src/presentation/screens/onboarding/onboarding_first_screen.dart';
import 'package:testflutterapp/src/presentation/screens/onboarding/onboarding_second_screen.dart';
import 'package:testflutterapp/src/presentation/screens/order/cart_screen.dart';
import 'package:testflutterapp/src/presentation/screens/order/order_confirm_screen.dart';
import 'package:testflutterapp/src/presentation/screens/order/order_details_screen.dart';
import 'package:testflutterapp/src/presentation/screens/order/order_list_screen.dart';
import 'package:testflutterapp/src/presentation/screens/order/review_screen.dart';
import 'package:testflutterapp/src/presentation/screens/splash_screen.dart';

import '../screens/splash_screen0.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case '/':
        return MaterialPageRoute(
          builder: (_) => HealthySplashScreen(),
        );

      case '/onboarding/first':
        return MaterialPageRoute(
          builder: (_) => const OnboardingFirstScreen(),
        );

      case '/onboarding/second':
        return MaterialPageRoute(
          builder: (_) => const OnboardingSecondScreen(),
        );

      case '/register':
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

      case '/register/process':
        return MaterialPageRoute(
          builder: (_) => const RegisterProcessScreen(),
        );

      case '/register/upload-photo':
        return MaterialPageRoute(
          builder: (_) => const UploadPhotoScreen(),
        );

      case '/register/set-location':
        return MaterialPageRoute(
          builder: (_) => const SetLocationScreen(),
        );

      case '/register/success':
        return MaterialPageRoute(
          builder: (_) => const RegisterSuccessScreen(),
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case '/login/forgot-password':
        return MaterialPageRoute(
          builder: (_) => const ForgotPasswordScreen(),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case '/restaurants':
        return MaterialPageRoute(
          builder: (_) => const RestaurantListScreen(),
        );

      case '/restaurants/detail':
        return MaterialPageRoute(
          builder: (_) => RestaurantDetailsScreen(
            restaurant: settings.arguments as Restaurant,
          ),
        );

      case '/foods':
        return MaterialPageRoute(
          builder: (_) => const FoodListScreen(),
        );

      case '/foods/detail':
        return MaterialPageRoute(
          builder: (_) => FoodDetailsScreen(
            food: settings.arguments as Food,
          ),
        );

      case '/settings':
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case '/cart':
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
        );

      case '/order/confirm':
        return MaterialPageRoute(
          builder: (_) => const OrderConfirmScreen(),
        );

      case '/order/review':
        return MaterialPageRoute(
          builder: (_) => ReviewScreen(
            order: settings.arguments as Order,
          ),
        );
      case '/orders':
        return MaterialPageRoute(
          builder: (_) => const OrderListScreen(),
        );

      case '/orders/detail':
        return MaterialPageRoute(
          builder: (_) => OrderDetailsScreen(
            order: settings.arguments as Order,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
