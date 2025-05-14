 import 'package:flutter/material.dart';
 import 'package:flutter/gestures.dart';
import 'package:meal_app/view/screens/Login_Signup/Signup/signup.dart';
import 'package:meal_app/view/screens/Login_Signup/forget_password/reset_password/reset_password_email.dart';
 class LoginScreen extends StatefulWidget {
   const LoginScreen({super.key});

   @override
   State<LoginScreen> createState() => _LoginScreenState();
 }

 class _LoginScreenState extends State<LoginScreen> {
   bool rememberMe = false;

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.white,
       body: Column(
         children: [
           ClipPath(
             clipper: TopWaveClipper(),
             child: Container(
               color: Colors.green,
               height: 200,
               width: double.infinity,

             ),
           ),

           Expanded(
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 24.0),
               child: ListView(
                 children: [
                   const SizedBox(height: 10),

                   const Text(
                     'Login',
                     style: TextStyle(
                       fontSize: 28,
                       fontWeight: FontWeight.bold,
                     ),
                   ),

                   const SizedBox(height: 10),
                   const Divider(thickness: 2, color: Colors.green, endIndent: 250),
                   const SizedBox(height: 30),
                   const Text('Email'),
                   const SizedBox(height: 8),
                   TextField(
                     decoration: InputDecoration(
                       hintText: 'ahmad@email.com',
                       prefixIcon: Icon(Icons.email_outlined),
                       border: UnderlineInputBorder(),
                       focusedBorder: UnderlineInputBorder(
                         borderSide: BorderSide(color: Colors.green),
                       ),
                     ),
                   ),

                   const SizedBox(height: 20),
                   const Text('Password'),
                   const SizedBox(height: 8),
                   TextField(
                     obscureText: true,
                     decoration: InputDecoration(
                       hintText: 'Enter your password',
                       prefixIcon: Icon(Icons.lock_outline),
                       suffixIcon: Icon(Icons.visibility_outlined),
                       border: UnderlineInputBorder(),
                       focusedBorder: UnderlineInputBorder(
                         borderSide: BorderSide(color: Colors.green),
                       ),
                     ),
                   ),

                   const SizedBox(height: 15),

                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Row(
                         children: [
                           Checkbox(
                             activeColor: Colors.green,
                             value: rememberMe,
                             onChanged: (val) {
                               setState(() {
                                 rememberMe = val!;
                               });
                             },
                           ),
                           const Text("Remember Me"),
                         ],
                       ),
                       TextButton(
                         onPressed: () {
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => const ResetPasswordEmail()),
                           );
                         },
                         child: const Text(
                           "Forgot Password ?",
                           style: TextStyle(color: Colors.green),
                         ),

                       ),

                     ],
                   ),

                   const SizedBox(height: 20),
                   SizedBox(
                     width: double.infinity,
                     height: 48,
                     child: ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.green,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                       onPressed: () {
                       },
                       child: const Text("Login"),
                     ),
                   ),

                   const SizedBox(height: 20),

                   Center(
                     child: RichText(
                       text: TextSpan(
                         style: const TextStyle(color: Colors.black),
                         children: [
                           const TextSpan(text: "Don't have an Account? "),
                           TextSpan(
                             text: "Sign up",
                             style: const TextStyle(
                               color: Colors.green,
                               fontWeight: FontWeight.bold,
                             ),
                             recognizer: TapGestureRecognizer()
                               ..onTap = () {
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => const SignUpScreen()),
                                 );
                               },
                           ),

                         ],
                       ),
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ],
       ),
     );
   }
 }
 class TopWaveClipper extends CustomClipper<Path> {
   @override
   Path getClip(Size size) {
     var path = Path();
     path.lineTo(0, size.height - 50);

     var controlPoint = Offset(size.width / 2, size.height);
     var endPoint = Offset(size.width, size.height - 50);

     path.quadraticBezierTo(
       controlPoint.dx,
       controlPoint.dy,
       endPoint.dx,
       endPoint.dy,
     );

     path.lineTo(size.width, 0);
     path.close();
     return path;
   }

   @override
   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
 }
