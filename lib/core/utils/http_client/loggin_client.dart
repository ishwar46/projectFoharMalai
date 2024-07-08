import 'package:http/http.dart' as http;
import 'dart:convert';

class LoggingClient extends http.BaseClient {
  final http.Client _inner;

  LoggingClient(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    _printRequest(request);

    final response = await _inner.send(request);

    return response.stream.bytesToString().then((body) {
      _printResponse(response, body);
      final stream = http.ByteStream.fromBytes(utf8.encode(body));
      return http.StreamedResponse(stream, response.statusCode,
          headers: response.headers,
          reasonPhrase: response.reasonPhrase,
          contentLength: response.contentLength,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          request: response.request);
    });
  }

  void _printRequest(http.BaseRequest request) {
    final buffer = StringBuffer();
    buffer.writeln(
        '══════════════════════════ Request ══════════════════════════');
    buffer.writeln('Method: ${request.method}');
    buffer.writeln('URL: ${request.url}');
    buffer.writeln('Headers:\n${_formatJson(request.headers)}');
    if (request is http.Request) {
      buffer.writeln('Body:\n${_prettyJson(request.body)}');
    }
    buffer.writeln(
        '════════════════════════ End of Request ═════════════════════\n');
    print(buffer.toString());
  }

  void _printResponse(http.StreamedResponse response, String body) {
    final buffer = StringBuffer();
    buffer.writeln(
        '═════════════════════════ Response ══════════════════════════');
    buffer.writeln('Status Code: ${response.statusCode}');
    buffer.writeln('Reason Phrase: ${response.reasonPhrase}');
    buffer.writeln('Headers:\n${_formatJson(response.headers)}');
    buffer.writeln('Body:\n${_prettyJson(body)}');
    buffer.writeln(
        '═══════════════════════ End of Response ═════════════════════\n');
    print(buffer.toString());
  }

  String _formatJson(Map<String, String> json) {
    return const JsonEncoder.withIndent('  ').convert(json);
  }

  String _prettyJson(String jsonString) {
    try {
      final jsonObj = jsonDecode(jsonString);
      final prettyString = const JsonEncoder.withIndent('  ').convert(jsonObj);
      return prettyString;
    } catch (e) {
      return jsonString;
    }
  }
}
