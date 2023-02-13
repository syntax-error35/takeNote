import 'package:flutter/material.dart';

class InOut<T> extends PageRouteBuilder<T> {
  InOut({required RoutePageBuilder pageBuilder})
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
    // const begin = Offset(0.0, 1.0);
    // const end = Offset.zero;
    // const curve = Curves.easeInOutBack;
    // var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return ScaleTransition(
      scale: Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(
            0.00,
            0.50,
            curve: Curves.linear,
          ),
        ),
      ),
      child: ScaleTransition(
        scale: Tween<double>(
          begin: 1.5,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: const Interval(
              0.50,
              1.00,
              curve: Curves.linear,
            ),
          ),
        ),
        child: child,
      ),
    );
  }
}
