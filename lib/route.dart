import 'package:flutter/material.dart';

/// A common navigation helper to avoid repeating Navigator code everywhere
class NavigationHelper {
  // Push a new screen
  static void push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Push with named route
  static void pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  // Replace current screen
  static void pushReplacement(BuildContext context, Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  // Replace with named route
  static void pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  // Pop the current screen
  static void pop(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  // Push and remove all previous screens
  static void pushAndRemoveUntil(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false, //remove all previsous routes
    );
  }

  // // Push and remove all with named route
  // static void pushNamedAndRemoveUntil(
  //   BuildContext context,
  //   String routeName, {
  //   Object? arguments,
  // }) {
  //   Navigator.pushNamedAndRemoveUntil(
  //     context,
  //     routeName,
  //     (route) => false,
  //     arguments: arguments,
  //   );
  // }
}
