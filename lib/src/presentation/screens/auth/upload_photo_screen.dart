import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:testflutterapp/src/data/services/firebase_storage.dart';
import 'package:testflutterapp/src/presentation/widgets/buttons/back_button.dart';
import 'package:testflutterapp/src/presentation/widgets/loading_indicator.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/app_styles.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  final FirebaseStorageService _firebaseStorageService = FirebaseStorageService(
    FirebaseStorage.instance,
  );
  XFile? _image;
  String? _imageUrl;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image != null) {
        setState(() => _image = image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to pick image: ${e.toString()}"),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _imageUrl = Hive.box('myBox').get('image', defaultValue: null);
  }

  Future<void> _submit() async {
    if (_image == null && _imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please upload a profile photo"),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final box = Hive.box('myBox');

    try {
      if (_image != null) {
        _imageUrl = await _firebaseStorageService.uploadImage(
          "users/${box.get('email')}",
          File(_image!.path),
        );
        box.put('image', _imageUrl);
      }

      if (mounted) {
        Navigator.pushNamed(context, '/register/set-location');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Upload failed: ${e.toString()}"),
          backgroundColor: AppColors.errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
                    "Profile Photo",
                    style: CustomTextStyle.size25Weight600Text(),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Upload a photo for your profile",
                    style: CustomTextStyle.size16Weight400Text(
                      appColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: _buildPhotoSection(),
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
                    onTap: _isLoading ? null : _submit,
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
                        child: _isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text(
                          "Continue",
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

  Widget _buildPhotoSection() {
    if (_image != null) {
      return _buildImagePreview(_image!);
    } else if (_imageUrl != null) {
      return _buildNetworkImagePreview(_imageUrl!);
    } else {
      return Column(
        children: [
          _buildUploadOption(
            icon: Icons.photo_library_outlined,
            label: "Choose from Gallery",
            onTap: () => _pickImage(ImageSource.gallery),
          ),
          const SizedBox(height: 20),
          _buildUploadOption(
            icon: Icons.camera_alt_outlined,
            label: "Take a Photo",
            onTap: () => _pickImage(ImageSource.camera),
          ),
        ],
      );
    }
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(12),
      elevation: 5,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 250,
          height: 130,
          decoration: BoxDecoration(
            color: AppColors().cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: AppColors.primaryColor),
              const SizedBox(height: 12),
              Text(
                label,
                style: CustomTextStyle.size16Weight500Text(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(XFile image) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(12),
          elevation: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(image.path),
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => setState(() => _image = null),
          child: Text(
            "Change Photo",
            style: CustomTextStyle.size16Weight500Text(
              AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkImagePreview(String url) {
    return Column(
      children: [
        Material(
          borderRadius: BorderRadius.circular(12),
          elevation: 5,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              url,
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 200,
                height: 200,
                color: Colors.grey[200],
                child: const Icon(Icons.error, color: Colors.red),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => setState(() => _imageUrl = null),
          child: Text(
            "Change Photo",
            style: CustomTextStyle.size16Weight500Text(
              AppColors.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}