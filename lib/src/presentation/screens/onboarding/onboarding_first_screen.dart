import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/primary_button.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';
import 'package:hive/hive.dart';

class OnboardingFirstScreen extends StatefulWidget {
  const OnboardingFirstScreen({super.key});

  @override
  State<OnboardingFirstScreen> createState() => _OnboardingFirstScreenState();
}

class _OnboardingFirstScreenState extends State<OnboardingFirstScreen> {
  @override
  void initState() {
    super.initState();
    Hive.box("myBox").put("isDarkMode",
        Hive.box("myBox").get("isDarkMode", defaultValue: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreenBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // Fond décoratif
            Positioned(
              right: 0,
              top: 50,
              child: SvgPicture.asset(
                "assets/svg/green_leaves.svg",
                width: 150,
              ),
            ),

            // Contenu principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Illustration animée (remplacez par Lottie si possible)
                  Hero(
                    tag: 'onboarding-1',
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryGreen.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: SvgPicture.asset(
                        "assets/svg/onboarding-1.svg",
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
                      "Find Your Comfort\nHealthy Food Here",
                      textAlign: TextAlign.center,
                      style: CustomTextStyle.size27Weight600Text().copyWith(
                        height: 1.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Sous-titre
                  Text(
                    "Discover delicious and nutritious meals tailored to your taste and dietary needs",
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
                        )
                      ],
                    ),
                    child: PrimaryButton(
                      text: "Explore Now",
                      onTap: () {
                        Navigator.pushNamed(context, "/onboarding/second");
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Indicateur de page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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