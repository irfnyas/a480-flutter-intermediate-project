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

  int pageSize = 10;
  int currentPage = 0;
  bool isLastPage = false;

  Future<void> fetchData({bool? init}) async {
    if (init == true) {
      currentPage = 0;
      isLastPage = false;
    }

    if (isLastPage) return;

    final currentStories = resultState is ViewLoadedState && init != true
        ? (resultState as ViewLoadedState).stories ?? <Story>[]
        : <Story>[];

    final newStories = [...currentStories];
    currentPage++;

    try {
      if (currentPage == 1) resultState = ViewLoadingState();
      final result = await apiService.getStories(
        size: pageSize,
        page: currentPage,
      );

      resultState = result.error == true
          ? ViewErrorState(result.message ?? '')
          : ViewLoadedState(
              stories: newStories..addAll(result.listStory ?? []));

      isLastPage = (result.listStory ?? []).length < pageSize;
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
