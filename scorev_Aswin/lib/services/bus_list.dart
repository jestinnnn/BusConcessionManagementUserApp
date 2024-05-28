import 'package:flutter/material.dart';
import 'package:score/constants/constants.dart';
import 'package:score/constants/routes.dart';
import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';
import 'package:score/models/bus_model.dart';

import 'package:score/paymenthome.dart';

import 'package:upi_india/upi_india.dart';

class BusList extends StatefulWidget {
 final String name;
  final String id;
   final String email;
  final String from;
  final String to;
  final DateTime startdate;
  final DateTime enddate;
  const BusList(
      {super.key,
      required this.from,
      required this.to,
      required this.startdate,
      required this.enddate, required this.name, required this.id, required this.email});

  @override
  _BusListState createState() => _BusListState();
}

class _BusListState extends State<BusList> {
  bool isloading = false;
  List<Bus_model> buslist = [];
  Bus_model? singleproduct;
  Bus_model? fjson;
  UpiApp selectedUpiApp = UpiApp.allBank; // Default UPI app


  int numberOfTickets = 1;
  int ticketprice = 100;

  @override
  void initState() {
    super.initState();
    getcategorylist();
    getticketprice();
  }

  void getcategorylist() async {
    setState(() {
      isloading = true;
    });
    buslist = await FirebaseFirestoreHelper.instance
        .getbusdetails(widget.from, widget.to);

    setState(() {
      isloading = false;
    });
  }

  void getticketprice() async {
    ticketprice = await FirebaseFirestoreHelper.instance.Boarding_ticket_cost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BUS LIST', style: TextStyle(
                    color: Color.fromARGB(255, 15, 66, 107),
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                itemCount: buslist.length,
                itemBuilder: (context, index) {
                  Bus_model singleproduct = buslist[index];
                  return Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(8)),
                    child: ListTile(
                      leading: Text(
                        singleproduct.from,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      title: Center(
                          child: Text(
                        singleproduct.mainroute,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10,color:  Color.fromARGB(255, 15, 66, 107),
                            ),
                      )),
                      trailing: Text(
                        singleproduct.to,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      onTap: () {},
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 10,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style:ElevatedButton.styleFrom(foregroundColor:Color.fromARGB(255, 15, 66, 107) ),
                  onPressed: () {
                    if (numberOfTickets > 1) {
                      setState(() {
                        numberOfTickets--;
                      });
                    }
                  },
                  child: const Text('-'),
                ),
                SizedBox(width: 10),
                Text(
                  'Number of Tickets: $numberOfTickets',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  style:ElevatedButton.styleFrom(backgroundColor: 
                  
                  Color.fromARGB(255, 15, 66, 107),foregroundColor:Color.fromARGB(255, 255, 255, 255) ),
                  onPressed: () {
                    setState(() {
                      numberOfTickets++;
                    });
                  },
                  child: const Text('+'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style:ElevatedButton.styleFrom(
                 minimumSize: const Size.fromHeight(60),backgroundColor: 
                  
                  Color.fromARGB(255, 15, 66, 107),foregroundColor:Color.fromARGB(255, 255, 255, 255) ),
            
              onPressed: () async {
                bool a = await FirebaseFirestoreHelper.instance
                    .checkIsBoardingActive();
                 
                if (a) {
                  ShowLoaderDialog(context);
                      await delayedFlow();
                      Navigator.pop(context);
                   Routes.instance.push(MyDemoPage(from: widget.from, to:widget.to, startdate: widget.startdate, enddate: widget.enddate,price: ticketprice,tickeynumber: numberOfTickets,name: widget.name,id: widget.id,email: widget.email,), context);
                  
                    

                 
                  
                } else {
                  showmessage("PASS IS NOT ACTIVE");
                }
              },
              child: Text('Buy for Rupees ${numberOfTickets * ticketprice} '),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
  
}
