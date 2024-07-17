import 'package:ass2/SignUpScreen.dart';
import 'package:ass2/provider/Location_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ass2/SQLite/database_helper.dart'; 
import 'package:ass2/provider/store_provider.dart'; 

void main() async {
  // Ensure that the Flutter binding is initialized before initializing the database
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize the database helper
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.getDatabase(); // Ensure that the database is initialized

   runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()), 
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SignUpScreen(), 
    );
  }
}
