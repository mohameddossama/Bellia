import 'package:flutter/material.dart';
import 'package:fluttercourse/pages/commerceHome.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  void setCache() async {
    SharedPreferences pref;
    pref = await SharedPreferences.getInstance();
    pref.setBool('firstLaunch', false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: pagesList,
        next: const Text("Next"),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
        onDone: () {
          setCache();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => CommerceHome()), 
          );
        },
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Colors.red,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}

List<PageViewModel> pagesList = [
  PageViewModel(
    title: "Title of introduction page",
    body: "Welcome to the app! This is a description of how it works.",
    image: const Center(
      child: Icon(Icons.waving_hand, size: 50.0),
    ),
  ),
  PageViewModel(
    title: "Title of introduction page",
    body: "Welcome to the app! This is a description of how it works.",
    image: const Center(
      child: Icon(Icons.emoji_emotions, size: 50.0),
    ),
  ),
  PageViewModel(
    title: "Title of introduction page",
    body: "Welcome to the app! This is a description of how it works.",
    image: const Center(
      child: Icon(Icons.emoji_events, size: 50.0),
    ),
  ),
  PageViewModel(
    title: "Title of introduction page",
    body: "Welcome to the app! This is a description of how it works.",
    image: const Center(
      child: Icon(Icons.baby_changing_station, size: 50.0),
    ),
  ),
  PageViewModel(
    title: "Title of introduction page",
    body: "Welcome to the app! This is a description of how it works.",
    image: const Center(
      child: Icon(Icons.accessibility_rounded, size: 50.0),
    ),
  ),
];
