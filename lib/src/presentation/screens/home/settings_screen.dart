import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testflutterapp/src/bloc/settings/settings_bloc.dart';
import 'package:testflutterapp/src/bloc/theme/theme_bloc.dart';
import 'package:testflutterapp/src/presentation/utils/app_colors.dart';
import 'package:testflutterapp/src/presentation/utils/custom_text_style.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is LogoutInProgress) {
          showDialog(
            context: context,
            builder: (context) => const Center(child: CircularProgressIndicator()),
          );
        } else if (state is LogoutSuccess) {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            "/register",
                (route) => false,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGreen,
                        AppColors.primaryDarkGreen,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                title: Text(
                  'Settings',
                  style: CustomTextStyle.size22Weight600Text(Colors.white),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSettingTile(
                          icon: Icons.dark_mode,
                          title: 'Dark Mode',
                          trailing: Switch(
                            value: Theme.of(context).brightness == Brightness.dark,
                            onChanged: (value) {
                              Hive.box('myBox').put('isDarkMode', value);
                              BlocProvider.of<ThemeBloc>(context).add(
                                ChangeTheme(
                                  themeData: Theme.of(context).brightness ==
                                      Brightness.dark
                                      ? ThemeData.light()
                                      : ThemeData.dark(),
                                ),
                              );
                            },
                            activeColor: AppColors.primaryGreen,
                          ),
                        ),
                        const Divider(height: 1),
                        _buildSettingTile(
                          icon: Icons.logout,
                          title: 'Log Out',
                          titleColor: AppColors.errorColor,
                          onTap: () => _showLogoutDialog(context),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: AppColors.errorColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? AppColors.primaryGreen),
      title: Text(
        title,
        style: CustomTextStyle.size16Weight500Text(titleColor),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: CustomTextStyle.size16Weight500Text(),
            ),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<SettingsBloc>(context).add(Logout());
            },
            child: Text(
              'Log Out',
              style: CustomTextStyle.size16Weight500Text(AppColors.errorColor),
            ),
          ),
        ],
      ),
    );
  }
}