import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/auth/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reddit/auth/userContoller.dart';
import 'package:reddit/HomeScreen.dart';
import 'package:reddit/utils/LoderScreen.dart';
import 'package:reddit/utils/errorScreen.dart';
import 'package:reddit/utils/themeColor.dart';
import 'firebase_options.dart';

void main()async{WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(ProviderScope(child: const MyApp()));
}



class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context,WidgetRef ref ) {
    return MaterialApp(
      title: 'Reddit',
      theme: Pallete.darkModeAppTheme ,debugShowCheckedModeBanner: false,
      home: ref.watch(userDataAuthProvider).when(
            data: (user) {
              if(user==null){ 

          return LoginScreen();
              
            }        return TestDart(userId: user.uid, );

               
            },
            error: (err, trace) {
              ErrorScreen(message: err.toString());
            },
            loading: () {
              LoderScreen();
            }));
    
  }
}

