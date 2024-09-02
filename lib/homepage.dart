// import 'package:final_menu/login_screen/sign_in_page.dart';
// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final String? message = ModalRoute.of(context)?.settings.arguments as String?;

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (message != null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(message),
//           ),
//         );
//       }
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Page'),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Text('Welcome to the Home Page!'),
//             ElevatedButton(onPressed: (){
//               Navigator.push(context, MaterialPageRoute(builder: (context)=> SignInPage()));
//             }, child: const Text("Sign-Out"))
//           ],
//         ),

//       ),
//     );
//   }
// }

import 'package:final_menu/login_screen/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String? message = ModalRoute.of(context)?.settings.arguments as String?;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (message != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to the Home Page!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut(); // Sign the user out
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                  (route) => false, // Remove all routes until SignInPage
                );
              },
              child: const Text("Sign-Out"),
            ),
          ],
        ),
      ),
    );
  }
}
