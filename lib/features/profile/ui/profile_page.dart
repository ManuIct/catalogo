import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'profile_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (vm.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profilo')),
        body: Center(child: Text(vm.error!)),
      );
    }

    final user = vm.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Profilo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nome: ${user?['firstName'] ?? ''} ${user?['lastName'] ?? ''}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Email: ${user?['email'] ?? ''}'),
            const SizedBox(height: 8),
            Text('Username: ${user?['username'] ?? ''}'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => vm.logout(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}