import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class CustomHttpClient {
  static http.Client? _client;
  static http.Client get client => _client ??= http.Client();

  static init() async {
    _client = await instance;
  }

  static Future<http.Client> get instance async =>
      _client ??= await createSSLClient();

  static Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('certificates/certificates.cer');
    final securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  static Future<IOClient> createSSLClient() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    IOClient ioClient = IOClient(client);
    return ioClient;
  }
}