import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:score/constants/routes.dart';

import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';
import 'package:score/models/ticket_history_model.dart';
import 'package:score/pages/common_scaffold.dart';
import 'package:score/pages/home_page.dart';
import 'package:score/services/map_service.dart';
import 'package:sks_ticket_view/sks_ticket_view.dart';

class Ticket_History extends StatefulWidget {
  Ticket_History();

  @override
  State<Ticket_History> createState() => _Ticket_HistoryState();
}

class _Ticket_HistoryState extends State<Ticket_History> {
  bool isloading = false;
  List<Ticket_history_model> tickethistory = [];

  Ticket_history_model? singlehistory;

  @override
  void initState() {
    super.initState();
    getcategorylist();
  }

  void getcategorylist() async {
    setState(() {
      isloading = true;
    });
    tickethistory = await FirebaseFirestoreHelper.instance.get_ticket_history();

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      currentIndex: 1,
      onTabTapped: (index) {
        if (index == 2) {
          Routes.instance.push(mapa(), context);
        }
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => mapa(),
            ),
          );
        }
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      },
      backgroundColor: Color.fromARGB(255, 234, 243, 247),
      body: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 0,
        ),
        itemCount: tickethistory.length,
        itemBuilder: (BuildContext context, int index) {
          singlehistory = tickethistory[index];
          return Container(
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(
                                singlehistory!.busname,
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 16),
                              ),
                              Text(
                                singlehistory!.busnumber,
                                style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                singlehistory!.dateandtime
                                    .toString()
                                    .substring(0, 19),
                                style: GoogleFonts.poppins(
                                    color: Colors.black, fontSize: 12),
                              )
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
                        singlehistory!.qrnumber,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 15, 66, 107)),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
