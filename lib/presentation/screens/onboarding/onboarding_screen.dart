import 'package:easy_localization/easy_localization.dart';
import 'package:finance_coach/core/constants/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../common_widgets/app_button.dart';
import '../../../app/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'onboarding.track_finances'.tr(),
      description: 'onboarding.track_finances_desc'.tr(),
      image: AppSvgImages.onboardingIllustration,
    ),
    OnboardingPage(
      title: 'onboarding.set_budgets'.tr(),
      description: 'onboarding.set_budgets_desc'.tr(),
      image: AppSvgImages.onboardingIllustration,
    ),
    OnboardingPage(
      title: 'onboarding.achieve_goals'.tr(),
      description: 'onboarding.achieve_goals_desc'.tr(),
      image: AppSvgImages.onboardingIllustration,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed:
                    () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.login,
                    ),
                child: Text('onboarding.skip'.tr()),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(_pages[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Page indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_pages.length, (index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: _currentPage == index ? 24.0 : 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color:
                              _currentPage == index
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32.0),
                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: _onNextPage,
                      text:
                          _currentPage == _pages.length - 1
                              ? 'onboarding.get_started'.tr()
                              : 'onboarding.next'.tr(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(page.image, height: 240.0, fit: BoxFit.contain),
          const SizedBox(height: 40.0),
          Text(
            page.title,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Text(
            page.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String image;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
  });
}
