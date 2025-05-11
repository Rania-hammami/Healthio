import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/primary_button.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';

class OnboardingSecondScreen extends StatelessWidget {
  const OnboardingSecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreenBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Fond décoratif
            Positioned(
              left: 0,
              bottom: 50,
              child: SvgPicture.asset(
                "assets/svg/green_leaves.svg",
                width: 120,
              ),
            ),

            // Contenu principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Illustration avec ombre portée
                  Hero(
                    tag: 'onboarding-2',
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: SvgPicture.asset(
                        "assets/svg/onboarding-2.svg",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Titre avec effet de dégradé
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        AppColors.primaryGreen,
                        AppColors.accentGreen,
                      ],
                    ).createShader(bounds),
                    child: Text(
                      "Healthy is Where Your Comfort\nHealthyFood Lives",
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.size27Weight600Text().copyWith(
                        height: 1.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sous-titre
                  Text(
                    "Enjoy a fast and healthy food delivery\nright at your doorstep",
                    textAlign: TextAlign.center,
                    style: CustomTextStyle.size16Weight400Text().copyWith(
                      color: AppColors.darkGreen.withOpacity(0.7),
                    ),
                  ),

                  const Spacer(),

                  // Bouton avec effet de profondeur
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: PrimaryButton(
                      text: "Get Started",
                      onTap: () {
                        Navigator.pushNamed(context, "/register");
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Indicateurs de page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 24,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}