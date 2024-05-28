// otp_ver_page.dart

import 'package:flutter/material.dart';
import 'package:score/pages/home_page.dart';

class OTPVerPage extends StatefulWidget {
  const OTPVerPage({super.key});

  @override
  _OTPVerPageState createState() => _OTPVerPageState();
}

class _OTPVerPageState extends State<OTPVerPage> {
  final List<TextEditingController> otpControllers =
      List.generate(4, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'VERIFY',
          style: TextStyle(color: Color.fromARGB(255, 15, 66, 107),fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 50.0,
                  child: TextField(
                    controller: otpControllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20.0, color: Colors.black),
                    maxLength: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
               style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 15, 66, 107),
                  foregroundColor: Colors.white,
                ),
              onPressed: () {
                // Handle OTP submission logic here

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
                String otp = '';
                for (var controller in otpControllers) {
                  otp += controller.text;
                }
                // ignore: avoid_print
                print('Entered OTP: $otp');
              },
             
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
