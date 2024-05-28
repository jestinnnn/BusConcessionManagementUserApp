import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:score/constants/routes.dart';
import 'package:score/firebase_helper/firebase_auth_helper/firebaseauthhelper.dart';
import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';

import 'package:score/pages/home_page.dart';
import '../utils/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>(); // Key for the form

  String userType = 'Student';
  String selectedDistrict = 'Select District ';
  String selectedInstitute = 'Select Institute';
  String preferredBusType = 'Private';
  String selectedfrom = "kayamkulam";
  String selectedto = "mavelikkara";

  List<String> districts = [
    'Select District ',
    "Thiruvananthapuram",
    "Kollam",
    "Alappuzha",
    "Pathanamthitta",
    "Kottayam",
    "Idukki",
    "Ernakulam",
    "Thrissur",
    "Palakkad",
    "Malappuram",
    "Kozhikode",
    "Wayanad",
    "Kasaragod"
  ];
  List<String> from = ["kattanam", "kayamkulam", "thiruvalla"];
  List<String> to = ["mavelikkara", "kallumala", "mannar"];
  List<String> institutes = [
    'Select Institute',
    'IHRD',
  ];

  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  TextEditingController firstname = TextEditingController();
  TextEditingController lastname = TextEditingController();

  TextEditingController course = TextEditingController();
  TextEditingController residenceadress = TextEditingController();
  TextEditingController courseDuration = TextEditingController();
  DateTime? endDate;
  DateTime initialDate = DateTime.now();
  DateTime firstDate = DateTime(2000);
  DateTime lastDate = DateTime(2030);
  int? dateselect;

  List<XFile?> documentImages = List.generate(4, (index) => null);

  bool isDocumentVerified = false;
  bool agreedToTerms = false;

  Future<void> _pickDocumentImage(int index) async {
    final picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      documentImages[index] = pickedFile;
    });
  }

  Future<void> _showYearPicker(BuildContext context) async {
    final int currentYear = DateTime.now().year;
    final int? pickedYear = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        int selectedYear = dateselect ?? currentYear;
        return AlertDialog(
          title: Text("Select a year"),
          content: Container(
            // Adjust height to fit your needs
            height: 200,
            width: double.maxFinite,
            child: YearPicker(
              firstDate: DateTime(currentYear - 100),
              lastDate: DateTime(currentYear + 100),
              selectedDate: DateTime(selectedYear),
              onChanged: (DateTime newValue) {
                setState(() {
                  dateselect = newValue.year;
                });
                Navigator.pop(context, newValue.year); // Close the dialog
              },
            ),
          ),
        );
      },
    );

    if (pickedYear != null && pickedYear != dateselect) {
      setState(() {
        dateselect = pickedYear;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getinstitutions();
  }

  void getinstitutions() async {
    institutes = await FirebaseFirestoreHelper.instance.fetchInstitutionNames();
  }

  Widget _buildDocumentUploadButton(int index, String documentType) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _pickDocumentImage(index),
          style: stew,
          child: Text(' $documentType',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12)),
        ),
        const SizedBox(height: 5.0),
        documentImages[index] != null
            ? Image.file(
                File(documentImages[index]!.path),
                height: 50.0,
                width: 50.0,
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildCurvedToggleButton(
      String label, bool isSelected, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: isSelected ?   Color.fromARGB(255, 15, 66, 107): wh,
        border: Border.all(color: bl),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: isSelected ? wh : bl,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SIGN UP',
          style: TextStyle(fontWeight: FontWeight.bold,color:Color.fromARGB(255, 15, 66, 107),),
        ),
        backgroundColor: wh,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'User Type',
                  style: TextStyle(fontSize: 18.0, color: bl),
                ),
                Row(
                  children: [
                    Radio(
                      value: 'Student',
                      groupValue: userType,
                      onChanged: (value) {
                        setState(() {
                          userType = value.toString();
                        });
                      },
                      activeColor:      Color.fromARGB(255, 15, 66, 107),
                    ),
                    const Text('Student', style: TextStyle(color: bl)),
                  ],
                ),
                if (userType == 'Student') ...[
                  const SizedBox(height: 20.0),
                  const Text(
                    'Select District',
                    style: TextStyle(fontSize: 18.0, color: bl),
                  ),
                  DropdownButton<String>(
                    value: selectedDistrict,
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value!;
                      });
                    },
                    items: districts.map((district) {
                      return DropdownMenuItem<String>(
                        value: district,
                        child: Text(
                          district,
                          style: const TextStyle(color: bl),
                        ),
                      );
                    }).toList(),
                    style: const TextStyle(color: wh),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Select Institute',
                    style: TextStyle(fontSize: 18.0, color: bl),
                  ),
                  DropdownButton<String>(
                    value: selectedInstitute,
                    onChanged: (value) {
                      setState(() {
                        selectedInstitute = value!;
                      });
                    },
                    items: institutes.map((institute) {
                      return DropdownMenuItem<String>(
                        value: institute,
                        child: Text(
                          institute,
                          style: const TextStyle(color: bl),
                        ),
                      );
                    }).toList(),
                    style: const TextStyle(color: wh),
                  ),
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 20.0),
                  const Text(
                    'From where do you get into the bus?',
                    style: TextStyle(fontSize: 18.0, color: bl),
                  ),
                  DropdownButton<String>(
                    value: selectedfrom,
                    onChanged: (value) {
                      setState(() {
                        selectedfrom = value!;
                      });
                    },
                    items: from.map((from) {
                      return DropdownMenuItem<String>(
                        value: from,
                        child: Text(
                          from,
                          style: const TextStyle(color: bl),
                        ),
                      );
                    }).toList(),
                    style: const TextStyle(color: wh),
                  ),
                  const Text(
                    'Select bus stop nearest to the institution',
                    style: TextStyle(fontSize: 18.0, color: bl),
                  ),
                  DropdownButton<String>(
                    value: selectedto,
                    onChanged: (value) {
                      setState(() {
                        selectedto = value!;
                      });
                    },
                    items: to.map((to) {
                      return DropdownMenuItem<String>(
                        value: to,
                        child: Text(
                          to,
                          style: const TextStyle(color: bl),
                        ),
                      );
                    }).toList(),
                    style: const TextStyle(color: wh),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                      style:ElevatedButton.styleFrom(backgroundColor: 
                  
                  Color.fromARGB(255, 15, 66, 107)),
                    onPressed: () => _showYearPicker(context),
                    child: Text(
                        dateselect != null
                            ? 'Selected Year: $dateselect'
                            : 'Select Academic Year',
                        style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton( style:ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 134, 191, 220),
                  
                  ),
                    
                    onPressed: () => _selectDate(context),
                    child: Text(
                      selectedDate != null
                          ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                          : 'Select Date of Birth',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Upload Documents',
                    style: TextStyle(fontSize: 18.0, color: bl),
                  ),
                  const SizedBox(height: 10.0),
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.0),
                      1: FlexColumnWidth(1.0),
                      2: FlexColumnWidth(1.0),
                      3: FlexColumnWidth(1.0),
                    },
                    children: [
                      TableRow(
                        children: [
                          _buildDocumentUploadButton(
                              0, 'Aadhar Card           '),
                          _buildDocumentUploadButton(
                              1, 'Institution ID Card  '),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildDocumentUploadButton(2, 'Income Certificate'),
                          _buildDocumentUploadButton(3, 'Passport size photo'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Preferred Bus Type',
                    style: TextStyle(fontSize: 18.0, color: bl),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCurvedToggleButton(
                          'Private', preferredBusType == 'Private', () {
                        setState(() {
                          preferredBusType = 'Private';
                        });
                      }),
                      _buildCurvedToggleButton(
                          'KSRTC', preferredBusType == 'KSRTC', () {
                        setState(() {
                          preferredBusType = 'KSRTC';
                        });
                      }),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
                const SizedBox(height: 20.0),
                const Text(
                  'Course',
                  style: TextStyle(fontSize: 18.0, color: bl),
                ),
                TextFormField(
                  controller: course,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: bl),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your course';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Course Duration',
                  style: TextStyle(fontSize: 18.0, color: bl),
                ),
                TextFormField(
                  controller: courseDuration,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: bl),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your course duration';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Residence Adress',
                  style: TextStyle(fontSize: 18.0, color: bl),
                ),
                TextFormField(
                  controller: residenceadress,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: bl),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your adress';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: emailController,
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
                TextFormField(
                  controller: firstname,
                  decoration: const InputDecoration(
                    labelText: 'firstname',
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
                      return 'Please enter your firstname';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: lastname,
                  decoration: const InputDecoration(
                    labelText: 'last name',
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
                      return 'Please enter your name';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
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
                      return 'Please enter your mobile number';
                    } else if (value.length != 10) {
                      return 'Mobile number must be 10 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: passwordController,
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
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
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
                      return 'Please confirm your password';
                    } else if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Checkbox(
                      value: isDocumentVerified,
                      onChanged: (value) {
                        setState(() {
                          isDocumentVerified = value!;
                        });
                      },
                      activeColor: bl,
                    ),
                    const Text(
                      'Uploaded documents are true to my knowledge',
                      style: TextStyle(color: bl, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Checkbox(
                      value: agreedToTerms,
                      onChanged: (value) {
                        setState(() {
                          agreedToTerms = value!;
                        });
                      },
                      activeColor: bl,
                    ),
                    RichText(
                      text: const TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(color: bl, fontSize: 12),
                        children: [
                          TextSpan(
                            text: 'Terms and Conditions',
                            style: TextStyle(
                              color: bl,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    // Validate the form before submitting
                    if (_formKey.currentState!.validate()) {
                      bool issignup = await FirebaseAuthHelper.instance.signup(
                          context,
                          emailController.text,
                          passwordController.text,
                          selectedto,
                          course.text,
                          residenceadress.text,
                          selectedDistrict,
                          selectedInstitute,
                          preferredBusType,
                          firstname.text,
                          lastname.text,
                          mobileController.text,
                          selectedfrom,
                          documentImages[0]!,
                          documentImages[1]!,
                          documentImages[2]!,
                          documentImages[3]!,
                          selectedDate!,
                          courseDuration.text,
                          dateselect!);

                      if (issignup) {
                        Routes.instance.push(HomePage(), context);
                      }
                    }
                  },
                   style:ElevatedButton.styleFrom(fixedSize: Size(60, 30), backgroundColor: 
                  
                  Color.fromARGB(255, 15, 66, 107)),
                  child: const Text('Submit',style: 
                  TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: wh,
    );
  }
}
