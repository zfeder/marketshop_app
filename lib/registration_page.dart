import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:marketshop_app/auth_page.dart';
import 'package:marketshop_app/bottom_navigation_bar/account_bar.dart';
import 'package:marketshop_app/bottom_navigation_bar/home_bar.dart';
import 'package:marketshop_app/bottom_navigation_bar/item_bar.dart';
import 'package:marketshop_app/bottom_navigation_bar/store_market_bar.dart';
import 'package:marketshop_app/login_page.dart';
import 'components_login/my_button.dart';
import 'components_login/my_buttonReg.dart';
import 'components_login/my_textfield.dart';
import 'firebase_options.dart';


class RegPage extends StatefulWidget {
  const RegPage({super.key});

  @override
  State<RegPage> createState() => _RegPage();
}

class _RegPage extends State<RegPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn() async {

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      AutPage();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void LogPage() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: LoginPage(),
        );
      },
    );
  }

  void AutPage() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: AuthPage(),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // logo
              const Icon(
                Icons.account_circle,
                size: 100,
              ),


              // welcome back, you've been missed!
              Text(
                'Welcome new User!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),


              // email textfield
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
              ),


              // password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
              ),


              // sign in button
              MyButtonReg(
                onTap: signUserIn,
              ),


              // or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'Or continue with',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),


              // google + apple sign in buttons
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button



                  // apple button

                ],
              ),


              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  MyButton(
                    onTap: LogPage,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
// prova commit
}