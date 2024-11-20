import 'package:flutter/material.dart';

import '../../data/service/api_service.dart';
import '../../util/view_result_state.dart';

class DetailProvider extends ChangeNotifier {
  DetailProvider(this.apiService);

  final ApiService apiService;

  ViewResultState _resultState = ViewNoneState();
  ViewResultState get resultState => _resultState;
  set resultState(ViewResultState value) {
    _resultState = value;
    notifyListeners();
  }

  Future<void> fetchData(String id) async {
    try {
      resultState = ViewLoadingState();
      final result = await apiService.getStory(id);
      resultState = result.error == true
          ? ViewErrorState(result.message ?? '')
          : ViewLoadedState(story: result.story);
    } on Exception catch (_) {
      resultState = ViewErrorState(ApiService.exceptionMessage);
    }
  }
}
