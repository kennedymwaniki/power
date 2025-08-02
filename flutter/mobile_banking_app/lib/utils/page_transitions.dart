import 'package:flutter/material.dart';

class CustomPageTransition extends PageRouteBuilder {
  final Widget child;
  final TransitionType transitionType;
  final Duration duration;

  CustomPageTransition({
    required this.child,
    this.transitionType = TransitionType.slideFromRight,
    this.duration = const Duration(milliseconds: 600),
  }) : super(
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          pageBuilder: (context, animation, secondaryAnimation) => child,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (transitionType) {
      case TransitionType.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: child,
        );

      case TransitionType.slideFromLeft:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: child,
        );

      case TransitionType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: child,
        );

      case TransitionType.slideFromTop:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, -1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          )),
          child: child,
        );

      case TransitionType.fadeIn:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case TransitionType.scaleIn:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          )),
          child: child,
        );

      case TransitionType.rotateIn:
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.5,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case TransitionType.slideAndFade:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case TransitionType.bankingSpecial:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutQuart,
          )),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
            )),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.8,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.elasticOut,
              )),
              child: child,
            ),
          ),
        );
    }
  }
}

enum TransitionType {
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  slideFromTop,
  fadeIn,
  scaleIn,
  rotateIn,
  slideAndFade,
  bankingSpecial,
}

// Helper extension for easy navigation with custom transitions
extension NavigatorExtension on BuildContext {
  Future<T?> pushWithCustomTransition<T extends Object?>(
    Widget destination, {
    TransitionType transitionType = TransitionType.slideFromRight,
    Duration duration = const Duration(milliseconds: 600),
  }) {
    return Navigator.of(this).push<T>(
      CustomPageTransition(
        child: destination,
        transitionType: transitionType,
        duration: duration,
      ),
    );
  }

  Future<T?> pushReplacementWithCustomTransition<T extends Object?, TO extends Object?>(
    Widget destination, {
    TransitionType transitionType = TransitionType.slideFromRight,
    Duration duration = const Duration(milliseconds: 600),
    TO? result,
  }) {
    return Navigator.of(this).pushReplacement<T, TO>(
      CustomPageTransition(
        child: destination,
        transitionType: transitionType,
        duration: duration,
      ),
      result: result,
    );
  }

  Future<T?> pushNamedWithCustomTransition<T extends Object?>(
    String routeName, {
    TransitionType transitionType = TransitionType.slideFromRight,
    Duration duration = const Duration(milliseconds: 600),
    Object? arguments,
  }) {
    // This would need custom route handling in your main app
    // For now, using the regular push method
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }
}

// Animated Container Helper
class AnimatedContainerHelper {
  static Widget buildAnimatedContainer({
    required Widget child,
    required AnimationController controller,
    double beginScale = 0.8,
    double endScale = 1.0,
    Offset beginOffset = const Offset(0, 0.3),
    Offset endOffset = Offset.zero,
    double beginOpacity = 0.0,
    double endOpacity = 1.0,
    Curve curve = Curves.easeOutCubic,
  }) {
    final Animation<double> scaleAnimation = Tween<double>(
      begin: beginScale,
      end: endScale,
    ).animate(CurvedAnimation(parent: controller, curve: curve));

    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(CurvedAnimation(parent: controller, curve: curve));

    final Animation<double> fadeAnimation = Tween<double>(
      begin: beginOpacity,
      end: endOpacity,
    ).animate(CurvedAnimation(parent: controller, curve: curve));

    return SlideTransition(
      position: slideAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: FadeTransition(
          opacity: fadeAnimation,
          child: child,
        ),
      ),
    );
  }
}

// Staggered Animation Helper for multiple widgets
class StaggeredAnimationHelper {
  static List<Widget> buildStaggeredAnimations({
    required List<Widget> children,
    required AnimationController controller,
    double staggerDelay = 0.1,
    Curve curve = Curves.easeOutCubic,
  }) {
    return children.asMap().entries.map((entry) {
      int index = entry.key;
      Widget child = entry.value;
      
      double start = index * staggerDelay;
      double end = start + 0.5;
      
      if (end > 1.0) end = 1.0;
      if (start > 1.0) start = 1.0;

      final Animation<double> animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: curve),
      ));

      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    }).toList();
  }
}
