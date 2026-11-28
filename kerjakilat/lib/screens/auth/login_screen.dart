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

/// Halaman Login. Satu kelas dipakai untuk Pencari Kerja dan Pemberi Kerja;
/// perbedaannya hanya pada [role] (warna, teks, dan pemeriksaan peran).
class LoginScreen extends StatefulWidget {
  final UserRole role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passController = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _idController.dispose();
    _passController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (_loading) return;
    setState(() => _error = null);

    // 1. Validasi isian
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    final auth = context.read<AuthService>();
    final session = context.read<SessionNotifier>();

    try {
      // 2. Login + pemeriksaan peran
      final profile = await auth.login(
        identifier: _idController.text,
        password: _passController.text,
        role: widget.role,
      );
      // 3. Simpan sesi. Router otomatis membuka beranda sesuai peran.
      session.setProfile(profile);
    } on AuthException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (e) {
      debugPrint('Login error: $e');
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
      title: 'Selamat datang!',
      subtitle: isSeeker
          ? 'Masuk untuk mencari pekerjaan harian di sekitarmu.'
          : 'Masuk untuk mengelola postingan dan pelamarmu.',
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
              label: 'Email atau nomor HP',
              hint: 'nama@email.com / 08xx',
              controller: _idController,
              accentColor: color,
              keyboardType: TextInputType.emailAddress,
              validator: Validators.loginIdentifier,
              enabled: !_loading,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Kata sandi',
              hint: '••••••••',
              controller: _passController,
              accentColor: color,
              isPassword: true,
              textInputAction: TextInputAction.done,
              validator: Validators.loginPassword,
              enabled: !_loading,
              onSubmitted: _submit,
            ),
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Masuk',
              color: color,
              loading: _loading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
      switchText: 'Belum punya akun?',
      switchLinkText:
          isSeeker ? 'Buat akun pencari kerja' : 'Buat akun pemberi kerja',
      // pushReplacement: tombol kembali tetap menuju Pilih Peran
      onSwitchTap: () => context.pushReplacement('/register/${role.value}'),
      infoText: isSeeker
          ? 'Ingin menawarkan pekerjaan, bukan mencari?'
          : 'Ingin mencari kerja, bukan menawarkan?',
      infoLinkText:
          isSeeker ? 'Masuk sebagai pemberi kerja' : 'Masuk sebagai pencari kerja',
      onInfoTap: () => context.pushReplacement('/login/${other.value}'),
    );
  }
}