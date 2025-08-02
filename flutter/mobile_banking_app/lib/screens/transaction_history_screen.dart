import 'package:flutter/material.dart';
import '../utils/banking_theme.dart';
import '../widgets/enhanced_widgets.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _filterAnimationController;
  late AnimationController _listAnimationController;
  late Animation<double> _filterSlideAnimation;
  late Animation<double> _filterFadeAnimation;

  bool _showFilters = false;
  String _selectedFilter = 'All';
  String _selectedTimeframe = 'Last 30 days';
  String _sortBy = 'Date (Newest)';
  
  final List<String> _filterOptions = ['All', 'Income', 'Expenses', 'Transfers'];
  final List<String> _timeframeOptions = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'Last year',
    'Custom range'
  ];
  final List<String> _sortOptions = [
    'Date (Newest)',
    'Date (Oldest)',
    'Amount (High to Low)',
    'Amount (Low to High)',
    'Category'
  ];

  // Sample transaction data
  final List<Transaction> _allTransactions = [
    Transaction(
      id: '1',
      title: 'Salary Deposit',
      subtitle: 'Monthly Salary - ABC Corp',
      amount: 3500.00,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: 'Income',
      type: TransactionType.credit,
      icon: Icons.attach_money,
      color: BankingTheme.successColor,
    ),
    Transaction(
      id: '2',
      title: 'Grocery Shopping',
      subtitle: 'Whole Foods Market',
      amount: -127.45,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: 'Food & Dining',
      type: TransactionType.debit,
      icon: Icons.shopping_cart,
      color: BankingTheme.errorColor,
    ),
    Transaction(
      id: '3',
      title: 'Electric Bill',
      subtitle: 'ConEd Energy Bill',
      amount: -89.32,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: 'Utilities',
      type: TransactionType.debit,
      icon: Icons.flash_on,
      color: BankingTheme.warningColor,
    ),
    Transaction(
      id: '4',
      title: 'Transfer to Savings',
      subtitle: 'Monthly Savings Goal',
      amount: -500.00,
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: 'Transfer',
      type: TransactionType.transfer,
      icon: Icons.savings,
      color: BankingTheme.primaryColor,
    ),
    Transaction(
      id: '5',
      title: 'Amazon Purchase',
      subtitle: 'Electronics & Accessories',
      amount: -234.99,
      date: DateTime.now().subtract(const Duration(days: 7)),
      category: 'Shopping',
      type: TransactionType.debit,
      icon: Icons.shopping_bag,
      color: BankingTheme.errorColor,
    ),
    Transaction(
      id: '6',
      title: 'Freelance Payment',
      subtitle: 'Web Development Project',
      amount: 1200.00,
      date: DateTime.now().subtract(const Duration(days: 10)),
      category: 'Income',
      type: TransactionType.credit,
      icon: Icons.work,
      color: BankingTheme.successColor,
    ),
    Transaction(
      id: '7',
      title: 'Gas Station',
      subtitle: 'Shell - Highway 101',
      amount: -45.67,
      date: DateTime.now().subtract(const Duration(days: 12)),
      category: 'Transportation',
      type: TransactionType.debit,
      icon: Icons.local_gas_station,
      color: BankingTheme.errorColor,
    ),
    Transaction(
      id: '8',
      title: 'Restaurant',
      subtitle: 'Italian Bistro Downtown',
      amount: -78.90,
      date: DateTime.now().subtract(const Duration(days: 14)),
      category: 'Food & Dining',
      type: TransactionType.debit,
      icon: Icons.restaurant,
      color: BankingTheme.errorColor,
    ),
  ];

  List<Transaction> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _filteredTransactions = List.from(_allTransactions);
  }

  void _setupAnimations() {
    _filterAnimationController = AnimationController(
      duration: BankingTheme.normalAnimation,
      vsync: this,
    );

    _listAnimationController = AnimationController(
      duration: BankingTheme.slowAnimation,
      vsync: this,
    );

    _filterSlideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _filterFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    ));

    _listAnimationController.forward();
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });

    if (_showFilters) {
      _filterAnimationController.forward();
    } else {
      _filterAnimationController.reverse();
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredTransactions = _allTransactions.where((transaction) {
        // Apply category filter
        if (_selectedFilter != 'All') {
          if (_selectedFilter == 'Income' && transaction.type != TransactionType.credit) {
            return false;
          }
          if (_selectedFilter == 'Expenses' && transaction.type != TransactionType.debit) {
            return false;
          }
          if (_selectedFilter == 'Transfers' && transaction.type != TransactionType.transfer) {
            return false;
          }
        }

        // Apply timeframe filter
        DateTime now = DateTime.now();
        switch (_selectedTimeframe) {
          case 'Last 7 days':
            return transaction.date.isAfter(now.subtract(const Duration(days: 7)));
          case 'Last 30 days':
            return transaction.date.isAfter(now.subtract(const Duration(days: 30)));
          case 'Last 3 months':
            return transaction.date.isAfter(now.subtract(const Duration(days: 90)));
          case 'Last 6 months':
            return transaction.date.isAfter(now.subtract(const Duration(days: 180)));
          case 'Last year':
            return transaction.date.isAfter(now.subtract(const Duration(days: 365)));
          default:
            return true;
        }
      }).toList();

      // Apply sorting
      switch (_sortBy) {
        case 'Date (Newest)':
          _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
          break;
        case 'Date (Oldest)':
          _filteredTransactions.sort((a, b) => a.date.compareTo(b.date));
          break;
        case 'Amount (High to Low)':
          _filteredTransactions.sort((a, b) => b.amount.abs().compareTo(a.amount.abs()));
          break;
        case 'Amount (Low to High)':
          _filteredTransactions.sort((a, b) => a.amount.abs().compareTo(b.amount.abs()));
          break;
        case 'Category':
          _filteredTransactions.sort((a, b) => a.category.compareTo(b.category));
          break;
      }
    });

    _listAnimationController.reset();
    _listAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BankingTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Transaction History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: BankingTheme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: _toggleFilters,
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              print('Search transactions');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Section
          if (_showFilters)
            SlideTransition(
              position: _filterSlideAnimation,
              child: FadeTransition(
                opacity: _filterFadeAnimation,
                child: _buildFilterSection(),
              ),
            ),

          // Summary Section
          _buildSummarySection(),

          // Transaction List
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filters', style: BankingTheme.headingSmall),
          const SizedBox(height: 16),

          // Category Filter
          Text('Category', style: BankingTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _filterOptions.map((filter) {
              return FilterChip(
                label: Text(filter),
                selected: _selectedFilter == filter,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  _applyFilters();
                },
                selectedColor: BankingTheme.primaryColor.withOpacity(0.2),
                checkmarkColor: BankingTheme.primaryColor,
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Timeframe Filter
          Text('Timeframe', style: BankingTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedTimeframe,
            items: _timeframeOptions.map((timeframe) {
              return DropdownMenuItem(
                value: timeframe,
                child: Text(timeframe),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedTimeframe = value!;
              });
              _applyFilters();
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BankingTheme.inputRadius,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),

          const SizedBox(height: 16),

          // Sort Filter
          Text('Sort By', style: BankingTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _sortBy,
            items: _sortOptions.map((sort) {
              return DropdownMenuItem(
                value: sort,
                child: Text(sort),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _sortBy = value!;
              });
              _applyFilters();
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BankingTheme.inputRadius,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),

          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    double totalIncome = _filteredTransactions
        .where((t) => t.type == TransactionType.credit)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    double totalExpenses = _filteredTransactions
        .where((t) => t.type == TransactionType.debit)
        .fold(0.0, (sum, t) => sum + t.amount.abs());

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Income',
              '\$${totalIncome.toStringAsFixed(2)}',
              BankingTheme.successColor,
              Icons.trending_up,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSummaryCard(
              'Total Expenses',
              '\$${totalExpenses.toStringAsFixed(2)}',
              BankingTheme.errorColor,
              Icons.trending_down,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, Color color, IconData icon) {
    return EnhancedCardWidget(
      gradient: [color.withOpacity(0.1), color.withOpacity(0.05)],
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: BankingTheme.bodySmall,
                ),
                Text(
                  amount,
                  style: BankingTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    if (_filteredTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions found',
              style: BankingTheme.headingMedium.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: BankingTheme.bodyMedium.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _listAnimationController,
      builder: (context, child) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _filteredTransactions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final transaction = _filteredTransactions[index];
            final delay = index * 0.1;
            
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _listAnimationController,
                curve: Interval(
                  delay.clamp(0.0, 1.0),
                  (delay + 0.3).clamp(0.0, 1.0),
                  curve: Curves.easeOutCubic,
                ),
              )),
              child: FadeTransition(
                opacity: Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(CurvedAnimation(
                  parent: _listAnimationController,
                  curve: Interval(
                    delay.clamp(0.0, 1.0),
                    (delay + 0.3).clamp(0.0, 1.0),
                    curve: Curves.easeIn,
                  ),
                )),
                child: _buildTransactionItem(transaction),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    return EnhancedCardWidget(
      onTap: () {
        _showTransactionDetails(transaction);
      },
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: BankingTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.subtitle,
                  style: BankingTheme.bodyMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: transaction.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        transaction.category,
                        style: BankingTheme.captionText.copyWith(
                          color: transaction.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(transaction.date),
                      style: BankingTheme.captionText,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.amount > 0 ? '+' : ''}\$${transaction.amount.abs().toStringAsFixed(2)}',
                style: BankingTheme.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: transaction.color,
                ),
              ),
              Icon(
                transaction.type == TransactionType.credit
                    ? Icons.arrow_upward
                    : transaction.type == TransactionType.debit
                        ? Icons.arrow_downward
                        : Icons.swap_horiz,
                color: transaction.color,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Transaction header
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: transaction.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      transaction.icon,
                      color: transaction.color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.title,
                          style: BankingTheme.headingMedium,
                        ),
                        Text(
                          transaction.subtitle,
                          style: BankingTheme.bodyMedium.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Amount
              Center(
                child: Text(
                  '${transaction.amount > 0 ? '+' : ''}\$${transaction.amount.abs().toStringAsFixed(2)}',
                  style: BankingTheme.headingLarge.copyWith(
                    color: transaction.color,
                    fontSize: 36,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Details
              _buildDetailRow('Transaction ID', transaction.id),
              _buildDetailRow('Date', _formatDate(transaction.date)),
              _buildDetailRow('Category', transaction.category),
              _buildDetailRow('Type', transaction.type.name.toUpperCase()),

              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        print('Export transaction ${transaction.id}');
                      },
                      icon: const Icon(Icons.download),
                      label: const Text('Export'),
                      style: BankingButtonStyles.outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        print('Repeat transaction ${transaction.id}');
                      },
                      icon: const Icon(Icons.repeat),
                      label: const Text('Repeat'),
                      style: BankingButtonStyles.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: BankingTheme.bodyMedium.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: BankingTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  @override
  void dispose() {
    _filterAnimationController.dispose();
    _listAnimationController.dispose();
    super.dispose();
  }
}

class Transaction {
  final String id;
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final String category;
  final TransactionType type;
  final IconData icon;
  final Color color;

  Transaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.category,
    required this.type,
    required this.icon,
    required this.color,
  });
}

enum TransactionType {
  credit,
  debit,
  transfer,
}
