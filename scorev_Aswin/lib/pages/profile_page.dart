import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:score/constants/constants.dart';
import 'package:score/constants/routes.dart';
import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';
import 'package:score/models/boarding_pass_request.dart';
import 'package:score/pages/auth/login_page.dart';
import 'package:score/profile_components/changepassword.dart';
import 'package:score/profile_components/expiredTickets.dart';
import 'package:score/profile_components/filecomplaint.dart';
import 'package:score/profile_components/onboarding_request_page.dart';
import 'package:score/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isloading = false;
  List<BoardingPassRequestModel> boardingmodellist = [];
  BoardingPassRequestModel? singleproduct;

  @override
  void initState() {
    super.initState();
    getcategorylist();
  }

  void getcategorylist() async {
    setState(() {
      isloading = true;
    });
    boardingmodellist = await FirebaseFirestoreHelper.instance.getonbardings();

    setState(() {
      isloading = false;
    });

    final firstJson = boardingmodellist[0];
    print(firstJson.id);
  }

  // Use nullable File type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('PROFILE',style: 
          TextStyle(color:  Color.fromARGB(255, 15, 66, 107),fontWeight: FontWeight.bold),),
          backgroundColor: Colors.white,
        ),
        body: ListView.builder(
          itemCount: boardingmodellist.length,
          itemBuilder: (context, index) {
            BoardingPassRequestModel singleproduct = boardingmodellist[index];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // User Avatar/Profile Picture with Edit option
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          // You can load the user's image here
                          backgroundImage: NetworkImage(singleproduct.photo),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20.0),
                    Text(
                      singleproduct.name, // Replace with user's email
                      style: TextStyle(
                          fontSize: 23.0,
                          color:  Color.fromARGB(255, 15, 66, 107),
                          fontWeight: FontWeight.bold),
                    ),
                    // User Information

                    Text(
                      singleproduct.email, // Replace with user's email
                      style: TextStyle(fontSize: 16.0, color: Colors.black),
                    ),

                    const SizedBox(height: 20.0),

                    // Stacked Buttons using ListView
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        
                        _buildStackedButton(Icons.history_edu,
                            'Expired Tickets', () {
                                Routes.instance.push(Expired_Ticket_History(), context);
                          // Logic for Boarding Pass button
                        }),
                        _buildStackedButton(
                            Icons.airplanemode_active, 'Boarding Pass', () {
                          Routes.instance.push(Onboarding(), context);
                          // Logic for Boarding Pass button
                        }),
                        _buildStackedButton(Icons.logout, 'log out', () {
                          showCustomDialog(
                              context: context,
                              content: "Logging out from current aaccount",
                              buttonText: "OK",
                              navigateFrom: LoginPage(),
                              title: "log out");
                          // Logic for Purchased Ticket History button
                        }),

                        _buildStackedButton(
                            Icons.password_rounded, 'Change Password', () {
                          Routes.instance.push(Change_pass(), context);
                          // Logic for Boarding Pass button
                        }),

                        //future Enhancement
                        // _buildStackedButton(Icons.credit_card, 'My Wallet', () {
                        //   // Logic for My Wallet button
                        // }),

                        //Future Enhancement
                        // _buildStackedButton(Icons.star, 'My Reviews', () {
                        //   // Logic for My Reviews button
                        // }),
                        _buildStackedButton(Icons.support, 'Help and Support',
                            () {
                          // Logic for My Reviews button
                        }),
                        _buildStackedButton(
                            Icons.local_police, 'File a Complaint', () {
                          Routes.instance.push(File_complaint(), context);
                          // Logic for My Reviews button
                        }),
                        SizedBox(height: 10,),
                        Center(
                          child: FutureBuilder<PackageInfo>(
                                        future: PackageInfo.fromPlatform(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text('Version: ${snapshot.data!.version}');
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        },
                                      ),
                        ),
            SizedBox(height: 10,)
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _buildStackedButton(
      IconData icon, String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon,color:  Color.fromARGB(255, 15, 66, 107),),
        label: Text(label),
        style: stewh,
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        //_imageFile = File(pickedFile.path);
      });
    }
  }
}
