import 'package:urban_gardening/authentication/authservice.dart';
import 'package:urban_gardening/authentication/forgot_pass.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  bool _obscureText = true;

  final passwordController = TextEditingController();
  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      showErrorMessage(e.code);
    }
  }

  void showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue,
          title: Center(
              child: Text(
            message,
            style: GoogleFonts.poppins(color: Colors.white),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Gap(100),
              Text(
                'Login Here',
                style: GoogleFonts.poppins(
                    color: Color.fromRGBO(31, 65, 187, 1),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Gap(20),
              Text(
                'Welcome back you\'v been missed!',
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    fillColor: Color.fromRGBO(241, 244, 255, 1),
                    hintText: "Email",
                    hintStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    filled: true,
                    prefixIcon: const Icon(Icons.mail),
                  ),
                ),
              ),
              Gap(30),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    fillColor: Color.fromRGBO(241, 244, 255, 1),
                    hintText: "Password",
                    hintStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none),
                    filled: true,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.remove_red_eye
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                  obscureText: _obscureText,
                ),
              ),
              Gap(20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (content) {
                        return ForgotPassword();
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 210),
                  child: Text(
                    "Forgot Your Password?",
                    style: GoogleFonts.poppins(
                      color: Color.fromRGBO(31, 65, 187, 1),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Gap(30),
              GestureDetector(
                onTap: signUserIn,
                child: Container(
                  width: 370,
                  height: 50,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(31, 65, 187, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Gap(40),
              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or Continue with',
                        style: GoogleFonts.poppins(
                            color: Color.fromRGBO(73, 73, 73, 1),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(30),
              GestureDetector(
                  onTap: () => AuthService().signInWithGoogle(),
                  child: Container(
                    width: 80,
                    height: 80,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(236, 236, 236, 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/image.png',
                        width: 50,
                      ),
                    ),
                  )),
              Gap(30),
              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: GoogleFonts.poppins(
                        fontSize: 18, color: Color.fromRGBO(73, 73, 73, 1)),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(31, 65, 187, 1),
                        //fontWeight: FontWeight.,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
