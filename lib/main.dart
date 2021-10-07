import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tour/providers/auth.provider.dart';
import 'package:tour/providers/firestore.provider.dart';
import 'package:tour/views/login/login.dart';
import 'package:tour/views/map.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: 'recaptcha-v3-site-key');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
        Provider<FirestoreProvider>(
          create: (_) => FirestoreProvider(FirebaseFirestore.instance),
        ),
      ],
      child: MaterialApp(
        title: 'Tourism & Placer',
        theme: ThemeData.dark(),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return Scaffold(
          appBar: AppBar(
            title: const Text("Tourism & Placer"),
            actions: [
              IconButton(
                  onPressed: () {
                    context.read<AuthenticationProvider>().signOut();
                  },
                  icon: const Icon(Icons.logout))
            ],
          ),
          body:
              const AnimatedTourMap() // This trailing comma makes auto-formatting nicer for build methods.
          );
    }
    return const Login();
  }
}
