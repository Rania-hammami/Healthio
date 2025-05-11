import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testflutterapp/src/bloc/profile/profile_bloc.dart';
import 'package:testflutterapp/src/bloc/theme/theme_bloc.dart';
import 'package:testflutterapp/src/data/models/user.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';
import 'package:hive/hive.dart';

import '../../../bloc/settings/settings_bloc.dart';

import 'package:hive/hive.dart';

import '../../utils/app_styles.dart';
import '../../widgets/image_placeholder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User _user = User.fromHive();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(
      FetchFavorites(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return PopScope(
          canPop: true,
          onPopInvoked: ((didPop) {
            if (didPop) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          }),
          child: Scaffold(
            body: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.4,
                  flexibleSpace: Stack(
                    children: [
                      FlexibleSpaceBar(
                        background: _user.image != null
                            ? Image.network(
                          _user.image!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              ImagePlaceholder(
                                iconData: Icons.person,
                                iconSize: 100, color: AppColors.white,
                              ),
                        )
                            : ImagePlaceholder(
                          iconData: Icons.person,
                          iconSize: 100, color: AppColors.white,
                        ),
                      ),
                      //Border radius
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors().backgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                            border: Border.all(
                              width: 0,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: AppStyles.largeBorderRadius,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.secondaryColor.withOpacity(0.1),
                                    AppColors.secondaryDarkColor
                                        .withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Text(
                                'Member',
                                style: CustomTextStyle.size14Weight400Text(
                                  AppColors.starColor,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: AppStyles.largeBorderRadius,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.secondaryColor.withOpacity(0.1),
                                    AppColors.secondaryDarkColor
                                        .withOpacity(0.1),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/settings',
                                  );
                                },
                                icon: const Icon(
                                  Icons.settings,
                                  color: AppColors.starColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _user.fullName,
                          style: CustomTextStyle.size27Weight600Text(),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user.email,
                          style: CustomTextStyle.size14Weight400Text(
                            AppColors().secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user.phone,
                          style: CustomTextStyle.size14Weight400Text(
                            AppColors().secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'My Location :',
                          style: CustomTextStyle.size18Weight600Text(),
                        ),
                        const SizedBox(height: 20),
                        // Display selected location here
                        Text(
                          Hive.box('myBox')
                              .get('location', defaultValue: 'Unknown'),
                          style: CustomTextStyle.size16Weight400Text(
                            AppColors().secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}