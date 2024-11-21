// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApiResponseImpl _$$ApiResponseImplFromJson(Map<String, dynamic> json) =>
    _$ApiResponseImpl(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      listStory: (json['listStory'] as List<dynamic>?)
          ?.map((e) => Story.fromJson(e as Map<String, dynamic>))
          .toList(),
      story: json['story'] == null
          ? null
          : Story.fromJson(json['story'] as Map<String, dynamic>),
      loginResult: _$recordConvertNullable(
        json['loginResult'],
        ($jsonValue) => (
          name: $jsonValue['name'] as String?,
          token: $jsonValue['token'] as String?,
          userId: $jsonValue['userId'] as String?,
        ),
      ),
    );

Map<String, dynamic> _$$ApiResponseImplToJson(_$ApiResponseImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'listStory': instance.listStory,
      'story': instance.story,
      'loginResult': instance.loginResult == null
          ? null
          : <String, dynamic>{
              'name': instance.loginResult!.name,
              'token': instance.loginResult!.token,
              'userId': instance.loginResult!.userId,
            },
    };

$Rec? _$recordConvertNullable<$Rec>(
  Object? value,
  $Rec Function(Map) convert,
) =>
    value == null ? null : convert(value as Map<String, dynamic>);
