import 'package:dockge_dashboard/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dockge_dashboard/core/storage/prefs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(overrides: [prefsProvider.overrideWithValue(prefs)], child: const Application()),
  );
}
