import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../model/api_response_model.dart';
import 'cache_service.dart';

class ApiService {
  ApiService(this.cacheService);
  final CacheService cacheService;

  static const String baseUrl = 'https://story-api.dicoding.dev/v1';
  static const String imageUrl = 'https://story-api.dicoding.dev/images';

  static const String exceptionMessage =
      'Sorry we\'re having trouble connecting you to our side right now. Please try again later.';

  Future<Map<String, String>> get headers async {
    final token = await cacheService.getString(CacheService.kCacheToken);
    return {'Authorization': 'Bearer $token'};
  }

  Future<ApiResponse> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );
    final knownCodes = [200, 401];
    if (!knownCodes.contains(response.statusCode)) {
      throw Exception(exceptionMessage);
    }

    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    final knownCodes = [201, 400];
    if (!knownCodes.contains(response.statusCode)) {
      throw Exception(exceptionMessage);
    }

    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> postStory(
    String description,
    String fileName,
    Uint8List fileBytes, {
    num? lat,
    num? lon,
  }) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/stories'),
    );

    final file = http.MultipartFile.fromBytes(
      'photo',
      fileBytes,
      filename: fileName,
    );

    final fields = {'description': description};
    if (lat != null) fields.addAll({'lat': '$lat'});
    if (lon != null) fields.addAll({'lon': '$lon'});

    request.headers.addAll(await headers);
    request.fields.addAll(fields);
    request.files.add(file);

    final streamedResponse = await request.send();
    final statusCode = streamedResponse.statusCode;

    final responseList = await streamedResponse.stream.toBytes();
    final responseData = String.fromCharCodes(responseList);

    final knownCodes = [201, 400];
    if (!knownCodes.contains(statusCode)) {
      throw Exception(exceptionMessage);
    }

    return ApiResponse.fromJson(jsonDecode(responseData));
  }

  Future<ApiResponse> getStories({int? page, int? size, int? location}) async {
    final queryParameters = {
      'page': page != null ? '$page' : null,
      'size': size != null ? '$size' : null,
      'location': location != null ? '$location' : null,
    };

    final response = await http.get(
      Uri.parse('$baseUrl/stories').replace(queryParameters: queryParameters),
      headers: await headers,
    );
    if (response.statusCode != 200) throw Exception(exceptionMessage);

    return ApiResponse.fromJson(jsonDecode(response.body));
  }

  Future<ApiResponse> getStory(String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories/$id'),
      headers: await headers,
    );
    if (response.statusCode != 200) throw Exception(exceptionMessage);

    return ApiResponse.fromJson(jsonDecode(response.body));
  }
}
