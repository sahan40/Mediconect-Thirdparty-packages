// lib/core/app_transitions.dart
//
// Reusable page transition utility.
// Import this wherever you need the swap/slide animation.
// Usage: Navigator.of(context).push(AppTransitions.swapRoute(MyScreen()));

import 'package:flutter/material.dart';

class AppTransitions {
  AppTransitions._(); // prevent instantiation

  /// Slide-left swap animation.
  /// • Incoming page slides in from the right.
  /// • Outgoing page slides out to the left + fades.
  /// • Back/pop reverses the same animation automatically.
  static PageRouteBuilder<T> swapRoute<T>(
    Widget page, {
    Duration duration        = const Duration(milliseconds: 420),
    Duration reverseDuration = const Duration(milliseconds: 380),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration:        duration,
      reverseTransitionDuration: reverseDuration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Incoming page slides in from right
        final slideIn = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end:   Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve:  Curves.easeOutCubic,
        ));

        // Outgoing page slides left + fades out
        final slideOut = Tween<Offset>(
          begin: Offset.zero,
          end:   const Offset(-0.0, 0.0),
        ).animate(CurvedAnimation(
          parent: animation,
          curve:  Curves.easeInCubic,
        ));

        final fadeOut = Tween<double>(
          begin: 1.0,
          end:   0.0,
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve:  const Interval(0.0, 0.6, curve: Curves.easeIn),
        ));

        return SlideTransition(
          position: slideOut,
          child: FadeTransition(
            opacity: fadeOut,
            child: SlideTransition(position: slideIn, child: child),
          ),
        );
      },
    );
  }
}