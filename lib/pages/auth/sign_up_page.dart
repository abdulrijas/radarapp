import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:radar/main.dart';
import 'dart:convert';


class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String email = '';
    String password = '';
    // ignore: unused_local_variable
    String confirmPassword = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
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
                  } else if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value ?? '';
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value != password) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onSaved: (value) {
                  confirmPassword = value ?? '';
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  // if (_formKey.currentState?.validate() == true) {
                  _formKey.currentState?.save();
                  // Perform Sign Up logic here
                  final response = await http.post(
                    Uri.parse('http://10.0.2.2:5001/signup'),
                    headers: <String, String>{
                      'Content-Type': 'application/json',
                    },
                    body: jsonEncode({
                      'email': email,
                      'password': password,
                    }),
                  );

                  if (response.statusCode == 200) {
                    // Account created successfully
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
                  // }
                },
                child: const Text('Sign Up'),
              ),
              // TextButton(
              //   onPressed: () {
              //     // Navigate to Sign Up page
              //     Navigator.pushReplacement(context,
              //       MaterialPageRoute<void>(
              //         builder: (BuildContext context) => SignInPage(onSignIn: () {  },),
              //       ),);
              //   },
              //   child: const Text(" Sign Up"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

//
//
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:radar/main.dart';
// import 'dart:convert';
//
// class SignUpPage extends StatelessWidget {
//   const SignUpPage({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//     String email = '';
//     String password = '';
//     String confirmPassword = '';
//
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Card(
//                 elevation: 10,
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
//                           'Create Account',
//                           style: TextStyle(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF8E2DE2),
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
//                             } else if (value.length < 8) {
//                               return 'Password must be at least 8 characters long';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             password = value ?? '';
//                           },
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextFormField(
//                           decoration: InputDecoration(
//                             labelText: 'Confirm Password',
//                             prefixIcon: const Icon(Icons.lock_outline),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                           obscureText: true,
//                           validator: (value) {
//                             if (value != password) {
//                               return 'Passwords do not match';
//                             }
//                             return null;
//                           },
//                           onSaved: (value) {
//                             confirmPassword = value ?? '';
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         ElevatedButton(
//                           onPressed: () async {
//                             _formKey.currentState?.save();
//                             final response = await http.post(
//                               Uri.parse('http://10.0.2.2:5001/signup'),
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
//                             'Sign Up',
//                             style: TextStyle(fontSize: 18),
//                           ),
//                         ),
//                         const SizedBox(height: 16.0),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           child: const Text(
//                             'Already have an account? Sign In',
//                             style: TextStyle(color: Color(0xFF8E2DE2)),
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
