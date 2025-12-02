import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: auth.isLoggedIn
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  Icon(Icons.person, size: 80, color: Colors.orange),
                  Text('Halo, ${auth.user!.username}'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => auth.logout(),
                    child: const Text('Logout'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                child: const Text('Login'),
              ),
      ),
    );
  }
}
