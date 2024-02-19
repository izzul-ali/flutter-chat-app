import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_chat_app/core/constant/color.dart';
import 'package:google_fonts/google_fonts.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final int pageCount = 3;
  late PageController _pageController;
  bool _isLastPage = false;

  @override
  void initState() {
    _pageController = PageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          !_isLastPage
              ? InkWell(
                  onTap: () {
                    context.go('/signup');
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Row(
                      children: [
                        Text('Skip'),
                        SizedBox(width: 3),
                        Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
      body: Column(
        children: [
          const Spacer(),
          Expanded(
            flex: 5,
            child: PageView.builder(
              itemCount: pageCount,
              controller: _pageController,
              onPageChanged: (page) {
                if (page + 1 == pageCount) {
                  _isLastPage = true;
                } else {
                  _isLastPage = false;
                }
                setState(() {});
              },
              itemBuilder: (context, index) {
                return _pageItemList()[index];
              },
            ),
          ),
          SmoothPageIndicator(
            controller: _pageController,
            effect: const ExpandingDotsEffect(
              activeDotColor: kPrimaryColor,
              dotHeight: 10,
            ),
            count: pageCount,
            onDotClicked: (page) {
              _pageController.animateToPage(
                page,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            },
          ),
          const SizedBox(height: 50),
          ElevatedButton(
            onPressed: () {
              if (_isLastPage) {
                context.go('/signup');
              } else {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              padding: const EdgeInsets.symmetric(vertical: 20),
              fixedSize: Size.fromWidth(MediaQuery.sizeOf(context).width - 40),
            ),
            child: Text(
              _isLastPage ? "Get Started" : 'Next',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  List<Widget> _pageItemList() => [
        _pageItem(
          imagePath: 'assets/images/onboarding-1.png',
          title: 'Create your Profile',
          description:
              'Complete your profile to help you find a roommate who will be right for you.',
        ),
        _pageItem(
          imagePath: 'assets/images/onboarding-2.png',
          title: 'Search Roomates',
          description: 'Choose to live with people who match your preferences',
        ),
        _pageItem(
          imagePath: 'assets/images/onboarding-3.png',
          title: 'Know Before You Meet',
          description:
              'Talk to your Roommate, know each other and make decision together',
        ),
      ];

  Widget _pageItem({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Image.asset(imagePath),
          const SizedBox(height: 50),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: kOnBoardingTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
