import 'package:flutter/material.dart';

import 'app/app.dart';
import 'services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Services.initialize();

  runApp(const PrivityDrinkApp());
}
