import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:score/models/ticket.dart';
import 'package:ticket_widget/ticket_widget.dart';

class MyTicketView extends StatefulWidget {
  final ticket_model singleproduct;
  const MyTicketView({super.key, required this.singleproduct});

  @override
  State<MyTicketView> createState() => _MyTicketViewState();
}

class _MyTicketViewState extends State<MyTicketView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ticket Details"),
      ),
      backgroundColor: const Color.fromARGB(255, 134, 191, 220),
      body: Center(
        child: TicketWidget(
          width: 350,
          height: 550,
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
                            color: Colors.black, fontWeight: FontWeight.bold),
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
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  ' Ticket Details',
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
                      padding: const EdgeInsets.only(top: 12.0, right: 52.0),
                      child: ticketDetailsWidget(
                          'QrNumber',
                          widget.singleproduct.qrnumber,
                          'tickets',
                          widget.singleproduct.tickets),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, right: 52.0),
                      child: ticketDetailsWidget(
                          'From',
                          widget.singleproduct.from,
                          'To',
                          widget.singleproduct.to),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, right: 53.0),
                      child: ticketDetailsWidget(
                          'Start Date',
                          widget.singleproduct.startdate.substring(0, 11),
                          'end Date',
                          widget.singleproduct.enddate.substring(0, 11)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: QrImageView(
                  data: "hi",
                  version: QrVersions.auto,
                  size: 100,
                  gapless: false,
                  embeddedImageStyle: QrEmbeddedImageStyle(
                    size: Size(60, 256),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 75.0, right: 75.0),
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
              Center(child: const Text('ENJOY THE RIDE'))
            ],
          ),
        ),
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
