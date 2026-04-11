import 'package:flutter/material.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  await dotenv.load();
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    // ignore: avoid_print
    print('[[32m[1m[0m${record.level.name}] ${record.time}: ${record.message}');
  });
  final log = Logger('Main');
  if (dotenv.env['DEVELOPMENT_MODE'] == 'true') {
    log.info('API_BASE_URL: ${dotenv.env['API_BASE_URL']}');
    log.info('API_BASE_URL_PROD: ${dotenv.env['API_BASE_URL_PROD']}');
  }
  runApp(const PatunganApp());
}
