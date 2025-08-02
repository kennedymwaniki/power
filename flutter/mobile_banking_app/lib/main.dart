import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/send_money_screen.dart';
import 'utils/page_transitions.dart';

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
        primaryColor: const Color(0xFF2E5BBA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E5BBA),
          primary: const Color(0xFF2E5BBA),
          secondary: const Color(0xFF4CAF50),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/send-money': (context) => const SendMoneyScreen(),
      },
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return CustomPageTransition(
              child: const LoginScreen(),
              transitionType: TransitionType.fadeIn,
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
