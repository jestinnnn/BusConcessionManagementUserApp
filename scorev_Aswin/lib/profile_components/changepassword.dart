import 'package:flutter/material.dart';
import 'package:score/constants/constants.dart';
import 'package:score/constants/routes.dart';
import 'package:score/firebase_helper/firebase_auth_helper/firebaseauthhelper.dart';

import 'package:score/pages/home_page.dart';
import 'package:score/pages/profile_page.dart';

import 'package:score/utils/constants.dart';

class Change_pass extends StatefulWidget {
  const Change_pass({super.key});

  @override
  State<Change_pass> createState() => _ChngePass();
}

class _ChngePass extends State<Change_pass> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CHANGE PASSWORD",style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),),),
      body: Container(
        color: wh,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              
                const Text(
                  'Change Password ',
                  style: TextStyle(
                    color: Color.fromARGB(255, 15, 66, 107),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                // Username TextField
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: bl),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: bl),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: bl),
                    ),
                  ),
                  style: const TextStyle(color: bl),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                            r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // Password TextField
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: bl),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: bl),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: bl),
                    ),
                  ),
                  style: const TextStyle(color: bl),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: newpassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: bl),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: bl),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: bl),
                    ),
                  ),
                  style: const TextStyle(color: bl),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your new password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    } else if (password.text == newpassword.text) {
                      return 'Both the passwords are same';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                // Login Button
                ElevatedButton(

                  style:ElevatedButton.styleFrom(backgroundColor: 
                  
                  Color.fromARGB(255, 15, 66, 107)),
                  
            
                  
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      var a = await FirebaseAuthHelper.instance
                          .changePassword(newpassword.text);

                      if (a) {
                        showCustomDialog(
                            context: context,
                            content: "password changes sucessfully",
                            buttonText: "OK",
                            navigateFrom: ProfilePage(),
                            title: "NOTE");
                        Routes.instance.push(HomePage(), context);
                      } else {
                        showCustomDialog(
                            context: context,
                            content: "Error changing password",
                            buttonText: "OK",
                            navigateFrom: ProfilePage(),
                            title: "ALERT");
                        Routes.instance.push(HomePage(), context);
                      }
                    }
                  },
                
                  child: const Text('Change Password',style: TextStyle(color: Colors.white),),
                ),
                const SizedBox(height: 20.0),

                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
