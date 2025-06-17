class ApiConfig {
  final String endpoint;
  final String apiKey;

  ApiConfig({
    required this.endpoint,
    required this.apiKey,
  });

  factory ApiConfig.fromMap(Map<String, dynamic> map) {
    return ApiConfig(
      endpoint: map['endpoint'] ?? '',
      apiKey: map['apiKey'] ?? '',
    );
  }

  String get fullEndpoint => '$endpoint';
}
