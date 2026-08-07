import 'package:flutter/material.dart';

import 'app/app.dart';
import 'services/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Services.initialize();

  runApp(const PrivityDrinkApp());
}
