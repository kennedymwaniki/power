import 'package:flutter/material.dart';
import '../utils/banking_theme.dart';

class EnhancedCardWidget extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final List<Color>? gradient;
  final double? width;
  final double? height;
  final bool enableHover;
  final bool enablePress;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double elevation;
  final BorderRadius? borderRadius;

  const EnhancedCardWidget({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.gradient,
    this.width,
    this.height,
    this.enableHover = true,
    this.enablePress = true,
    this.onTap,
    this.onLongPress,
    this.elevation = 4.0,
    this.borderRadius,
  });

  @override
  State<EnhancedCardWidget> createState() => _EnhancedCardWidgetState();
}

class _EnhancedCardWidgetState extends State<EnhancedCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late Animation<double> _hoverAnimation;
  late Animation<double> _pressAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _hoverController = AnimationController(
      duration: BankingTheme.fastAnimation,
      vsync: this,
    );

    _pressController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _hoverAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));

    _pressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _pressController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.elevation + 4,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  void _onEnter() {
    if (widget.enableHover) {
      setState(() => _isHovered = true);
      _hoverController.forward();
    }
  }

  void _onExit() {
    if (widget.enableHover) {
      setState(() => _isHovered = false);
      _hoverController.reverse();
    }
  }

  void _onTapDown() {
    if (widget.enablePress) {
      setState(() => _isPressed = true);
      _pressController.forward();
    }
  }

  void _onTapUp() {
    if (widget.enablePress) {
      setState(() => _isPressed = false);
      _pressController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_hoverController, _pressController]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pressAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onEnter(),
            onExit: (_) => _onExit(),
            child: GestureDetector(
              onTapDown: (_) => _onTapDown(),
              onTapUp: (_) => _onTapUp(),
              onTapCancel: () => _onTapUp(),
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              child: Container(
                width: widget.width,
                height: widget.height,
                margin: widget.margin ?? const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: widget.gradient != null
                      ? LinearGradient(
                          colors: widget.gradient!,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: widget.gradient == null 
                      ? (widget.backgroundColor ?? BankingTheme.surfaceColor)
                      : null,
                  borderRadius: widget.borderRadius ?? BankingTheme.cardRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                  ],
                ),
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.all(16),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    super.dispose();
  }
}

// Enhanced Progress Indicator
class EnhancedProgressIndicator extends StatefulWidget {
  final double value;
  final Color? backgroundColor;
  final Color? valueColor;
  final List<Color>? gradient;
  final double height;
  final String? label;
  final String? percentageText;
  final bool showPercentage;
  final Duration animationDuration;

  const EnhancedProgressIndicator({
    super.key,
    required this.value,
    this.backgroundColor,
    this.valueColor,
    this.gradient,
    this.height = 8.0,
    this.label,
    this.percentageText,
    this.showPercentage = true,
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  State<EnhancedProgressIndicator> createState() => _EnhancedProgressIndicatorState();
}

class _EnhancedProgressIndicatorState extends State<EnhancedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
  }

  void _setupAnimation() {
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.value,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(EnhancedProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: oldWidget.value,
        end: widget.value,
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null || widget.showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: BankingTheme.bodyMedium,
                  ),
                if (widget.showPercentage)
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Text(
                        widget.percentageText ?? 
                            '${(_animation.value * 100).toInt()}%',
                        style: BankingTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: BankingTheme.primaryColor,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.grey.shade200,
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(widget.height / 2),
                child: LinearProgressIndicator(
                  value: _animation.value,
                  backgroundColor: Colors.transparent,
                  valueColor: widget.gradient != null
                      ? null
                      : AlwaysStoppedAnimation<Color>(
                          widget.valueColor ?? BankingTheme.primaryColor,
                        ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Enhanced Loading Widget
class EnhancedLoadingWidget extends StatefulWidget {
  final String? message;
  final Color? color;
  final double size;
  final LoadingType type;

  const EnhancedLoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size = 50.0,
    this.type = LoadingType.circular,
  });

  @override
  State<EnhancedLoadingWidget> createState() => _EnhancedLoadingWidgetState();
}

class _EnhancedLoadingWidgetState extends State<EnhancedLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLoadingIndicator(),
        if (widget.message != null) ...[
          const SizedBox(height: 16),
          Text(
            widget.message!,
            style: BankingTheme.bodyMedium.copyWith(
              color: widget.color ?? BankingTheme.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    switch (widget.type) {
      case LoadingType.circular:
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              widget.color ?? BankingTheme.primaryColor,
            ),
          ),
        );

      case LoadingType.spinning:
        return AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 2 * 3.14159,
              child: Icon(
                Icons.refresh,
                size: widget.size,
                color: widget.color ?? BankingTheme.primaryColor,
              ),
            );
          },
        );

      case LoadingType.pulsing:
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  color: widget.color ?? BankingTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );

      case LoadingType.dots:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      width: widget.size / 4,
                      height: widget.size / 4,
                      decoration: BoxDecoration(
                        color: widget.color ?? BankingTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        );
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

enum LoadingType {
  circular,
  spinning,
  pulsing,
  dots,
}
