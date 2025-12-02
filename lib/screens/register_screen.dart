import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _confirmPassword = '';
  bool _loading = false;

  void _submitRegistration(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok!')),
      );
      return;
    }

    setState(() => _loading = true);

    // Default role adalah 'user'
    final ok = await auth.register(
      _username,
      _password,
    );

    setState(() => _loading = false);

    if (ok) {
      // Jika berhasil mendaftar, kembali ke layar sebelumnya (Login/Home)
      if (Navigator.canPop(context)) Navigator.pop(context);
    } else {
      // Tampilkan pesan error dari AuthProvider (misalnya: username sudah digunakan)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Pendaftaran gagal. Cek kredensial Anda.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Akun Baru')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (v) => _username = v ?? '',
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Masukkan username' : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onSaved: (v) => _password = v ?? '',
                  validator: (v) => (v == null || v.length < 6)
                      ? 'Password minimal 6 karakter'
                      : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  onSaved: (v) => _confirmPassword = v ?? '',
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Masukkan konfirmasi password'
                      : null,
                ),
                const SizedBox(height: 30),
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () => _submitRegistration(auth),
                        child: const Text(
                          'Daftar',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
