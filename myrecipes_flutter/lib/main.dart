import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myrecipes_flutter/enviroment_config.dart';
import 'package:myrecipes_flutter/simple_bloc_observer.dart';

import 'presentation/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (EnvironmentConfig.ALLOW_BAD_CERTIFICATE) {
    HttpOverrides.global = _HttpOverrides();
  }
  Bloc.observer = SimpleBlocObserver();
  EquatableConfig.stringify = true;
  runApp(App());
}

// HttpOverrides to see the http(s) traffic in Charles Proxy.
// Requirements:
// - Charles Proxy www.charlesproxy.com
// - SSL certificate on your Device (Android only). In Charles go to Help -> SSL Proxying -> Install Cert on mobile Device
// ignore: unused_element
class _HttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    final HttpClient client = super.createHttpClient(context);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return client;
  }
}
