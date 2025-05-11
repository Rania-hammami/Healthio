import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/back_button.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/primary_button.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/app_styles.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';
import 'package:testflutterapp/src/presentation/utils/helpers.dart';

class RegisterProcessScreen extends StatefulWidget {
  const RegisterProcessScreen({super.key});

  @override
  State<RegisterProcessScreen> createState() => _RegisterProcessScreenState();
}

class _RegisterProcessScreenState extends State<RegisterProcessScreen> {
  final _box = Hive.box('myBox');
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final AppColors _appColors = AppColors(); // Instance de AppColors
  final AppStyles _appStyles = AppStyles(); // Instance de AppStyles

  @override
  void initState() {
    super.initState();
    _firstNameController.text = _box.get('firstName', defaultValue: '');
    _lastNameController.text = _box.get('lastName', defaultValue: '');
    _phoneController.text = _box.get('phone', defaultValue: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: _appColors.backgroundColor, // Couleur de fond unie
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Opacity(
                opacity: 0.5,
                child: SvgPicture.asset(
                  "assets/svg/pattern-big.svg",
                  color: AppColors.darkGreen, // Couleur du pattern
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).padding.top + 40,
                    ),
                    if (ModalRoute.of(context)!.canPop) ...[
                      const CustomBackButton(),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      "Fill in your bio to get \nstarted",
                      style: CustomTextStyle.size25Weight600Text(
                        _appColors.primaryTextColor, // Couleur du texte principal
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "This data will be displayed in your account \nprofile for security",
                      style: CustomTextStyle.size14Weight400Text(
                        _appColors.secondaryTextColor, // Couleur du texte secondaire
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        children: [
                          _buildTextField(
                            controller: _firstNameController,
                            hint: "First name",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "First name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _lastNameController,
                            hint: "Last name",
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Last name is required";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildTextField(
                            controller: _phoneController,
                            hint: "Mobile number",
                            validator: (value) {
                              if (!validatePhoneNumber(value!)) {
                                return "Invalid phone number";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bouton Next (conservé tel quel)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Material(
                  borderRadius: BorderRadius.circular(12),
                  elevation: 5,
                  shadowColor: AppColors.primaryColor.withOpacity(0.3),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _box.put('firstName', _firstNameController.text.trim());
                      _box.put('lastName', _lastNameController.text.trim());
                      _box.put('phone', _phoneController.text.trim());
                      Navigator.pushNamed(context, '/register/upload-photo');
                    },
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
                        child: Text(
                          "Next",
                          style: CustomTextStyle.size16Weight600Text(Colors.white),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [AppStyles.boxShadow7], // Ombre cohérente
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          fillColor: _appColors.cardColor, // Couleur de fond du champ
          filled: true,
          hintText: hint,
          hintStyle: CustomTextStyle.size14Weight400Text(
            _appColors.secondaryTextColor, // Couleur du hint
          ),
          contentPadding: const EdgeInsets.only(left: 20),
          enabledBorder: _appStyles.defaultEnabledBorder, // Bordure par défaut
          focusedBorder: AppStyles.defaultFocusedBorder(), // Bordure focus
          errorBorder: AppStyles.defaultErrorBorder, // Bordure erreur
          focusedErrorBorder: AppStyles.defaultFocusedErrorBorder, // Bordure erreur focus
        ),
      ),
    );
  }
}