import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/banking_theme.dart';
import '../utils/validation.dart';
import '../widgets/enhanced_input_field.dart';
import '../widgets/enhanced_widgets.dart';
import '../widgets/custom_send_money_button.dart';

class ProfileManagementScreen extends StatefulWidget {
  const ProfileManagementScreen({super.key});

  @override
  State<ProfileManagementScreen> createState() => _ProfileManagementScreenState();
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  
  // Form Controllers
  final _firstNameController = TextEditingController(text: 'John');
  final _lastNameController = TextEditingController(text: 'Doe');
  final _emailController = TextEditingController(text: 'john.doe@email.com');
  final _phoneController = TextEditingController(text: '+1234567890');
  final _addressController = TextEditingController(text: '123 Main St');
  final _cityController = TextEditingController(text: 'New York');
  final _zipController = TextEditingController(text: '10001');
  
  // Security Controllers
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Preferences
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  bool _marketingEmails = false;
  bool _smsAlerts = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';
  
  // Animation Controllers
  late AnimationController _saveAnimationController;
  late Animation<double> _saveAnimation;
  
  bool _isLoading = false;
  bool _hasChanges = false;

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];
  final List<String> _currencies = ['USD', 'EUR', 'GBP', 'CAD'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _setupAnimations();
    _setupListeners();
  }

  void _setupAnimations() {
    _saveAnimationController = AnimationController(
      duration: BankingTheme.normalAnimation,
      vsync: this,
    );
    
    _saveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _saveAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  void _setupListeners() {
    // Add listeners to detect changes
    _firstNameController.addListener(_onFormChanged);
    _lastNameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _addressController.addListener(_onFormChanged);
    _cityController.addListener(_onFormChanged);
    _zipController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      _saveAnimationController.forward();
      
      setState(() {
        _isLoading = false;
        _hasChanges = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Profile updated successfully!'),
            ],
          ),
          backgroundColor: BankingTheme.successColor,
          duration: const Duration(seconds: 3),
        ),
      );

      print('=== PROFILE UPDATED ===');
      print('Name: ${_firstNameController.text} ${_lastNameController.text}');
      print('Email: ${_emailController.text}');
      print('Phone: ${_phoneController.text}');
      print('Notifications: $_notificationsEnabled');
      print('Biometric: $_biometricEnabled');
    }
  }

  Future<void> _changePassword() async {
    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all password fields'),
          backgroundColor: BankingTheme.errorColor,
        ),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New passwords do not match'),
          backgroundColor: BankingTheme.errorColor,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _currentPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Password changed successfully!'),
          ],
        ),
        backgroundColor: BankingTheme.successColor,
      ),
    );

    print('Password changed successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BankingTheme.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Profile Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: BankingTheme.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_hasChanges)
            AnimatedBuilder(
              animation: _saveAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_saveAnimation.value * 0.1),
                  child: IconButton(
                    icon: const Icon(Icons.save),
                    onPressed: _isLoading ? null : _saveProfile,
                  ),
                );
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Personal'),
            Tab(icon: Icon(Icons.security), text: 'Security'),
            Tab(icon: Icon(Icons.settings), text: 'Preferences'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPersonalTab(),
          _buildSecurityTab(),
          _buildPreferencesTab(),
        ],
      ),
    );
  }

  Widget _buildPersonalTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture Section
            Center(
              child: EnhancedCardWidget(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: BankingTheme.primaryColor.withOpacity(0.1),
                          child: const Icon(
                            Icons.person,
                            size: 50,
                            color: BankingTheme.primaryColor,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: BankingTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                              onPressed: () {
                                print('Change profile picture');
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_firstNameController.text} ${_lastNameController.text}',
                      style: BankingTheme.headingMedium,
                    ),
                    Text(
                      _emailController.text,
                      style: BankingTheme.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Personal Information
            Text('Personal Information', style: BankingTheme.headingSmall),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: EnhancedInputField(
                    controller: _firstNameController,
                    label: 'First Name',
                    hint: 'Enter your first name',
                    icon: Icons.person_outline,
                    validator: EnhancedValidation.validateName,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: EnhancedInputField(
                    controller: _lastNameController,
                    label: 'Last Name',
                    hint: 'Enter your last name',
                    icon: Icons.person_outline,
                    validator: EnhancedValidation.validateName,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            EnhancedInputField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'Enter your email address',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: EnhancedValidation.validateEmail,
            ),

            const SizedBox(height: 16),

            EnhancedInputField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: 'Enter your phone number',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: EnhancedValidation.validatePhone,
            ),

            const SizedBox(height: 24),

            Text('Address Information', style: BankingTheme.headingSmall),
            const SizedBox(height: 16),

            EnhancedInputField(
              controller: _addressController,
              label: 'Street Address',
              hint: 'Enter your street address',
              icon: Icons.home_outlined,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: EnhancedInputField(
                    controller: _cityController,
                    label: 'City',
                    hint: 'Enter your city',
                    icon: Icons.location_city_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: EnhancedInputField(
                    controller: _zipController,
                    label: 'ZIP Code',
                    hint: 'ZIP',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            CustomSendMoneyButton(
              onPressed: _isLoading ? null : _saveProfile,
              isLoading: _isLoading,
              text: 'Save Changes',
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Change Password', style: BankingTheme.headingSmall),
          const SizedBox(height: 16),

          EnhancedInputField(
            controller: _currentPasswordController,
            label: 'Current Password',
            hint: 'Enter your current password',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Current password is required';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          EnhancedInputField(
            controller: _newPasswordController,
            label: 'New Password',
            hint: 'Enter your new password',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: EnhancedValidation.validatePassword,
          ),

          const SizedBox(height: 16),

          EnhancedInputField(
            controller: _confirmPasswordController,
            label: 'Confirm New Password',
            hint: 'Confirm your new password',
            icon: Icons.lock_outline,
            isPassword: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          CustomActionButton(
            onPressed: _changePassword,
            text: 'Change Password',
            icon: Icons.security,
            backgroundColor: BankingTheme.warningColor,
          ),

          const SizedBox(height: 32),

          Text('Security Settings', style: BankingTheme.headingSmall),
          const SizedBox(height: 16),

          EnhancedCardWidget(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Biometric Authentication'),
                  subtitle: const Text('Use fingerprint or face ID'),
                  value: _biometricEnabled,
                  onChanged: (value) {
                    setState(() {
                      _biometricEnabled = value;
                      _hasChanges = true;
                    });
                    print('Biometric authentication: $value');
                  },
                  activeColor: BankingTheme.primaryColor,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.devices, color: BankingTheme.primaryColor),
                  title: const Text('Manage Devices'),
                  subtitle: const Text('View and manage logged-in devices'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    print('Manage devices tapped');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.history, color: BankingTheme.primaryColor),
                  title: const Text('Login History'),
                  subtitle: const Text('View recent login activity'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    print('Login history tapped');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Notifications', style: BankingTheme.headingSmall),
          const SizedBox(height: 16),

          EnhancedCardWidget(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Receive notifications on your device'),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationsEnabled = value;
                      _hasChanges = true;
                    });
                  },
                  activeColor: BankingTheme.primaryColor,
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('SMS Alerts'),
                  subtitle: const Text('Receive SMS for important transactions'),
                  value: _smsAlerts,
                  onChanged: (value) {
                    setState(() {
                      _smsAlerts = value;
                      _hasChanges = true;
                    });
                  },
                  activeColor: BankingTheme.primaryColor,
                ),
                const Divider(),
                SwitchListTile(
                  title: const Text('Marketing Emails'),
                  subtitle: const Text('Receive promotional offers'),
                  value: _marketingEmails,
                  onChanged: (value) {
                    setState(() {
                      _marketingEmails = value;
                      _hasChanges = true;
                    });
                  },
                  activeColor: BankingTheme.primaryColor,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text('Regional Settings', style: BankingTheme.headingSmall),
          const SizedBox(height: 16),

          EnhancedCardWidget(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language, color: BankingTheme.primaryColor),
                  title: const Text('Language'),
                  subtitle: Text(_selectedLanguage),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showLanguageDialog(),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.attach_money, color: BankingTheme.primaryColor),
                  title: const Text('Currency'),
                  subtitle: Text(_selectedCurrency),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showCurrencyDialog(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text('Account Actions', style: BankingTheme.headingSmall),
          const SizedBox(height: 16),

          EnhancedCardWidget(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download, color: BankingTheme.primaryColor),
                  title: const Text('Export Data'),
                  subtitle: const Text('Download your account data'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    print('Export data tapped');
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.lock, color: BankingTheme.warningColor),
                  title: const Text('Freeze Account'),
                  subtitle: const Text('Temporarily disable your account'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showFreezeAccountDialog();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: BankingTheme.errorColor),
                  title: const Text('Close Account'),
                  subtitle: const Text('Permanently close your account'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    _showCloseAccountDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _languages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                    _hasChanges = true;
                  });
                  Navigator.pop(context);
                },
                activeColor: BankingTheme.primaryColor,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Currency'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _currencies.map((currency) {
              return RadioListTile<String>(
                title: Text(currency),
                value: currency,
                groupValue: _selectedCurrency,
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!;
                    _hasChanges = true;
                  });
                  Navigator.pop(context);
                },
                activeColor: BankingTheme.primaryColor,
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showFreezeAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Freeze Account'),
          content: const Text(
            'Are you sure you want to temporarily freeze your account? '
            'You won\'t be able to make transactions until you unfreeze it.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                print('Account frozen');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account has been frozen'),
                    backgroundColor: BankingTheme.warningColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BankingTheme.warningColor,
              ),
              child: const Text('Freeze'),
            ),
          ],
        );
      },
    );
  }

  void _showCloseAccountDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Close Account'),
          content: const Text(
            'This action cannot be undone. All your data will be permanently deleted. '
            'Please ensure you have transferred all funds and downloaded any required data.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                print('Account closure requested');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Account closure request submitted'),
                    backgroundColor: BankingTheme.errorColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BankingTheme.errorColor,
              ),
              child: const Text('Close Account'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _saveAnimationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
