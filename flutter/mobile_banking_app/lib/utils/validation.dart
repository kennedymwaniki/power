import 'package:flutter/material.dart';
import '../utils/banking_theme.dart';

class EnhancedValidation {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );
  
  static final RegExp _amountRegex = RegExp(
    r'^\d+\.?\d{0,2}$',
  );
  
  // Name validation with enhanced rules
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.trim().length > 50) {
      return 'Name cannot exceed 50 characters';
    }
    
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }
  
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    
    if (!_phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    
    return null;
  }
  
  // Enhanced amount validation
  static String? validateAmount(String? value, {
    double minAmount = 0.01,
    double maxAmount = 10000.0,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    
    if (!_amountRegex.hasMatch(value.trim())) {
      return 'Please enter a valid amount (e.g., 123.45)';
    }
    
    double? amount = double.tryParse(value.trim());
    if (amount == null) {
      return 'Please enter a valid number';
    }
    
    if (amount < minAmount) {
      return 'Amount must be at least \$${minAmount.toStringAsFixed(2)}';
    }
    
    if (amount > maxAmount) {
      return 'Amount cannot exceed \$${maxAmount.toStringAsFixed(2)}';
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, and number';
    }
    
    return null;
  }
  
  // Account number validation
  static String? validateAccountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    
    if (!RegExp(r'^\d{10,16}$').hasMatch(value.trim())) {
      return 'Account number must be 10-16 digits';
    }
    
    return null;
  }
  
  // Routing number validation
  static String? validateRoutingNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Routing number is required';
    }
    
    if (!RegExp(r'^\d{9}$').hasMatch(value.trim())) {
      return 'Routing number must be exactly 9 digits';
    }
    
    return null;
  }
  
  // Credit card validation (simple Luhn algorithm)
  static String? validateCreditCard(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Card number is required';
    }
    
    String cleanValue = value.replaceAll(RegExp(r'\s+'), '');
    
    if (!RegExp(r'^\d{13,19}$').hasMatch(cleanValue)) {
      return 'Invalid card number format';
    }
    
    if (!_luhnCheck(cleanValue)) {
      return 'Invalid card number';
    }
    
    return null;
  }
  
  // CVV validation
  static String? validateCVV(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'CVV is required';
    }
    
    if (!RegExp(r'^\d{3,4}$').hasMatch(value.trim())) {
      return 'CVV must be 3 or 4 digits';
    }
    
    return null;
  }
  
  // Expiry date validation (MM/YY format)
  static String? validateExpiryDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Expiry date is required';
    }
    
    if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$').hasMatch(value.trim())) {
      return 'Please enter date in MM/YY format';
    }
    
    List<String> parts = value.trim().split('/');
    int month = int.parse(parts[0]);
    int year = int.parse(parts[1]) + 2000;
    
    DateTime now = DateTime.now();
    DateTime expiry = DateTime(year, month + 1, 0);
    
    if (expiry.isBefore(now)) {
      return 'Card has expired';
    }
    
    return null;
  }
  
  // Helper method for Luhn algorithm
  static bool _luhnCheck(String cardNumber) {
    int sum = 0;
    bool isEven = false;
    
    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);
      
      if (isEven) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }
      
      sum += digit;
      isEven = !isEven;
    }
    
    return sum % 10 == 0;
  }
  
  // Real-time validation feedback
  static ValidationState getValidationState(String? value, String? Function(String?) validator) {
    String? error = validator(value);
    
    if (value == null || value.isEmpty) {
      return ValidationState.empty;
    } else if (error != null) {
      return ValidationState.error;
    } else {
      return ValidationState.valid;
    }
  }
}

enum ValidationState {
  empty,
  valid,
  error,
}

// Enhanced Validation Result
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final ValidationState state;
  
  const ValidationResult({
    required this.isValid,
    this.errorMessage,
    required this.state,
  });
  
  factory ValidationResult.valid() {
    return const ValidationResult(
      isValid: true,
      state: ValidationState.valid,
    );
  }
  
  factory ValidationResult.error(String message) {
    return ValidationResult(
      isValid: false,
      errorMessage: message,
      state: ValidationState.error,
    );
  }
  
  factory ValidationResult.empty() {
    return const ValidationResult(
      isValid: false,
      state: ValidationState.empty,
    );
  }
}
