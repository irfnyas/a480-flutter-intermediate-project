import '../data/model/story_model.dart';

sealed class ViewResultState {}

class ViewNoneState extends ViewResultState {}

class ViewLoadingState extends ViewResultState {}

class ViewErrorState extends ViewResultState {
  ViewErrorState(this.error);
  final String error;
}

class ViewLoadedState extends ViewResultState {
  ViewLoadedState({this.stories, this.story});
  final List<Story>? stories;
  final Story? story;
}
