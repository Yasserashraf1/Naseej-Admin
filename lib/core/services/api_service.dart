import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Get headers with auth token
  Map<String, String> _getHeaders() {
    final token = StorageService.getToken();
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Get headers for multipart
  Map<String, String> _getMultipartHeaders() {
    final token = StorageService.getToken();
    final headers = <String, String>{};

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {'status': 'error', 'message': 'Invalid response format'};
      }
    } else if (response.statusCode == 401) {
      return {'status': 'error', 'message': AppConstants.unauthorizedMessage};
    } else if (response.statusCode == 404) {
      return {'status': 'error', 'message': AppConstants.notFoundMessage};
    } else {
      return {
        'status': 'error',
        'message': 'Server error: ${response.statusCode}'
      };
    }
  }

  // GET request
  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await http
          .get(
        Uri.parse(url),
        headers: _getHeaders(),
      )
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': AppConstants.networkErrorMessage};
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(String url, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: _getHeaders(),
        body: jsonEncode(data),
      )
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': AppConstants.networkErrorMessage};
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }

  // POST request with form data
  Future<Map<String, dynamic>> postForm(
      String url, Map<String, String> data) async {
    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data,
      )
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': AppConstants.networkErrorMessage};
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(String url, Map<String, dynamic> data) async {
    try {
      final response = await http
          .put(
        Uri.parse(url),
        headers: _getHeaders(),
        body: jsonEncode(data),
      )
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': AppConstants.networkErrorMessage};
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String url) async {
    try {
      final response = await http
          .delete(
        Uri.parse(url),
        headers: _getHeaders(),
      )
          .timeout(AppConstants.connectionTimeout);

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': AppConstants.networkErrorMessage};
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }

  // Upload file with multipart
  Future<Map<String, dynamic>> uploadFile(
      String url,
      File file,
      String fieldName, {
        Map<String, String>? additionalFields,
      }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll(_getMultipartHeaders());

      // Add file
      request.files.add(
        await http.MultipartFile.fromPath(fieldName, file.path),
      );

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      // Send request
      final streamedResponse = await request.send()
          .timeout(AppConstants.connectionTimeout);

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': AppConstants.networkErrorMessage};
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }

  // Upload multiple files
  Future<Map<String, dynamic>> uploadMultipleFiles(
      String url,
      List<File> files,
      String fieldName, {
        Map<String, String>? additionalFields,
      }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll(_getMultipartHeaders());

      // Add files
      for (var file in files) {
        request.files.add(
          await http.MultipartFile.fromPath(fieldName, file.path),
        );
      }

      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      // Send request
      final streamedResponse = await request.send()
          .timeout(AppConstants.connectionTimeout);

      // Get response
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      return {'status': 'error', 'message': AppConstants.networkErrorMessage};
    } catch (e) {
      return {'status': 'error', 'message': 'Error: $e'};
    }
  }
}