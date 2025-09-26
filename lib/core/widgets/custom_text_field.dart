import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable text field widget that provides consistent styling and behavior
/// throughout the application with additional features and validation support
class CustomTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final FocusNode? focusNode;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final bool filled;
  final OutlineInputBorder? border;
  final OutlineInputBorder? focusedBorder;
  final OutlineInputBorder? errorBorder;
  final OutlineInputBorder? disabledBorder;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final bool showCharacterCount;
  final Widget? prefix;
  final Widget? suffix;

  const CustomTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconPressed,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.contentPadding,
    this.fillColor,
    this.filled = true,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.disabledBorder,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
    this.showCharacterCount = false,
    this.prefix,
    this.suffix,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _errorText = widget.errorText;
  }

  @override
  void didUpdateWidget(CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != oldWidget.errorText) {
      _errorText = widget.errorText;
    }
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  String? _validate(String? value) {
    if (widget.validator != null) {
      final error = widget.validator!(value);
      setState(() {
        _errorText = error;
      });
      return error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          maxLines: _obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          validator: _validate,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          textCapitalization: widget.textCapitalization,
          textAlign: widget.textAlign,
          style: widget.textStyle ?? theme.textTheme.bodyLarge,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            helperText: widget.helperText,
            errorText: _errorText,
            prefixIcon: widget.prefixIcon != null 
                ? Icon(widget.prefixIcon) 
                : null,
            prefix: widget.prefix,
            suffixIcon: _buildSuffixIcon(),
            suffix: widget.suffix,
            filled: widget.filled,
            fillColor: widget.fillColor ?? 
                (theme.brightness == Brightness.dark 
                    ? theme.colorScheme.surface
                    : theme.colorScheme.surface),
            contentPadding: widget.contentPadding ?? 
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: widget.border ?? _getDefaultBorder(theme),
            focusedBorder: widget.focusedBorder ?? _getFocusedBorder(theme),
            errorBorder: widget.errorBorder ?? _getErrorBorder(theme),
            focusedErrorBorder: widget.errorBorder ?? _getErrorBorder(theme),
            disabledBorder: widget.disabledBorder ?? _getDisabledBorder(theme),
            labelStyle: widget.labelStyle,
            hintStyle: widget.hintStyle ?? theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
            counterStyle: widget.showCharacterCount 
                ? theme.textTheme.bodySmall
                : const TextStyle(height: 0, fontSize: 0),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
        ),
        onPressed: _toggleObscureText,
      );
    } else if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(widget.suffixIcon),
        onPressed: widget.onSuffixIconPressed,
      );
    }
    return null;
  }

  OutlineInputBorder _getDefaultBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: theme.colorScheme.outline.withOpacity(0.5),
        width: 1.0,
      ),
    );
  }

  OutlineInputBorder _getFocusedBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: theme.colorScheme.primary,
        width: 2.0,
      ),
    );
  }

  OutlineInputBorder _getErrorBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: theme.colorScheme.error,
        width: 2.0,
      ),
    );
  }

  OutlineInputBorder _getDisabledBorder(ThemeData theme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(
        color: theme.disabledColor.withOpacity(0.3),
        width: 1.0,
      ),
    );
  }
}

/// A search text field with built-in search icon and clear functionality
class SearchTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClear;
  final bool showClearButton;
  final EdgeInsets? margin;

  const SearchTextField({
    super.key,
    this.hintText = 'Search...',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.showClearButton = true,
    this.margin,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;
  bool _showClear = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _showClear = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClear != hasText) {
      setState(() {
        _showClear = hasText;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
  }

  void _clearText() {
    _controller.clear();
    if (widget.onClear != null) {
      widget.onClear!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: CustomTextField(
        controller: _controller,
        hintText: widget.hintText,
        prefixIcon: Icons.search,
        suffixIcon: _showClear && widget.showClearButton ? Icons.clear : null,
        onSuffixIconPressed: _showClear ? _clearText : null,
        onSubmitted: widget.onSubmitted,
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,
      ),
    );
  }
}

/// A multi-line text field optimized for longer text input
class MultiLineTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final EdgeInsets? contentPadding;

  const MultiLineTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.maxLines = 5,
    this.minLines = 3,
    this.maxLength,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: labelText,
      hintText: hintText,
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      contentPadding: contentPadding ?? 
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      showCharacterCount: maxLength != null,
    );
  }
}

/// A number input field with built-in validation and formatting
class NumberTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final double? min;
  final double? max;
  final int? decimalPlaces;
  final void Function(double?)? onChanged;
  final bool enabled;
  final bool allowNegative;

  const NumberTextField({
    super.key,
    this.labelText,
    this.hintText,
    this.controller,
    this.min,
    this.max,
    this.decimalPlaces = 0,
    this.onChanged,
    this.enabled = true,
    this.allowNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      labelText: labelText,
      hintText: hintText,
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(
        decimal: decimalPlaces != null && decimalPlaces! > 0,
        signed: allowNegative,
      ),
      inputFormatters: [
        if (!allowNegative) FilteringTextInputFormatter.deny(RegExp(r'-')),
        if (decimalPlaces == 0) 
          FilteringTextInputFormatter.digitsOnly
        else
          FilteringTextInputFormatter.allow(
            RegExp(r'^\d+\.?\d{0,' + decimalPlaces.toString() + r'}'),
          ),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return null;
        
        final number = double.tryParse(value);
        if (number == null) return 'Please enter a valid number';
        
        if (min != null && number < min!) {
          return 'Value must be at least $min';
        }
        
        if (max != null && number > max!) {
          return 'Value must be at most $max';
        }
        
        return null;
      },
      onChanged: (value) {
        if (onChanged != null) {
          final number = double.tryParse(value);
          onChanged!(number);
        }
      },
      enabled: enabled,
    );
  }
}