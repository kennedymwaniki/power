import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/custom_send_money_button.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen>
    with TickerProviderStateMixin {
  final TextEditingController _recipientController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedPaymentMethod = 'Bank Transfer';
  bool _isFavorite = false;
  bool _showSuccessMessage = false;
  bool _isProcessing = false;
  
  late AnimationController _successAnimationController;
  late AnimationController _containerAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> _paymentMethods = [
    'Bank Transfer',
    'Credit Card',
    'Debit Card',
    'Mobile Wallet',
    'Cash'
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _containerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _containerAnimationController,
      curve: Curves.elasticOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _containerAnimationController,
      curve: Curves.easeOutCubic,
    ));

    // Start container animation when screen loads
    _containerAnimationController.forward();
  }

  String? _validateRecipientName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Recipient name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    
    double? amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'Please enter a valid number';
    }
    
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    
    if (amount > 10000) {
      return 'Amount cannot exceed \$10,000';
    }
    
    return null;
  }

  void _processSendMoney() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      print('=== SEND MONEY TRANSACTION ===');
      print('Recipient: ${_recipientController.text}');
      print('Amount: \$${_amountController.text}');
      print('Payment Method: $_selectedPaymentMethod');
      print('Is Favorite: $_isFavorite');
      print('Transaction Status: Processing...');

      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isProcessing = false;
        _showSuccessMessage = true;
      });

      _successAnimationController.forward();

      print('Transaction Status: SUCCESS');
      print('Transaction ID: TXN${DateTime.now().millisecondsSinceEpoch}');
      print('==============================');

      // Hide success message after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showSuccessMessage = false;
          });
          _successAnimationController.reset();
        }
      });

      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Successfully sent \$${_amountController.text} to ${_recipientController.text}',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearForm() {
    _recipientController.clear();
    _amountController.clear();
    setState(() {
      _selectedPaymentMethod = 'Bank Transfer';
      _isFavorite = false;
      _showSuccessMessage = false;
    });
    _successAnimationController.reset();
    print('Form cleared - Ready for new transaction');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Send Money',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2E5BBA),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Container with Animation
                SlideTransition(
                  position: _slideAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E5BBA), Color(0xFF4A90E2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.send_rounded,
                            size: 48,
                            color: Colors.white,
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Send Money',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Transfer money quickly and securely',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Success Message with Animation
                if (_showSuccessMessage)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Transaction completed successfully!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Recipient Name Field
                _buildSectionTitle('Recipient Information'),
                const SizedBox(height: 12),
                _buildTextFormField(
                  controller: _recipientController,
                  label: 'Recipient Name',
                  hint: 'Enter recipient\'s full name',
                  icon: Icons.person_outline,
                  validator: _validateRecipientName,
                ),

                const SizedBox(height: 24),

                // Amount Field
                _buildSectionTitle('Transaction Details'),
                const SizedBox(height: 12),
                _buildTextFormField(
                  controller: _amountController,
                  label: 'Amount (\$)',
                  hint: 'Enter amount to send',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  validator: _validateAmount,
                ),

                const SizedBox(height: 24),

                // Payment Method Dropdown
                _buildSectionTitle('Payment Method'),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPaymentMethod,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF2E5BBA)),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPaymentMethod = newValue;
                        });
                        print('Payment method changed to: $newValue');
                      },
                      items: _paymentMethods.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Row(
                            children: [
                              Icon(
                                _getPaymentMethodIcon(value),
                                color: const Color(0xFF2E5BBA),
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(value),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Favorite Switch
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_outline,
                        color: _isFavorite ? Colors.red : Colors.grey,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Save as Favorite',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'Quick access for future transactions',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isFavorite,
                        onChanged: (bool value) {
                          setState(() {
                            _isFavorite = value;
                          });
                          print('Favorite status changed to: $value');
                        },
                        activeColor: const Color(0xFF2E5BBA),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Custom Send Money Button
                CustomSendMoneyButton(
                  onPressed: _isProcessing ? null : _processSendMoney,
                  isLoading: _isProcessing,
                ),

                const SizedBox(height: 16),

                // Clear Form Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _clearForm,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E5BBA),
                      side: const BorderSide(color: Color(0xFF2E5BBA), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.clear_all),
                    label: const Text(
                      'Clear Form',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2E5BBA),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: const Color(0xFF2E5BBA)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method) {
      case 'Bank Transfer':
        return Icons.account_balance;
      case 'Credit Card':
        return Icons.credit_card;
      case 'Debit Card':
        return Icons.payment;
      case 'Mobile Wallet':
        return Icons.phone_android;
      case 'Cash':
        return Icons.money;
      default:
        return Icons.payment;
    }
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    _successAnimationController.dispose();
    _containerAnimationController.dispose();
    super.dispose();
  }
}
