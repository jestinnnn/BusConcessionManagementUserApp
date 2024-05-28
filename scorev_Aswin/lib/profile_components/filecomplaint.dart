import 'package:flutter/material.dart';
import 'package:score/constants/constants.dart';

import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';

import 'package:score/pages/profile_page.dart';

import 'package:score/utils/constants.dart';

class File_complaint extends StatefulWidget {
  const File_complaint({super.key});

  @override
  State<File_complaint> createState() => complaint();
}

class complaint extends State<File_complaint> {
  TextEditingController title = TextEditingController();

  TextEditingController body = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("COMPLAINTS",style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),),),
      body: Container(
        color: wh,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Welcome Text
                  const Text(
                    'FIle a Complaint ',
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
                    controller: title,
                    decoration: const InputDecoration(
                      labelText: 'title',
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
                        return 'Please enter title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  // Password TextField
                  TextFormField(
                    controller: body,
                    keyboardType: TextInputType.multiline,
                  
                    maxLines: 8,
                    decoration: const InputDecoration(
                      labelText: 'content',
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
                        return 'Please enter your content';
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
                        await FirebaseFirestoreHelper.instance
                            .Register_Complaint(title.text, body.text);
            
                        showCustomDialog(
                            context: context,
                            content: "Complaint Registered sucessfully",
                            buttonText: "OK",
                            navigateFrom: ProfilePage(),
                            title: "NOTE");
                      }
                    },
                   
                    child: const Text('REGISTER',style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20.0),
            
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
