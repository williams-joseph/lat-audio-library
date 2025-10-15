import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'providers/sermon_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDkZaHzPGrbkW5Pzy4tT651_Gs2ZSWCCJw",
      authDomain: "sermons-app-d004a.firebaseapp.com",
      projectId: "sermons-app-d004a",
      storageBucket: "sermons-app-d004a.firebasestorage.app",
      messagingSenderId: "104319985691",
      appId: "1:104319985691:web:87844858dca0f6954eb0be"
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SermonProvider()),
      ],
      child: const SermonUserApp(),
    ),
  );
}