import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:radar/pages/auth/sign_up_page.dart';

import '../../main.dart';

class SignInPage extends StatelessWidget {
  final VoidCallback onSignIn;

  const SignInPage({Key? key, required this.onSignIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String email = '';
    String password = '';

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value ?? '';
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState?.save();
                  // Perform Sign In logic here
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2:5001/login'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      'email': email,
                      'password': password,
                    }),
                  );

                  if (response.statusCode == 200) {
                    // Login successful
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            MainPage(onLogout: () {}),
                      ),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${response.body}')),
                    );
                  }
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  // Navigate to Sign Up page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SignUpPage(),
                    ),
                  );
                },
                child: const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:radar/pages/auth/sign_up_page.dart';
//
// import '../../main.dart';
//
// class SignInPage extends StatelessWidget {
//   final VoidCallback onSignIn;
//
//   const SignInPage({Key? key, required this.onSignIn}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//     String email = '';
//     String password = '';
//
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Card(
//                 elevation: 8,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Form(
//                     key: _formKey,
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Text(
//                           'Sign In',
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2193b0),
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Email',
//                             prefixIcon: const Icon(Icons.email),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your email';
//                             } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//                               return 'Please enter a valid email';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             email = value ?? '';
//                           },
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Password',
//                             prefixIcon: const Icon(Icons.lock),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           obscureText: true,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your password';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             password = value ?? '';
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         ElevatedButton(
//                           onPressed: () async {
//                             _formKey.currentState?.save();
//                             final response = await http.post(
//                               Uri.parse('http://10.0.2.2:5001/login'),
//                               headers: <String, String>{
//                                 'Content-Type': 'application/json',
//                               },
//                               body: jsonEncode({
//                                 'email': email,
//                                 'password': password,
//                               }),
//                             );
//
//                             if (response.statusCode == 200) {
//                               Navigator.pushReplacement(
//                                 context,
//                                 MaterialPageRoute<void>(
//                                   builder: (BuildContext context) =>
//                                       MainPage(onLogout: () {}),
//                                 ),
//                               );
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Error: ${response.body}')),
//                               );
//                             }
//                           },
//                           style: ElevatedButton.styleFrom(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 12,
//                               horizontal: 48,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             backgroundColor: const Color(0xFF8E2DE2), // Use this instead of primary
//                           ),
//                           child: const Text(
//                             'Sign In',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute<void>(
//                                 builder: (BuildContext context) => const SignUpPage(),
//                               ),
//                             );
//                           },
//                           child: const Text(
//                             "Don't have an account? Sign Up",
//                             style: TextStyle(color: Color(0xFF2193b0)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
