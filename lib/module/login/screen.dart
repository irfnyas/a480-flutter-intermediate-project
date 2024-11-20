import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (_, provider, __) => Scaffold(
        appBar: AppBar(
          title: const Text('Login to My Story'),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Container(
                padding: const EdgeInsets.all(40),
                child: Form(
                  key: provider.formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: provider.userController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isNotEmpty != true) {
                            return 'Email must not be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: provider.passController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value?.isNotEmpty != true) {
                            return 'Password must not be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton(
                        onPressed: () => provider.login(context),
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => provider.navToRegister(context),
                        child:
                            const Text('Don\'t have an account? Register now'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
