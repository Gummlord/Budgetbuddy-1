import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../config/app_routes.dart';
import '../../../config/theme.dart';
import '../../../config/constants.dart';
import '../../../providers/auth_provider.dart';
import '../widgets/auth_layout.dart';
import 'login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final c = context.colors;

    if (auth.isInitializing) {
      return Scaffold(
        backgroundColor: c.background,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AuthLogo(),
              const SizedBox(height: kDefaultPadding),
              Text(
                kAppName,
                style: AppTextStyles.header.copyWith(color: c.textPrimary),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }

    if (auth.isLoggedIn) {
      return AppRoutes.routes[AppRoutes.home]!(context);
    }

    return const LoginScreen();
  }
}
