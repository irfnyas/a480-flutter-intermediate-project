import 'package:freezed_annotation/freezed_annotation.dart';

import 'story_model.dart';

part 'api_response_model.freezed.dart';
part 'api_response_model.g.dart';

@freezed
class ApiResponse with _$ApiResponse {
  const factory ApiResponse({
    final bool? error,
    final String? message,
    final List<Story>? listStory,
    final Story? story,
    final ({
      String? userId,
      String? name,
      String? token,
    })? loginResult,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(Map<String, Object?> json) =>
      _$ApiResponseFromJson(json);

  //

  // ApiResponse({
  //   this.error,
  //   this.message,
  //   this.stories,
  //   this.story,
  //   this.loginResult,
  // });

  // final bool? error;
  // final String? message;
  // final List<Story>? stories;
  // final Story? story;
  // final ({
  //   String? userId,
  //   String? name,
  //   String? token,
  // })? loginResult;

  // factory ApiResponse.fromJson(Map<String, dynamic> json) {
  //   return ApiResponse(
  //     error: json['error'],
  //     message: json['message'],
  //     stories:
  //         json['listStory'] == null ? null : Story.fromArray(json['listStory']),
  //     story: json['story'] == null ? null : Story.fromJson(json['story']),
  //     loginResult: json['loginResult'] == null
  //         ? null
  //         : (
  //             userId: json['loginResult']?['userId'],
  //             name: json['loginResult']?['name'],
  //             token: json['loginResult']?['token'],
  //           ),
  //   );
  // }
}
