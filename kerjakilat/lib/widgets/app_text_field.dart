import 'package:material_ui/material_ui.dart';

import '../core/app_colors.dart';

/// Kolom isian dengan label di atasnya (sesuai wireframe).
/// Jika [isPassword] true, ada ikon untuk menampilkan/menyembunyikan teks.
class AppTextField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool isPassword;
  final bool enabled;
  final Color accentColor;
  final VoidCallback? onSubmitted;

  const AppTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.accentColor,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.isPassword = false,
    this.enabled = true,
    this.onSubmitted,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // Kata sandi disembunyikan secara default
  bool _obscure = true;

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE4E6F4);
    const errorColor = Color(0xFFB3261E);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          obscureText: widget.isPassword && _obscure,
          autocorrect: false,
          enableSuggestions: !widget.isPassword,
          onFieldSubmitted: (_) => widget.onSubmitted?.call(),
          style: const TextStyle(fontSize: 14, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9CA0B5)),
            filled: true,
            fillColor: const Color(0xFFF7F7FD),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: _border(borderColor),
            enabledBorder: _border(borderColor),
            disabledBorder: _border(borderColor),
            focusedBorder: _border(widget.accentColor, 1.6),
            errorBorder: _border(errorColor),
            focusedErrorBorder: _border(errorColor, 1.6),
            suffixIcon: widget.isPassword
                ? IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: AppColors.textGrey,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}