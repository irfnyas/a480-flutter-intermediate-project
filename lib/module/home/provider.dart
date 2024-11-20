import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/story_model.dart';
import '../../data/service/api_service.dart';
import '../../data/service/cache_service.dart';
import '../../util/route.dart';
import '../../util/view_result_state.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider(
    this.apiService,
    this.cacheService,
  );

  final ApiService apiService;
  final CacheService cacheService;

  ViewResultState _resultState = ViewNoneState();
  ViewResultState get resultState => _resultState;
  set resultState(ViewResultState value) {
    _resultState = value;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      resultState = ViewLoadingState();
      final result = await apiService.getStories();
      resultState = result.error == true
          ? ViewErrorState(result.message ?? '')
          : ViewLoadedState(stories: result.stories ?? []);
    } on Exception catch (_) {
      resultState = ViewErrorState(ApiService.exceptionMessage);
    }
  }

  Future<void> logout(BuildContext context) async {
    await cacheService.clear();
    if (context.mounted) navToLogin(context);
  }

  void navToLogin(BuildContext context) {
    context.go(RouteEnum.login.name);
  }

  void navToPost(BuildContext context) {
    context.push(RouteEnum.post.name);
  }

  void navToDetail(BuildContext context, Story story) {
    context.push(RouteEnum.detail.name, extra: story);
  }
}
