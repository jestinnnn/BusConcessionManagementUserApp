import 'package:flutter/material.dart';

import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';
import 'package:score/models/ticket.dart';
import 'package:ticket_widget/ticket_widget.dart';

class Expired_Ticket_History extends StatefulWidget {
  Expired_Ticket_History();

  @override
  State<Expired_Ticket_History> createState() => _Expired_Ticket_HistoryState();
}

class _Expired_Ticket_HistoryState extends State<Expired_Ticket_History> {
  bool isloading = false;
  List<ticket_model> tickethistory = [];

  ticket_model? singlehistory;

  @override
  void initState() {
    super.initState();
    getcategorylist();
  }

  void getcategorylist() async {
    setState(() {
      isloading = true;
    });
    tickethistory = await FirebaseFirestoreHelper.instance.getexpiredticket();

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 134, 191, 220),
      appBar: AppBar(
        title: Text("EXPIRED TICKETS",style: 
        TextStyle(fontWeight: FontWeight.bold,color: Color.fromARGB(255, 15, 66, 107),),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          separatorBuilder: (context, index) => SizedBox(
            width: 10,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: tickethistory.length,
          itemBuilder: (BuildContext context, int index) {
            singlehistory = tickethistory[index];
            return Center(
              child: TicketWidget(
                width: 350,
                height: 450,
                isCornerRounded: true,
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120.0,
                          height: 25.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            border: Border.all(width: 1.0, color: Colors.green),
                          ),
                          child: const Center(
                            child: Text(
                              'RIDE RIGHT',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.bus_alert_sharp,
                                color: Colors.pink,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        ' Expired Tickets',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, right: 52.0),
                            child: ticketDetailsWidget(
                                'QrNumber',
                                singlehistory!.qrnumber,
                                'tickets',
                                singlehistory!.tickets),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, right: 52.0),
                            child: ticketDetailsWidget(
                                'Activation Date',
                                singlehistory!.startdate.substring(0, 11),
                                'Id',
                                singlehistory!.status),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 12.0, right: 53.0),
                            child: ticketDetailsWidget(
                                'From        ',
                                singlehistory!.from,
                                ' To',
                                singlehistory!.from),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Padding(
                      padding:
                          EdgeInsets.only(top: 10.0, left: 75.0, right: 75.0),
                      child: Center(
                        child: Text(
                          'RIDE RIGHT',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVariableRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

Widget ticketDetailsWidget(String firstTitle, String firstDesc,
    String secondTitle, String secondDesc) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              firstTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                firstDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              secondTitle,
              style: const TextStyle(color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                secondDesc,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      )
    ],
  );
}
