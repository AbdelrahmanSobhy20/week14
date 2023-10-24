import 'package:flutter/material.dart';
import 'package:to_do_application/todoprovider.dart';
import 'newpage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await TodoProvider.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NewPage(),
    );
  }
}
