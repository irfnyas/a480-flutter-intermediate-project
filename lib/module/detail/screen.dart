import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
                    locationName: provider.locationName,
                    locationAddress: provider.locationAddress,
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
    this.locationName,
    this.locationAddress,
  });

  final Story? story;
  final String? locationName;
  final String? locationAddress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
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
          Visibility(
            visible: story?.lat != null && story?.lon != null,
            child: Container(
              margin: const EdgeInsets.only(top: 24),
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GoogleMap(
                  myLocationButtonEnabled: false,
                  markers: {
                    Marker(
                      markerId: MarkerId(story?.name ?? ''),
                      infoWindow: InfoWindow(
                        title: locationName ?? locationAddress,
                        snippet: locationName != null ? locationAddress : null,
                      ),
                      position: LatLng(
                        story?.lat?.toDouble() ?? 0.0,
                        story?.lon?.toDouble() ?? 0.0,
                      ),
                    )
                  },
                  initialCameraPosition: CameraPosition(
                    zoom: 18,
                    target: LatLng(
                      story?.lat?.toDouble() ?? 0.0,
                      story?.lon?.toDouble() ?? 0.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
