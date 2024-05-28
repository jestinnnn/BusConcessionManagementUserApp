import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:score/utils/constants.dart';

void showmessage(String message) {
  Fluttertoast.showToast(
      msg: message, backgroundColor: Color.fromARGB(255, 15, 66, 107), textColor: wh, fontSize: 16.0);
}

ShowLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Builder(
      builder: (context) {
        return SizedBox(
          width: 100,
          height: 100,
          child: Column(
            children: [
              CircularProgressIndicator(
                color:  Color.fromARGB(255, 15, 66, 107),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                margin: EdgeInsets.only(left: 7),
                child: Text("loading"),
              )
            ],
          ),
        );
      },
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return alert;
    },
  );
}

String getMessageFromErrorCode(String errorCode) {
  switch (errorCode) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
      return "email alrady in use go to log in page";
    case "account-exists-with-different-credential":
      return "email alrady in use go to log in page";
    case "email-already-in-use":
      return "email alrady in use go to log in page";

    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";

    case "ERROR_USER_NOT_FOUND":
      return "no user found with this email.";
    case "user-not-found":
      return "No user found with this email.";

    case "ERROR_USER_DISABLED":
      return "User disabled.";
    case "user-disabled":
      return "User disabled.";

    case "ERROR_TOO_MANY_REQUESTS":
      return "Too many requests to log into this account.";
    case "operation-not-allowed":
      return "Too many requests to log into this account.";

    case "ERROR_OPERATION_NOT_ALLOWED":
      return "Too many requests to log into this account.";

    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";

    default:
      return "Login failed. Please try again.";
  }
}

bool loginValidation(String email, String password) {
  if (email.isEmpty) {
    showmessage("email is empty");
    return true;
  } else if (password.isEmpty) {
    showmessage("password is empty");
    return false;
  } else if (password.isEmpty && email.isEmpty) {
    showmessage("email and password is empty");
    return false;
  } else {
    return true;
  }
}

bool signinValidation(
    String email, String password, String name, String phone) {
  if (email.isEmpty) {
    showmessage("email is empty");
    return true;
  } else if (password.isEmpty) {
    showmessage("password is empty");
    return false;
  } else if (password.isEmpty && email.isEmpty) {
    showmessage("email and password is empty");
    return false;
  } else {
    return true;
  }
}

//constants.dart

ButtonStyle stewbh = ElevatedButton.styleFrom(
    backgroundColor: Color.fromARGB(255, 15, 66, 107),
    foregroundColor: wh,
    side: const BorderSide(color: bl, width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    minimumSize: const Size.fromHeight(60));

void showCustomDialog(
    {required BuildContext context,
    required String content,
    required String buttonText,
    required Widget navigateFrom,
    required String title}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,style:TextStyle(color: Color.fromARGB(255, 15, 66, 107)),),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => navigateFrom),
              );
            },
            child: Text(buttonText,style:TextStyle(color: Color.fromARGB(255, 15, 66, 107)),),
          ),
        ],
      );
    },
  );
}

Future<void> delayedFlow() async {
  print('Before delay');
  await Future.delayed(Duration(seconds: 3));
  print('After delay');
}
