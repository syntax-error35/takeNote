import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({required WidgetBuilder builder, RouteSettings? settings})
      : super(
          builder: builder,
          settings: settings,
        );
  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration {
    return const Duration(seconds: 2);
  }
  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (settings.name == '/') {
      return child;
    }
    // TODO: implement buildTransitions
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
