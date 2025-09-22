import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/env/.env.production");
  runApp(const MyApp(flavor: "production"));
}
