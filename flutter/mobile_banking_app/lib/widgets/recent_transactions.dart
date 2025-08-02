import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E5BBA),
              ),
            ),
            TextButton(
              onPressed: () {
                print('View All Transactions clicked!');
              },
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Color(0xFF2E5BBA),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTransactionItem(
                icon: Icons.shopping_cart,
                title: 'Amazon Purchase',
                subtitle: 'Online Shopping',
                amount: '-\$89.99',
                color: Colors.red,
                date: 'Today',
              ),
              const Divider(height: 1),
              _buildTransactionItem(
                icon: Icons.attach_money,
                title: 'Salary Deposit',
                subtitle: 'Monthly Salary',
                amount: '+\$3,500.00',
                color: Colors.green,
                date: 'Yesterday',
              ),
              const Divider(height: 1),
              _buildTransactionItem(
                icon: Icons.local_gas_station,
                title: 'Shell Gas Station',
                subtitle: 'Fuel Purchase',
                amount: '-\$45.30',
                color: Colors.red,
                date: '2 days ago',
              ),
              const Divider(height: 1),
              _buildTransactionItem(
                icon: Icons.restaurant,
                title: 'McDonald\'s',
                subtitle: 'Food & Dining',
                amount: '-\$12.50',
                color: Colors.red,
                date: '3 days ago',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required Color color,
    required String date,
  }) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
            ),
          ),
        ],
      ),
      trailing: Text(
        amount,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      onTap: () {
        print('Transaction $title clicked!');
      },
    );
  }
}
