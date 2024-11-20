import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (_, provider, __) => PopScope(
        onPopInvokedWithResult: (_, __) => provider.formClear(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Post My Story'),
          ),
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: provider.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                          ),
                          child: provider.imageFile != null
                              ? Image.file(
                                  File(provider.imageFile?.path ?? ''),
                                )
                              : Center(
                                  child: Icon(
                                    Icons.hide_image_outlined,
                                    size: 40,
                                    color: Theme.of(context).highlightColor,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => provider.pickImage(
                                  ImageSource.camera,
                                ),
                                icon: const Icon(Icons.camera_alt_rounded),
                                label: const Text('From Camera'),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () => provider.pickImage(
                                  ImageSource.gallery,
                                ),
                                icon: const Icon(Icons.image_rounded),
                                label: const Text('From Gallery'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          controller: provider.descController,
                          decoration: const InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value?.isNotEmpty != true) {
                              return 'Description must not be empty';
                            }
                            if (provider.imageFile == null) {
                              return 'Image must not be empty';
                            }
                            return null;
                          },
                        ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () => provider.upload(context),
                          child: const Text('Post'),
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
