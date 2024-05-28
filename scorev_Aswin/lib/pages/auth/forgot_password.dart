import 'package:flutter/material.dart';
import 'package:score/pages/auth/otp_ver_page.dart';
import 'package:score/utils/constants.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wh,
      appBar: AppBar(
        title: const Text(
          'VERIFICATION',
          style: TextStyle(color:Color.fromARGB(255, 15, 66, 107),fontWeight: FontWeight.bold),
        ),
        backgroundColor: wh,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your mobile number for verification : ',
              style: TextStyle(fontSize: 18.0, color:  Color.fromARGB(255, 15, 66, 107)),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: mobileController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: bl,
              ),
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              
              
               style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 15, 66, 107),
                  foregroundColor: wh,
                ),
              onPressed: () {
                // Handle mobile number verification logic here
                //String mobileNumber = mobileController.text;
                // Implement logic to send a verification code to the provided number
                //print('Verification code sent to $mobileNumber');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OTPVerPage(),
                  ),
                );
              },
              child: const Text('Send Verification Code'),
            ),
          ],
        ),
      ),
    );
  }
}
