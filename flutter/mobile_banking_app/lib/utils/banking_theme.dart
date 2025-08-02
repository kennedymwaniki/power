import 'package:flutter/material.dart';

// Enhanced Theme Configuration
class BankingTheme {
  static const Color primaryColor = Color(0xFF2E5BBA);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color accentColor = Color(0xFF4A90E2);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color successColor = Color(0xFF27AE60);
  static const Color warningColor = Color(0xFFF39C12);
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color onSurfaceColor = Color(0xFF2C3E50);
  
  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF2E5BBA),
    Color(0xFF4A90E2),
  ];
  
  static const List<Color> successGradient = [
    Color(0xFF27AE60),
    Color(0xFF2ECC71),
  ];
  
  static const List<Color> warningGradient = [
    Color(0xFFE67E22),
    Color(0xFFF39C12),
  ];
  
  static const List<Color> cardGradients = [
    [Color(0xFF667eea), Color(0xFF764ba2)],
    [Color(0xFF4ECDC4), Color(0xFF44A08D)],
    [Color(0xFFFF6B6B), Color(0xFFEE5A24)],
    [Color(0xFF45B7D1), Color(0xFF2980B9)],
    [Color(0xFF96CEB4), Color(0xFF27AE60)],
  ];
  
  // Shadow configurations
  static BoxShadow get cardShadow => BoxShadow(
    color: Colors.black.withOpacity(0.08),
    blurRadius: 12,
    offset: const Offset(0, 4),
  );
  
  static BoxShadow get elevatedShadow => BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );
  
  // Border Radius configurations
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(12));
  
  // Spacing constants
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 40.0;
  
  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 400);
  static const Duration slowAnimation = Duration(milliseconds: 800);
  static const Duration pageTransitionDuration = Duration(milliseconds: 600);
  
  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: onSurfaceColor,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryColor,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: onSurfaceColor,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: onSurfaceColor,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: Colors.grey,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  
  static const TextStyle captionText = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );
}

// Enhanced Input Decoration
class BankingInputDecoration {
  static InputDecoration standard({
    required String label,
    required String hint,
    required IconData icon,
    String? errorText,
    bool hasError = false,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: hasError ? BankingTheme.errorColor : BankingTheme.primaryColor,
      ),
      border: OutlineInputBorder(
        borderRadius: BankingTheme.inputRadius,
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BankingTheme.inputRadius,
        borderSide: const BorderSide(
          color: BankingTheme.errorColor,
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BankingTheme.inputRadius,
        borderSide: const BorderSide(
          color: BankingTheme.errorColor,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BankingTheme.inputRadius,
        borderSide: const BorderSide(
          color: BankingTheme.primaryColor,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: BankingTheme.surfaceColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      errorText: errorText,
      errorMaxLines: 2,
      errorStyle: const TextStyle(
        color: BankingTheme.errorColor,
        fontSize: 12,
      ),
    );
  }
}

// Enhanced Button Styles
class BankingButtonStyles {
  static ButtonStyle primary = ElevatedButton.styleFrom(
    backgroundColor: BankingTheme.primaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: BankingTheme.spacingL,
      vertical: BankingTheme.spacingM,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BankingTheme.buttonRadius,
    ),
    elevation: 4,
    shadowColor: BankingTheme.primaryColor.withOpacity(0.3),
  );
  
  static ButtonStyle secondary = ElevatedButton.styleFrom(
    backgroundColor: BankingTheme.secondaryColor,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(
      horizontal: BankingTheme.spacingL,
      vertical: BankingTheme.spacingM,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BankingTheme.buttonRadius,
    ),
    elevation: 4,
    shadowColor: BankingTheme.secondaryColor.withOpacity(0.3),
  );
  
  static ButtonStyle outlined = OutlinedButton.styleFrom(
    foregroundColor: BankingTheme.primaryColor,
    side: const BorderSide(
      color: BankingTheme.primaryColor,
      width: 2,
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: BankingTheme.spacingL,
      vertical: BankingTheme.spacingM,
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BankingTheme.buttonRadius,
    ),
  );
  
  static ButtonStyle text = TextButton.styleFrom(
    foregroundColor: BankingTheme.primaryColor,
    padding: const EdgeInsets.symmetric(
      horizontal: BankingTheme.spacingM,
      vertical: BankingTheme.spacingS,
    ),
  );
}

// Animation Curves
class BankingAnimations {
  static const Curve defaultCurve = Curves.easeInOutCubic;
  static const Curve bounceIn = Curves.elasticOut;
  static const Curve slideIn = Curves.easeOutCubic;
  static const Curve fadeIn = Curves.easeInOut;
  static const Curve scaleIn = Curves.elasticOut;
}
