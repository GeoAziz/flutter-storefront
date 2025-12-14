import 'dart:convert';

import 'package:http/http.dart' as http;

/// Lightweight HTTP client wrapper used by repositories.
class ApiClient {
  ApiClient({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Uri _uri(String path) => Uri.parse(baseUrl + path);

  /// GET JSON from [path]. Returns decoded JSON (dynamic).
  /// Throws [http.ClientException] for non-200 responses.
  Future<dynamic> getJson(String path) async {
    final res = await _client.get(_uri(path), headers: {
      'Accept': 'application/json',
    });

    if (res.statusCode != 200) {
      throw http.ClientException(
          'Request failed with status ${res.statusCode}', _uri(path));
    }

    return json.decode(res.body);
  }

  void dispose() {
    try {
      _client.close();
    } catch (_) {}
  }
}
