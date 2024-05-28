import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score/constants/routes.dart';
import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';
import 'package:score/models/ticket.dart';

import 'package:score/qrpage/activationpage.dart';
import 'package:sks_ticket_view/sks_ticket_view.dart';

class ticketActive extends StatefulWidget {
  final String data;
  const ticketActive({
    super.key,
    required this.data,
  });

  @override
  // ignore: library_private_types_in_public_api
  _BusListState createState() => _BusListState();
}

class _BusListState extends State<ticketActive> {
  bool isloading = false;
  List<ticket_model> studentsearchlist = [];

  ticket_model? singleproduct;

  @override
  void initState() {
    super.initState();
    getcategorylist();
  }

  void getcategorylist() async {
    setState(() {
      isloading = true;
    });
    studentsearchlist = await FirebaseFirestoreHelper.instance.getticket();

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 235, 244, 250),
      appBar: AppBar(
        title: const Text(
          'AVAILABLE TICKETS',
          style: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 15, 66, 107),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: studentsearchlist.length,
                itemBuilder: (context, index) {
                  ticket_model singleproduct = studentsearchlist[index];

                  return GestureDetector(
                    onTap: () => Routes.instance.push(
                        studentlist(
                            busid: widget.data,
                            qr_number: singleproduct.qrnumber,
                            id: singleproduct.id),
                        context),
                    child: Container(
                      height: 150,
                      margin: EdgeInsets.all(4),
                      child: SKSTicketView(
                        drawDivider: true,
                        shadowColor: Colors.black12,
                        dividerColor: Colors.black12,
                        dividerStrokeWidth: 3,
                        dividerPadding: 0,
                        contentPadding: EdgeInsets.all(20),
                        backgroundColor: Color.fromARGB(255, 15, 66, 107),
                        // dividerColor: Colors.amber,
                        child: Row(
                          children: <Widget>[
                            Flexible(
                              flex: 7,
                              child: SizedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Text(
                                          singleproduct.from,
                                          style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          singleproduct.to,
                                          style: GoogleFonts.poppins(
                                              color: Color.fromARGB(
                                                  255, 15, 66, 107),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 3,
                              child: SizedBox(
                                child: Center(
                                    child: Text(
                                  singleproduct.tickets,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 15, 66, 107)),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 0,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
