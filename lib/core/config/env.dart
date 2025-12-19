class Env {
  final String baseUrl;
  final bool enableHttpLog;

  const Env({required this.baseUrl, required this.enableHttpLog});

  // örnek: local
  const Env.dev() : baseUrl = 'http://localhost:5000', enableHttpLog = true;

  // örnek: prod
  const Env.prod() : baseUrl = 'https://api.fisly.app', enableHttpLog = false;
}
