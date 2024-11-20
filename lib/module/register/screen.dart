import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterProvider>(
      builder: (_, provider, __) => PopScope(
        onPopInvokedWithResult: (_, __) => provider.formClear(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Register at My Story'),
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
                          controller: provider.nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value?.isNotEmpty != true) {
                              return 'Name must not be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
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
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
