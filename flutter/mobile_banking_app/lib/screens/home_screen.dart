import 'package:flutter/material.dart';
import '../widgets/balance_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/recent_transactions.dart';
import '../widgets/animated_dashboard_widgets.dart';
import '../utils/page_transitions.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _dashboardAnimationController;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _dashboardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Start dashboard animation
    _dashboardAnimationController.forward();
  }

  void _onActionButtonPressed(String action) {
    print('$action Button Clicked!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'SecureBank Mobile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E5BBA),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              print('Notifications Button Clicked!');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.pushReplacementWithCustomTransition(
                const LoginScreen(),
                transitionType: TransitionType.slideFromLeft,
                duration: const Duration(milliseconds: 800),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Message Container
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E5BBA), Color(0xFF4A90E2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back, John!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Manage your finances with ease',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bank Building Image Widget
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=800&h=400&fit=crop',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF2E5BBA),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF2E5BBA),
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_balance,
                                size: 60,
                                color: Colors.white,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'SecureBank Building',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Interactive Demo Button
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    print('Button Clicked! - Home Screen Demo');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Button Clicked! - Home Screen Demo'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  icon: const Icon(Icons.touch_app),
                  label: const Text(
                    'Interactive Demo Button',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Enhanced Dashboard Cards with Animation
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: [
                  AnimatedDashboardCard(
                    title: 'Monthly Spending',
                    value: '\$2,847.50',
                    icon: Icons.trending_down,
                    backgroundColor: const Color(0xFFFF6B6B),
                    animationDelay: 100,
                    onTap: () => print('Monthly Spending Card Tapped!'),
                  ),
                  AnimatedDashboardCard(
                    title: 'Savings Goal',
                    value: '\$8,234.10',
                    icon: Icons.savings,
                    backgroundColor: const Color(0xFF4ECDC4),
                    animationDelay: 200,
                    onTap: () => print('Savings Goal Card Tapped!'),
                  ),
                  AnimatedDashboardCard(
                    title: 'Investments',
                    value: '\$15,678.20',
                    icon: Icons.show_chart,
                    backgroundColor: const Color(0xFF45B7D1),
                    animationDelay: 300,
                    onTap: () => print('Investments Card Tapped!'),
                  ),
                  AnimatedDashboardCard(
                    title: 'Credit Score',
                    value: '785',
                    icon: Icons.credit_score,
                    backgroundColor: const Color(0xFF96CEB4),
                    animationDelay: 400,
                    onTap: () => print('Credit Score Card Tapped!'),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              
              // Balance Card
              const BalanceCard(),

              const SizedBox(height: 24),              // Quick Actions
              const QuickActions(),
              
              const SizedBox(height: 24),
              
              // Recent Transactions
              const RecentTransactions(),
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF2E5BBA),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Accounts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Transfer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          print('Bottom nav item $index clicked!');
        },
      ),
    );
  }

  @override
  void dispose() {
    _dashboardAnimationController.dispose();
    super.dispose();
  }
}
