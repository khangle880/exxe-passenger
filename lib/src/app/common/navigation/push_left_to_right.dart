import 'package:flutter/material.dart';

class PushRouteLeftToRight extends PageRouteBuilder {
  PushRouteLeftToRight({Key? key, required this.child})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: const Offset(0.0, 0.0),
              ).animate(
                CurvedAnimation(
                    parent: animation, curve: Curves.linearToEaseOut),
              ),
              child: child,
            );
          },
          opaque: false,
        );
  final Widget child;
}
