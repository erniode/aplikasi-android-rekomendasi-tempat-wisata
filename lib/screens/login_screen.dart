import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart'; // Import layar register

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = ''; // Dalam implementasi nyata, ini akan menjadi email/UID
  String _password = '';
  bool _loading = false;

  void _submitLogin(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() => _loading = true);
    final ok = await auth.login(_username, _password);
    setState(() => _loading = false);

    if (ok) {
      if (Navigator.canPop(context)) Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Login gagal. Periksa Username dan Password.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login Akun')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Masukkan password' : null,
              ),
              const SizedBox(height: 30),
              // Tombol Login
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => _submitLogin(auth),
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),
              // Tombol Buat Akun
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterScreen.routeName);
                },
                child: const Text(
                  'Belum punya akun? Buat Akun di sini',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
