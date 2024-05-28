import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';
import 'package:score/models/boarding_pass_request.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  List<BoardingPassRequestModel> boardingmodellist = [];
  bool isloading = false;

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
  }

  String calculateAge(String dateTimeString) {
    try {
      final dateFormat = DateFormat('yyyy-MM-dd');
      final parsedDateTime = dateFormat.parse(dateTimeString);

      final now = DateTime.now();

      final age = now.year -
          parsedDateTime.year -
          ((now.month < parsedDateTime.month) ||
                  (now.month == parsedDateTime.month &&
                      now.day < parsedDateTime.day)
              ? 1
              : 0);

      return age.toString();
    } on Exception catch (e) {
      print('Error calculating age: $e');
      return 'N/A';
    }
  }

  Widget _buildText(String label, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label + ' ',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: 
     Color.fromARGB(255, 134, 191, 220),
    
      body: isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(6,16, 10, 6),
              child: ListView.builder(
                itemCount: boardingmodellist.length,
                itemBuilder: (context, index) {
                  BoardingPassRequestModel singleproduct =
                      boardingmodellist[index];
                  int accademicyear = int.parse(singleproduct.accademicYear) +
                      int.parse(singleproduct.durationofcourse);
                  return SingleChildScrollView(scrollDirection:Axis.vertical,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.black, width: 3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          const Center(
                            child: Text(
                              'STUDENT BOARDING PASS',
                              style: TextStyle(
                                fontSize: 24,
                                color: Color.fromARGB(255, 15, 66, 107),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Center(
                            child: Container(
                              foregroundDecoration: BoxDecoration(border: Border.all(color: 
                              Colors.black,width: 3)),
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                image: DecorationImage(
                                  
                                  fit: BoxFit.cover,
                                  image: NetworkImage(singleproduct.photo),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                             SizedBox(height: 5),
                  Divider(thickness:2,height: 4,color: Color.fromARGB(255, 15, 66, 107),),
                  SizedBox(height: 5),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              _buildText('Name:', singleproduct.name),
                              _buildText('Date of Birth:',
                                  singleproduct.dob.substring(0, 11)),
                              _buildText('Age:', calculateAge(singleproduct.dob)),
                              _buildText(
                                  'Institution:', singleproduct.institution),
                              _buildText('Course:', singleproduct.course),
                              _buildText('Accademic Year:',
                                  '${singleproduct.accademicYear}-$accademicyear'),
                              _buildText('Duration of Course:',
                                  singleproduct.durationofcourse),
                              _buildText('Concession Route:',
                                  singleproduct.collegebusstoplocation),
                              singleproduct.dateofissue == "null"
                                  ? Container()
                                  : _buildText('Date of Issue:',
                                      singleproduct.dateofissue),
                              singleproduct.dateofexpiry == "null"
                                  ? Container()
                                  : _buildText('Date of Expiry:',
                                      singleproduct.dateofexpiry),
                              singleproduct.price == "0"
                                  ? Container()
                                  : _buildText(
                                      'Ticket Charge:', singleproduct.price),
                              singleproduct.message == "null"
                                  ? Container(
                                      height: 0,
                                      width: 0,
                                    )
                                  : _buildText('Message:', singleproduct.message),
                              _buildText('Status:', singleproduct.status),
                            ],
                          ),
                          singleproduct.status == "approved"
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      Center(
                                          child: _buildBadge(
                                              Icons.verified, Colors.blue)),
                                      const Center(
                                          child: Text(
                                        'verified',
                                        style: TextStyle(color: Colors.blue),
                                      )),
                                    ],
                                  ),
                                )
                              : (singleproduct.status == "pending")
                                  ? Expanded(
                                      child: Column(
                                        children: [
                                          Center(
                                              child: _buildBadge(
                                                  Icons.pending, Colors.orange)),
                                          const Center(
                                              child: Text(
                                            'pending',
                                            style:
                                                TextStyle(color: Colors.orange),
                                          )),
                                        ],
                                      ),
                                    )
                                  : (singleproduct.status ==
                                          "institute approved")
                                      ? Expanded(
                                          child: Column(
                                            children: [
                                              Center(
                                                  child: _buildBadge(Icons.school,
                                                      Colors.green)),
                                              const Center(
                                                  child: Text(
                                                'College Level Approved',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              )),
                                            ],
                                          ),
                                        )
                                      : Expanded(
                                          child: Column(
                                            children: [
                                              Center(
                                                  child: _buildBadge(
                                                      Icons.warning, Colors.red)),
                                              const Center(
                                                  child: Text(
                                                'REJECTED',
                                                style:
                                                    TextStyle(color: Colors.red),
                                              )),
                                            ],
                                          ),
                                        )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 24.0,
      ),
    );
  }
}
