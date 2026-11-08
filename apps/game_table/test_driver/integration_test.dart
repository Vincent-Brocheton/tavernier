// Pilote de `flutter drive` pour les tests d'intégration sur le Web.
//
// Comme `integrationDriver`, mais le rapport (`reportData`) est écrit même en
// cas d'échec : `flutter drive` n'affiche pas le message d'une erreur, et le
// rapport est le seul moyen de savoir où un test s'est arrêté.
import 'dart:convert';
import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/common.dart';
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() async {
  final driver = await FlutterDriver.connect();
  final json = await driver.requestData(
    null,
    timeout: const Duration(minutes: 20),
  );
  final response = Response.fromJson(json);
  await driver.close();
  await writeResponseData(response.data);
  if (!response.allTestsPassed) {
    stderr.writeln(response.formattedFailureDetails);
    stderr.writeln(const JsonEncoder.withIndent('  ').convert(response.data));
    exit(1);
  }
}
