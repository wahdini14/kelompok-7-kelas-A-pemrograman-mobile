import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../core/app_colors.dart';
import '../../core/validators.dart';
import '../../models/user_role.dart';
import '../../services/auth_service.dart';
import '../../services/session_notifier.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/auth_error_box.dart';
import '../../widgets/auth_scaffold.dart';
import '../../widgets/primary_button.dart';

/// Halaman Register. Dipakai untuk kedua peran lewat parameter [role].
/// Peran akun yang dibuat sama dengan peran halaman ini.
class RegisterScreen extends StatefulWidget {
  final UserRole role;

  const RegisterScreen({super.key, required this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool _agreed = false;
  bool _showAgreeError = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _setAgreed(bool value) {
    setState(() {
      _agreed = value;
      if (value) _showAgreeError = false;
    });
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_loading) return;
    setState(() => _error = null);

    // 1. Validasi isian dan checkbox persetujuan
    final formOk = _formKey.currentState!.validate();
    if (!_agreed) setState(() => _showAgreeError = true);
    if (!formOk || !_agreed) return;

    setState(() => _loading = true);
    final auth = context.read<AuthService>();
    final session = context.read<SessionNotifier>();
    final messenger = ScaffoldMessenger.of(context);

    try {
      // 2. Buat akun + simpan data ke database
      final profile = await auth.register(
        fullName: _nameController.text,
        phoneInput: _phoneController.text,
        emailInput: _emailController.text,
        password: _passController.text,
        role: widget.role,
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Akun berhasil dibuat. Selamat datang!')),
      );
      // 3. Simpan sesi. Router otomatis membuka beranda sesuai peran.
      session.setProfile(profile);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      debugPrint('Register error: $e');
      if (mounted) {
        setState(() => _error = 'Terjadi kesalahan. Coba lagi.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = widget.role;
    final color = AppColors.forRole(role);
    final isSeeker = role == UserRole.jobSeeker;
    final other = isSeeker ? UserRole.employer : UserRole.jobSeeker;

    return AuthScaffold(
      role: role,
      title: 'Buat akun baru',
      subtitle: isSeeker
          ? 'Gratis, tanpa CV. Cukup nama dan nomor HP.'
          : 'Gratis. Posting pekerjaan pertama dalam 1 menit.',
      formCard: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null) ...[
              AuthErrorBox(message: _error!),
              const SizedBox(height: 14),
            ],
            AppTextField(
              label: 'Nama lengkap',
              hint: 'Nama sesuai KTP',
              controller: _nameController,
              accentColor: color,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              validator: Validators.fullName,
              enabled: !_loading,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Nomor HP (WhatsApp)',
              hint: '08xx-xxxx-xxxx',
              controller: _phoneController,
              accentColor: color,
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
              enabled: !_loading,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Email (opsional)',
              hint: 'nama@email.com',
              controller: _emailController,
              accentColor: color,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.optionalEmail,
              enabled: !_loading,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Kata sandi',
              hint: 'Minimal 8 karakter',
              controller: _passController,
              accentColor: color,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: Validators.newPassword,
              enabled: !_loading,
              onSubmitted: _submit,
            ),
            const SizedBox(height: 14),

            // Checkbox persetujuan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _agreed,
                    activeColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    onChanged:
                        _loading ? null : (v) => _setAgreed(v ?? false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: _loading ? null : () => _setAgreed(!_agreed),
                    child: const Text(
                      'Saya setuju dengan Syarat & Ketentuan dan '
                      'Kebijakan Privasi.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.4,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showAgreeError)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text(
                  'Centang persetujuan untuk melanjutkan.',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB3261E)),
                ),
              ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Buat Akun',
              color: color,
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
      switchText: 'Sudah punya akun?',
      switchLinkText: 'Masuk',
      onSwitchTap: () => context.pushReplacement('/login/${role.value}'),
      infoText: isSeeker
          ? 'Ingin menawarkan pekerjaan, bukan mencari?'
          : 'Ingin mencari kerja, bukan menawarkan?',
      infoLinkText: isSeeker
          ? 'Daftar sebagai pemberi kerja'
          : 'Daftar sebagai pencari kerja',
      onInfoTap: () => context.pushReplacement('/register/${other.value}'),
    );
  }
}