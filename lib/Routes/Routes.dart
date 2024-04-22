import 'package:bible_quiz_answer/Screen/Category_screen/category_screen.dart';
import 'package:bible_quiz_answer/Screen/History_screen/history_screen.dart';
import 'package:bible_quiz_answer/Screen/Home_screen/home_screen.dart';
import 'package:bible_quiz_answer/Screen/Quiz_screen/quiz_screen.dart';
import 'package:bible_quiz_answer/Screen/Setting_screen/setting_screen.dart';
import 'package:bible_quiz_answer/Screen/Splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

class Router {
  static MaterialPageRoute onRouteGenrator(settings) {
    switch (settings.name) {
      case splash_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const splash_screen(),
        );
      case home_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const home_screen(),
        );
      case quiz_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => quiz_screen(
            oneData: settings.arguments['oneCategory'],
            oneCategoryName: settings.arguments['oneCategoryName'],
            CategoryName: settings.arguments['CategoryName'],
          ),
        );
      case category_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => category_screen(
            data: settings.arguments['data'],
            Testament: settings.arguments['Testament'],
          ),
        );
      case history_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => history_screen(),
        );
      case setting_screen.routeName:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => setting_screen(),
        );
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Material(
            child: Center(
              child: Text("404 page not founded"),
            ),
          ),
        );
    }
  }
}
