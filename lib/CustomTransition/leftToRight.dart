import 'package:flutter/material.dart';

class LeftToRight<T> extends PageRouteBuilder<T> {
  LeftToRight({required RoutePageBuilder pageBuilder})
      : super(pageBuilder: pageBuilder);
  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration {
    return const Duration(seconds: 2);
  }

  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    // TODO: implement buildTransitions
    const begin = Offset(-1.0, 0.0);
    const end = Offset.zero;
    const curve = Curves.easeInOutBack;
    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );}
}
