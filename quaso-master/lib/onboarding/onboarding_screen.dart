import 'package:flutter/material.dart';
import 'package:quaso/navigation/app_state_manager.dart';
import 'package:quaso/navigation/routes.dart';
import 'package:quaso/onboarding/onboarding.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  static MaterialPage page() {
    return MaterialPage(
      name: Routes.onboardingPath,
      key: ValueKey(Routes.onboardingPath),
      child: const OnboardingScreen(),
    );
  }

  const OnboardingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateManager>(
      builder: (
        context,
        appStateManager,
        child,
      ) {
        return Onboarding();
      },
    );
  }
}
