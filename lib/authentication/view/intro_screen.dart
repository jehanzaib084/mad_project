import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mad_project/assets.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  Future<void> _onIntroEnd() async {
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage(Assets.backgroundImage),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: SafeArea(
          child: IntroductionScreen(
            pages: [
              PageViewModel(
                title: "Welcome to LeaserHub",
                body: "Find your perfect hostel rooms with ease.",
                image: Center(
                  child: Image.asset(
                    Assets.introHomeImage,
                    height: 250.0,
                    fit: BoxFit.contain,
                  ),
                ),
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Assets.primaryColor,
                  ),
                  bodyTextStyle: TextStyle(
                    fontSize: 16.0,
                    color: Assets.lightTextColor,
                  ),
                  imagePadding: EdgeInsets.only(top: 30),
                  titlePadding: EdgeInsets.only(top: 20),
                  bodyPadding: EdgeInsets.only(top: 10),
                  pageColor: Colors.transparent,
                ),
              ),
              PageViewModel(
                title: "Easy Search",
                body: "Filter and find properties that match your needs.",
                image: Center(
                  child: Image.asset(
                    Assets.introSearchImage,
                    height: 250.0,
                    fit: BoxFit.contain,
                  ),
                ),
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Assets.primaryColor,
                  ),
                  bodyTextStyle: TextStyle(
                    fontSize: 16.0,
                    color: Assets.lightTextColor,
                  ),
                  imagePadding: EdgeInsets.only(top: 30),
                  titlePadding: EdgeInsets.only(top: 20),
                  bodyPadding: EdgeInsets.only(top: 10),
                  pageColor: Colors.transparent,
                ),
              ),
              PageViewModel(
                title: "Connect & Rent",
                body: "Contact property owners directly and find your new home.",
                image: Center(
                  child: Image.asset(
                    Assets.introConnectImage,
                    height: 250.0,
                    fit: BoxFit.contain,
                  ),
                ),
                decoration: const PageDecoration(
                  titleTextStyle: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    color: Assets.primaryColor,
                  ),
                  bodyTextStyle: TextStyle(
                    fontSize: 16.0,
                    color: Assets.lightTextColor,
                  ),
                  imagePadding: EdgeInsets.only(top: 30),
                  titlePadding: EdgeInsets.only(top: 20),
                  bodyPadding: EdgeInsets.only(top: 10),
                  pageColor: Colors.transparent,
                ),
              ),
            ],
            onDone: _onIntroEnd,
            onSkip: _onIntroEnd,
            showSkipButton: true,
            skip: const Text(
              "Skip",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Assets.btnBgColor,
              ),
            ),
            next: const Icon(
              Icons.arrow_forward,
              color: Assets.btnBgColor,
            ),
            done: const Text(
              "Done",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Assets.btnBgColor,
              ),
            ),
            dotsDecorator: DotsDecorator(
              size: const Size.square(10.0),
              activeSize: const Size(20.0, 10.0),
              activeColor: Assets.btnBgColor,
              color: Colors.black26,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
