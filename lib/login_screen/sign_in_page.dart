import 'package:final_menu/homepage.dart';
import 'package:final_menu/login_screen/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  bool _obscureText = true;
  Color _color = const Color.fromARGB(255, 189, 62, 228);

  void _signIn() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      setState(() {
        _color = _color == const Color.fromARGB(255, 189, 62, 228)
            ? const Color.fromARGB(255, 14, 199, 54)
            : const Color.fromARGB(255, 189, 62, 228);
      });

      // If sign in is successful
      if (userCredential.user != null) {
        // Show Snackbar
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign In Successful'),
            duration: Duration(seconds: 1),
          ),
        );

        // Navigate to HomePage after 1 second
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) =>
                    HomePage()), // Replace with your actual homepage widget
          );
        });
      }
    } catch (e) {
      print('Error signing in: $e');
      // Handle sign in errors here
      // Optionally show an error dialog to the user
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sign In Failed'),
          content: Text('Invalid email or password. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.2),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(24)),
          child: Container(
            height: screenHeight * 0.39,
            width: screenWidth,
            color: const Color.fromARGB(255, 200, 54, 244),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                const Image(
                  image: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/1847/1847250.png"),
                  height: 55,
                  width: 55,
                ),
                const SizedBox(
                  height: 12,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationPage()));
                  },
                  child: const Text(
                    " Not Yet IN? Sign Up Here.",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 14,
            ),
            Container(
              height: screenHeight * 0.99,
              width: screenWidth,
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color.fromARGB(255, 163, 66, 192),
                        fontSize: 38,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _controllerEmail,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: "Enter your E-mail",
                                prefixIcon: Icon(Icons.email),
                                hintText: "johndoe@gmail.com",
                                filled: true,
                                fillColor: Colors.white12,
                                prefixIconColor:
                                    Color.fromARGB(255, 187, 109, 201),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 182, 116, 194),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 200, 54, 244))),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)))),
                          ),
                          SizedBox(height: 30),
                          TextFormField(
                            controller: _controllerPassword,
                            obscureText: _obscureText,
                            decoration: InputDecoration(
                                labelText: "Enter your Password",
                                prefixIcon: const Icon(Icons.password),
                                filled: true,
                                fillColor: Colors.white12,
                                prefixIconColor:
                                    const Color.fromARGB(255, 187, 109, 201),
                                suffixIconColor:
                                    const Color.fromARGB(255, 180, 113, 192),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 182, 116, 194),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 200, 54, 244))),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)))),
                          ),
                          SizedBox(height: 38.0),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12)),
                            child: GestureDetector(
                              onTap: _signIn,
                              child: Container(
                                height: screenHeight * 0.07,
                                width: screenWidth,
                                color: _color,
                                child: const Center(
                                  child: Text(
                                    "Sign In",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 26,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          

SizedBox(
  height: 25,
),


                          Container(
              width: screenWidth * 0.9,
              padding: EdgeInsets.all(screenHeight * 0.02),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: const Color.fromARGB(255, 200, 54, 244), width: 2),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notice",
                    style: GoogleFonts.amaticSc(
                      fontSize: screenHeight * 0.04,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 200, 54, 244),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.008),
                  Text(
                    "We accept E-sewa, Khalti, IME Pay, Credit Card",
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
