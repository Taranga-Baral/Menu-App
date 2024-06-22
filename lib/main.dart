import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:final_menu/login_screen/sign_up_page.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
   if(kIsWeb){
      WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: "AIzaSyCrHL5E_oHQjng6ApZza8TGqx1CxxKH7vM",

  authDomain: "menu-app-8cced.firebaseapp.com",

  projectId: "menu-app-8cced",

  storageBucket: "menu-app-8cced.appspot.com",

  messagingSenderId: "387296614571",

  appId: "1:387296614571:web:f19599ed85e2d017b73fee"
));
   }else{
     await  Firebase.initializeApp();
   }
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RegistrationPage(),
  ));
}

