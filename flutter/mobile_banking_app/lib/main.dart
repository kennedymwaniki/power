import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/send_money_screen.dart';
import 'screens/profile_management_screen.dart';
import 'screens/transaction_history_screen.dart';
import 'utils/page_transitions.dart';
import 'utils/banking_theme.dart';

void main() {
  runApp(const MobileBankingApp());
}

class MobileBankingApp extends StatelessWidget {
  const MobileBankingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureBank Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: BankingTheme.primaryColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: BankingTheme.primaryColor,
          primary: BankingTheme.primaryColor,
          secondary: BankingTheme.secondaryColor,
          error: BankingTheme.errorColor,
          surface: BankingTheme.surfaceColor,
          background: BankingTheme.backgroundColor,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        
        // Enhanced Button Themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: BankingButtonStyles.primary,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: BankingButtonStyles.outlined,
        ),
        textButtonTheme: TextButtonThemeData(
          style: BankingButtonStyles.text,
        ),
        
        // Enhanced Input Theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: BankingTheme.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BankingTheme.inputRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BankingTheme.inputRadius,
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BankingTheme.inputRadius,
            borderSide: const BorderSide(color: BankingTheme.primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BankingTheme.inputRadius,
            borderSide: const BorderSide(color: BankingTheme.errorColor, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        
        // Card Theme
        cardTheme: CardTheme(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BankingTheme.cardRadius,
          ),
          shadowColor: Colors.black.withOpacity(0.1),
        ),
        
        // App Bar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: BankingTheme.primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        
        // Tab Bar Theme
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        
        // SnackBar Theme
        snackBarTheme: SnackBarThemeData(
          backgroundColor: BankingTheme.primaryColor,
          contentTextStyle: const TextStyle(color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BankingTheme.buttonRadius,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/send-money': (context) => const SendMoneyScreen(),
        '/profile': (context) => const ProfileManagementScreen(),
        '/transactions': (context) => const TransactionHistoryScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return CustomPageTransition(
              child: const LoginScreen(),
              transitionType: TransitionType.fadeIn,
              duration: BankingTheme.pageTransitionDuration,
            );
          case '/home':
            return CustomPageTransition(
              child: const HomeScreen(),
              transitionType: TransitionType.bankingSpecial,
              duration: const Duration(milliseconds: 1000),
            );
          case '/send-money':
            return CustomPageTransition(
              child: const SendMoneyScreen(),
              transitionType: TransitionType.slideFromRight,
              duration: BankingTheme.pageTransitionDuration,
            );
          case '/profile':
            return CustomPageTransition(
              child: const ProfileManagementScreen(),
              transitionType: TransitionType.slideFromBottom,
              duration: BankingTheme.pageTransitionDuration,
            );
          case '/transactions':
            return CustomPageTransition(
              child: const TransactionHistoryScreen(),
              transitionType: TransitionType.slideFromRight,
              duration: BankingTheme.pageTransitionDuration,
            );
          default:
            return MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            );
        }
      },
    );
  }
}
