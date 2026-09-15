library;

import 'package:jaspr/client.dart';

import 'di/injector.dart';
import 'main.client.options.dart';

void main() {
  Jaspr.initializeApp(
    options: defaultClientOptions,
  );

  configureDependencies();

  runApp(const ClientApp());
}
