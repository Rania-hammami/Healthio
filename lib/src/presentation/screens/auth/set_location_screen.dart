import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testflutterapp/src/data/services/firestore_db.dart';
import 'package:testflutterapp/src/presentation/screens/set_location_map_screen.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/back_button.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/default_button.dart';
import 'package:testflutterapp/src/data/models/user.dart';
import 'package:testflutterapp/src/presentation/widgets/loading_indicator.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/app_styles.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';
import 'package:hive/hive.dart';

class SetLocationScreen extends StatefulWidget {
  const SetLocationScreen({super.key});

  @override
  State<SetLocationScreen> createState() => _SetLocationScreenState();
}

class _SetLocationScreenState extends State<SetLocationScreen> {
  final _box = Hive.box('myBox');
  String _locationText = "Your location";
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _locationText = _box.get('location', defaultValue: "Your location");
  }

  Future<void> _submit() async {
    if (_box.get('location') == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please set your location"),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    _box.put('isRegistered', true);

    try {
      final db = FirestoreDatabase();
      await db.addDocument('users', User.fromHive().toMap());

      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/register/success',
              (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration failed: ${e.toString()}"),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appColors = AppColors();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor.withOpacity(0.05),
              appColors.backgroundColor,
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Opacity(
                opacity: 0.8,
                child: SvgPicture.asset(
                  "assets/svg/pattern-big.svg",
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).padding.top + 40,
                  ),
                  const CustomBackButton(),
                  const SizedBox(height: 20),
                  Text(
                    "Set Location",
                    style: CustomTextStyle.size25Weight600Text(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Set your location for better service",
                    style: CustomTextStyle.size16Weight400Text(
                      appColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: appColors.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [AppStyles.boxShadow7],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: AppColors.primaryColor,
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _locationText,
                                style: CustomTextStyle.size16Weight400Text(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: DefaultButton(
                            text: "Set Location on Map",
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const SetLocationMapScreen(),
                                ),
                              );
                              if (result != null && mounted) {
                                setState(() {
                                  _locationText = _box.get('location');
                                });
                              }
                            },
                            backgroundColor: AppColors.grayLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60, left: 24, right: 24),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 5,
                  shadowColor: AppColors.primaryGreen.withOpacity(0.3),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _isSubmitting ? null : _submit,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: AppColors.primaryGradient,
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Center(
                        child: _isSubmitting
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          "Complete Registration",
                          style: CustomTextStyle.size16Weight600Text(
                            Colors.white,
                          ),
                        ),
                      ),
                    ),
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