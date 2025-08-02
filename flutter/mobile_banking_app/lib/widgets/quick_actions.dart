import 'package:flutter/material.dart';
import '../screens/send_money_screen.dart';
import '../utils/page_transitions.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  void _onActionPressed(BuildContext context, String action) {
    print('Quick Action: $action clicked!');
    
    if (action == 'Transfer') {
      // Navigate to Send Money screen with custom transition
      context.pushWithCustomTransition(
        const SendMoneyScreen(),
        transitionType: TransitionType.bankingSpecial,
        duration: const Duration(milliseconds: 800),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2E5BBA),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: Icons.send,
              label: 'Transfer',
              color: const Color(0xFF4CAF50),
              onTap: () => _onActionPressed(context, 'Transfer'),
            ),
            _buildActionButton(
              icon: Icons.payment,
              label: 'Pay Bills',
              color: const Color(0xFFFF9800),
              onTap: () => _onActionPressed(context, 'Pay Bills'),
            ),
            _buildActionButton(
              icon: Icons.add_circle,
              label: 'Deposit',
              color: const Color(0xFF2196F3),
              onTap: () => _onActionPressed(context, 'Deposit'),
            ),
            _buildActionButton(
              icon: Icons.more_horiz,
              label: 'More',
              color: const Color(0xFF9C27B0),
              onTap: () => _onActionPressed(context, 'More'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
