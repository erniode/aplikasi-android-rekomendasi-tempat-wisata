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
  String _confirmPass = '';
  bool _loading = false;

  void _submitRegister(AuthProvider auth) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    if (_password != _confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password tidak sama.")),
      );
      return;
    }

    setState(() => _loading = true);
    final ok = await auth.register(_username, _password);
    setState(() => _loading = false);

    if (ok && mounted) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mendaftar. Silakan coba lagi."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(255, 201, 155, 75),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),

                /// 👤 ICON BULAT
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person_add,
                    size: 50,
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(height: 25),

                /// 📦 CARD REGISTER FORM
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (v) => _username = v ?? '',
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Masukkan username'
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            onSaved: (v) => _password = v ?? '',
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Masukkan password'
                                : null,
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Konfirmasi Password',
                              prefixIcon: Icon(Icons.lock_outline),
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            onSaved: (v) => _confirmPass = v ?? '',
                            validator: (v) => (v == null || v.isEmpty)
                                ? 'Masukkan konfirmasi password'
                                : null,
                          ),
                          const SizedBox(height: 25),
                          _loading
                              ? const CircularProgressIndicator()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize:
                                        const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () => _submitRegister(auth),
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

                const SizedBox(height: 25),

                /// 🔗 LINK KEMBALI KE LOGIN
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Sudah punya akun? Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
