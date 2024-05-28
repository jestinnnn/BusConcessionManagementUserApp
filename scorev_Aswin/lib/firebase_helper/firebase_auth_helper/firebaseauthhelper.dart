import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:score/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthHelper {
  static FirebaseAuthHelper instance = FirebaseAuthHelper();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;

// Save an integer value to 'counter' key.

  Stream<User?> get getAuthChange => auth.authStateChanges();

  Future<bool> login(
      String email, String password, BuildContext context) async {
    try {
      ShowLoaderDialog(context);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      UserCredential usercredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      String Uid = usercredential.user!.uid;
      await prefs.setString('userid', Uid);
      await prefs.setString('email', email);

      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showmessage(e.code.toString());
      return false;
    }
  }

  Future<bool> signup(
      BuildContext context,
      String email,
      String password,
      String busstopnearinstitution,
      String course,
      String adress,
      String district,
      String institution,
      String bustype,
      String firstname,
      String lastname,
      String mobile,
      String boardinglocation,
      XFile adhar,
      XFile institutionid,
      XFile incomecirtificate,
      XFile photo,
      DateTime dob,
      String durationofcourse,
      int accademicyear) async {
    try {
      ShowLoaderDialog(context);
      UserCredential usercredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      String Uid = usercredential.user!.uid;

      await prefs.setString('userid', Uid);
      await prefs.setString('email', email);

      String Adharcard = await uploadFileToStorage(adhar, "adhar", Uid);
      String Incomecirtificate = await uploadFileToStorage(
          incomecirtificate, "incomecirtificate", Uid);
      String Idcard = await uploadFileToStorage(institutionid, "idcard", Uid);
      String Photo = await uploadFileToStorage(photo, "photo", Uid);
      await prefs.setString('photo', Photo);

      await store.collection("users").doc(Uid).set({
        "id": Uid,
        "firstname": firstname,
        "lastname": lastname,
        "phonenumber": mobile,
        "email": email,
        "adharcard": Adharcard,
        "institutionid": Idcard,
        "incomecirtificate": Incomecirtificate,
        "photo": Photo,
        "boardinglocation": boardinglocation,
        "district": district,
        "institution": institution,
        "bustype": bustype,
        "course": course,
        "collegebusstoplocation": busstopnearinstitution,
        "adress": adress,
      });
      await store
          .collection("users")
          .doc(Uid)
          .collection("boardingRequest")
          .doc(Uid)
          .set({
        "id": Uid,
        // ignore: prefer_interpolation_to_compose_strings
        "name": firstname + " " + lastname,
        "phonenumber": mobile,
        "email": email,
        "adharcard": Adharcard,
        "institutionid": Idcard,
        "incomecirtificate": Incomecirtificate,
        "photo": Photo,
        "boardinglocation": boardinglocation,
        "district": district,
        "institution": institution,
        "bustype": bustype,
        "course": course,
        "collegebusstoplocation": busstopnearinstitution,
        "adress": adress,
        "status": "pending",
        "dob": dob.toString().substring(0, 11),
        "durationofcourse": durationofcourse,
        "message": "null",
        "price": "0",
        "accademicYear": accademicyear.toString(),
        "dateofissue": "null",
        "dateofexpiry": "null"
      });
      await store.collection("boardingrequestinstitution").doc(Uid).set({
        "id": Uid,
        // ignore: prefer_interpolation_to_compose_strings
        "name": firstname + " " + lastname,
        "phonenumber": mobile,
        "email": email,
        "adharcard": Adharcard,
        "institutionid": Idcard,
        "incomecirtificate": Incomecirtificate,
        "photo": Photo,
        "boardinglocation": boardinglocation,
        "district": district,
        "institution": institution,
        "bustype": bustype,
        "course": course,
        "collegebusstoplocation": busstopnearinstitution,
        "adress": adress,
        "status": "pending",
        "dob": dob.toString().substring(0, 11),
        "durationofcourse": durationofcourse,
        "message": "null",
        "price": "0",
        "accademicYear": accademicyear.toString(),
        "dateofissue": "null",
        "dateofexpiry": "null",
        "dateofapply": DateTime.now().toString()
      });
      Navigator.of(context).pop();
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop();
      showmessage(e.code.toString());
      return false;
    }
  }

  Future<String> uploadFileToStorage(
      XFile file, String path, String uid) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    String storagePath =
        '$path/$uid/${DateTime.now().millisecondsSinceEpoch}_${file.name}';

    // Upload the file to Firebase Storage
    TaskSnapshot snapshot =
        await storage.ref(storagePath).putFile(File(file.path));

    // Get download URL of the uploaded file
    String downloadURL = await snapshot.ref.getDownloadURL();

    // Return download URL and storage path
    return downloadURL;
  }

  void signout() async {
    await auth.signOut();
  }

  Future<bool> changePassword(String newPassword) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.updatePassword(newPassword);

        showmessage("Password changed successfully");
        return true;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          showmessage(
              'The user must re-authenticate before this operation can be executed.');
        } else {
          showmessage(
              'An error occurred while changing the password: ${e.code}');
        }
      } catch (e) {
        print('An error occurred while changing the password: $e');
      }
    } else {
      showmessage("No user is currently signed in.");
      return false;
    }
    return false;
  }
}
