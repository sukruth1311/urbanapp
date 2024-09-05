// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:google_fonts/google_fonts.dart';

// class ForgotPassword extends StatefulWidget {
//   const ForgotPassword({super.key});

//   @override
//   State<ForgotPassword> createState() => _ForgotPasswordState();
// }

// class _ForgotPasswordState extends State<ForgotPassword> {
//   final emailController = TextEditingController();

//   @override
//   void dispose() {
//     emailController.dispose();
//     super.dispose();
//   }

//   Future PassReset() async {
//     try {
//       await FirebaseAuth.instance
//           .sendPasswordResetEmail(email: emailController.text.trim());
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Success"),
//             content: Text("Password reset link sent successfully."),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     } on FirebaseAuthException catch (e) {
//       String message;
//       if (e.code == 'user-not-found') {
//         message = "No user found for that email.";
//       } else {
//         message = e.message ?? "An error occurred. Please try again.";
//       }
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text("Error"),
//             content: Text(message),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text("OK"),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Color.fromRGBO(31, 65, 187, 1),
//         title: Text(
//           "Reset Your Password",
//           style: GoogleFonts.poppins(color: Colors.white),
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               "Enter Your Email to Reset Your Password",
//               style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
//             ),
//             Gap(50),
//             Padding(
//               padding: const EdgeInsets.only(left: 20, right: 20),
//               child: TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   fillColor: Color.fromRGBO(241, 244, 255, 1),
//                   hintText: "Email",
//                   hintStyle: GoogleFonts.poppins(),
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: BorderSide.none),
//                   filled: true,
//                   prefixIcon: const Icon(Icons.mail),
//                 ),
//               ),
//             ),
//             Gap(50),
//             MaterialButton(
//               onPressed: PassReset,
//               child: Text(
//                 'Reset Password',
//                 style: GoogleFonts.poppins(
//                     color: Color.fromRGBO(255, 255, 255, 1)),
//               ),
//               color: Color.fromRGBO(31, 65, 187, 1),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> PassReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("Password reset link sent successfully."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
      } else {
        message = e.message ?? "An error occurred. Please try again.";
      }
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(31, 65, 187, 1),
        title: Text(
          "Reset Your Password",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Enter Your Email to Reset Your Password",
              style: GoogleFonts.poppins(color: Colors.black, fontSize: 16),
            ),
            Gap(50),
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
            Gap(50),
            MaterialButton(
              onPressed: PassReset,
              child: Text(
                'Reset Password',
                style: GoogleFonts.poppins(
                    color: Color.fromRGBO(255, 255, 255, 1)),
              ),
              color: Color.fromRGBO(31, 65, 187, 1),
            ),
          ],
        ),
      ),
    );
  }
}
