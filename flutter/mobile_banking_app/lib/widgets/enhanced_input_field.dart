import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/banking_theme.dart';
import '../utils/validation.dart';

class EnhancedInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool enabled;
  final int maxLines;
  final String? suffixText;
  final Widget? suffix;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool autofocus;
  final bool showValidationIcon;

  const EnhancedInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.validator,
    this.isPassword = false,
    this.enabled = true,
    this.maxLines = 1,
    this.suffixText,
    this.suffix,
    this.onTap,
    this.onChanged,
    this.autofocus = false,
    this.showValidationIcon = true,
  });

  @override
  State<EnhancedInputField> createState() => _EnhancedInputFieldState();
}

class _EnhancedInputFieldState extends State<EnhancedInputField>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  
  ValidationState _validationState = ValidationState.empty;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
    _setupAnimations();
    
    // Initial validation
    if (widget.controller.text.isNotEmpty) {
      _validateInput(widget.controller.text);
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: BankingTheme.fastAnimation,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: BankingTheme.primaryColor,
      end: BankingTheme.accentColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void _validateInput(String value) {
    if (widget.validator != null) {
      String? error = widget.validator!(value);
      setState(() {
        _errorMessage = error;
        _validationState = EnhancedValidation.getValidationState(value, widget.validator!);
      });
    }
  }

  Color _getBorderColor() {
    switch (_validationState) {
      case ValidationState.valid:
        return BankingTheme.successColor;
      case ValidationState.error:
        return BankingTheme.errorColor;
      case ValidationState.empty:
      default:
        return Colors.grey.shade300;
    }
  }

  IconData _getValidationIcon() {
    switch (_validationState) {
      case ValidationState.valid:
        return Icons.check_circle;
      case ValidationState.error:
        return Icons.error;
      case ValidationState.empty:
      default:
        return widget.icon;
    }
  }

  Color _getValidationIconColor() {
    switch (_validationState) {
      case ValidationState.valid:
        return BankingTheme.successColor;
      case ValidationState.error:
        return BankingTheme.errorColor;
      case ValidationState.empty:
      default:
        return BankingTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BankingTheme.inputRadius,
              border: Border.all(
                color: _getBorderColor(),
                width: _validationState != ValidationState.empty ? 2 : 1,
              ),
              boxShadow: [
                if (_validationState == ValidationState.valid)
                  BoxShadow(
                    color: BankingTheme.successColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                else if (_validationState == ValidationState.error)
                  BoxShadow(
                    color: BankingTheme.errorColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                else
                  BankingTheme.cardShadow,
              ],
            ),
            child: TextFormField(
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              inputFormatters: widget.inputFormatters,
              obscureText: widget.isPassword && _obscureText,
              enabled: widget.enabled,
              maxLines: widget.maxLines,
              autofocus: widget.autofocus,
              onTap: () {
                _animationController.forward().then((_) {
                  _animationController.reverse();
                });
                widget.onTap?.call();
              },
              onChanged: (value) {
                _validateInput(value);
                widget.onChanged?.call(value);
              },
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                prefixIcon: AnimatedSwitcher(
                  duration: BankingTheme.fastAnimation,
                  child: Icon(
                    widget.showValidationIcon ? _getValidationIcon() : widget.icon,
                    key: ValueKey(widget.showValidationIcon ? _validationState : 'default'),
                    color: widget.showValidationIcon 
                        ? _getValidationIconColor() 
                        : BankingTheme.primaryColor,
                  ),
                ),
                suffixIcon: _buildSuffixIcon(),
                suffixText: widget.suffixText,
                border: OutlineInputBorder(
                  borderRadius: BankingTheme.inputRadius,
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                errorText: _errorMessage,
                errorMaxLines: 2,
                errorStyle: const TextStyle(
                  color: BankingTheme.errorColor,
                  fontSize: 12,
                ),
                labelStyle: TextStyle(
                  color: _colorAnimation.value ?? BankingTheme.primaryColor,
                ),
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                ),
              ),
              validator: widget.validator,
            ),
          ),
        );
      },
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffix != null) {
      return widget.suffix;
    }

    if (widget.isPassword) {
      return IconButton(
        icon: AnimatedSwitcher(
          duration: BankingTheme.fastAnimation,
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            key: ValueKey(_obscureText),
            color: Colors.grey,
          ),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }

    return null;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// Enhanced Date Picker Field
class EnhancedDateField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final Function(DateTime)? onDateSelected;

  const EnhancedDateField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.icon = Icons.calendar_today,
    this.validator,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.onDateSelected,
  });

  @override
  State<EnhancedDateField> createState() => _EnhancedDateFieldState();
}

class _EnhancedDateFieldState extends State<EnhancedDateField> {
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: widget.firstDate ?? DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: widget.lastDate ?? DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: BankingTheme.primaryColor,
              secondary: BankingTheme.secondaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        widget.controller.text = "${picked.day.toString().padLeft(2, '0')}/"
            "${picked.month.toString().padLeft(2, '0')}/"
            "${picked.year}";
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedInputField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      icon: widget.icon,
      validator: widget.validator,
      keyboardType: TextInputType.none,
      onTap: _selectDate,
      suffix: IconButton(
        icon: const Icon(Icons.calendar_today, color: BankingTheme.primaryColor),
        onPressed: _selectDate,
      ),
    );
  }
}
