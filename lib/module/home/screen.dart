import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/story_model.dart';
import '../../util/view_result_state.dart';
import 'provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<HomeProvider>().fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Stories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_a_photo_rounded),
            onPressed: () => context.read<HomeProvider>().navToPost(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => context.read<HomeProvider>().logout(context),
          ),
        ],
      ),
      body: Center(
        child: Consumer<HomeProvider>(
          builder: (_, provider, __) {
            return switch (provider.resultState) {
              ViewErrorState(error: var message) => HomeErrorView(
                  message: message,
                ),
              ViewLoadedState(stories: var stories) => HomeLoadedView(
                  stories: stories ?? [],
                ),
              _ => const CircularProgressIndicator(),
            };
          },
        ),
      ),
    );
  }
}

class HomeErrorView extends StatelessWidget {
  const HomeErrorView({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}

class HomeLoadedView extends StatelessWidget {
  const HomeLoadedView({super.key, required this.stories});
  final List<Story> stories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      itemCount: stories.length,
      itemBuilder: (_, i) => StoryCard(story: stories[i]),
    );
  }
}

class StoryCard extends StatelessWidget {
  final Story story;

  const StoryCard({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                child: Hero(
                  tag: story.id ?? '',
                  child: Image.network(
                    story.photoUrl ?? '',
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: RichText(
                  maxLines: 3,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: story.name ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: '  '),
                      TextSpan(text: story.description ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => context.read<HomeProvider>().navToDetail(
                      context,
                      story,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
