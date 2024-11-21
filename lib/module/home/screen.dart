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
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<HomeProvider>().fetchData();
    });

    scrollController.addListener(() {
      final atEdge = scrollController.position.pixels >=
          scrollController.position.maxScrollExtent;
      if (atEdge) context.read<HomeProvider>().fetchData();
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
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
                  scrollController: scrollController,
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
  const HomeLoadedView({
    super.key,
    required this.stories,
    required this.scrollController,
  });

  final List<Story> stories;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      itemCount: stories.length + 1,
      itemBuilder: (_, i) {
        final lastIndex = i == stories.length;
        if (lastIndex) {
          return Visibility(
            visible: !context.read<HomeProvider>().isLastPage,
            child: const Center(
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator()),
            ),
          );
        }

        return StoryCard(story: stories[i]);
      },
      controller: scrollController,
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
                  overflow: TextOverflow.ellipsis,
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
