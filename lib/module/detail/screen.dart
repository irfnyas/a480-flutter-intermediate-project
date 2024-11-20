import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/story_model.dart';
import '../../util/view_result_state.dart';
import 'provider.dart';

class DetailScreen extends StatefulWidget {
  final Story story;

  const DetailScreen({
    super.key,
    required this.story,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<DetailProvider>().fetchData(widget.story.id ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Detail'),
      ),
      body: ListView(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 200,
            ),
            child: Hero(
              tag: widget.story.id ?? '',
              child: Image.network(
                widget.story.photoUrl ?? '',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(),
              ),
            ),
          ),
          Consumer<DetailProvider>(
            builder: (_, provider, __) {
              return switch (provider.resultState) {
                ViewErrorState(error: var message) => DetailErrorView(
                    message: message,
                  ),
                ViewLoadedState(story: var story) => DetailLoadedView(
                    story: story,
                  ),
                _ => const LinearProgressIndicator(),
              };
            },
          ),
        ],
      ),
    );
  }
}

class DetailErrorView extends StatelessWidget {
  const DetailErrorView({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(height: 16),
            Text(
              message?.replaceFirst('Exception: ', '') ?? '',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class DetailLoadedView extends StatelessWidget {
  const DetailLoadedView({
    super.key,
    required this.story,
  });

  final Story? story;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: story?.name ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '  '),
            TextSpan(text: story?.description ?? ''),
          ],
        ),
      ),
    );
  }
}
