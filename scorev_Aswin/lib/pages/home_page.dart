import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ticket_widget/ticket_widget.dart' as hi;
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:score/constants/constants.dart';
import 'package:score/constants/routes.dart';
import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';
import 'package:score/models/boarding_pass_request.dart';
import 'package:score/models/ticket.dart';
import 'package:score/pages/profile_page.dart';
import 'package:score/pages/ticket_booking_history.dart';
import 'package:score/qrpage/scannerpage.dart';
import 'package:score/services/bus_list.dart';
import 'package:score/services/map_service.dart';
import 'package:score/services/qr_details_page.dart';
import '../utils/constants.dart';
import 'common_scaffold.dart';

class TicketWidget extends StatelessWidget {
  final String ticketNumber;
  final String from;
  final String to;
  final remainingTickets;

  const TicketWidget({
    Key? key,
    required this.ticketNumber,
    required this.from,
    required this.to,
    required this.remainingTickets,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text('TICKET NUMBER: $ticketNumber'),
            const SizedBox(height: 10),
            Text('FROM: $from'),
            Text('TO: $to'),
            Text('Remaining Tickets: $remainingTickets'),
          ],
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String getSystemDate() {
    final now = DateTime.now();
    final formatter = DateFormat('MMM d, yyyy');
    return formatter.format(now);
  }

  var fromplace = 'Kayamkulam';
  var toplace = 'maveliakara';

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  GlobalKey<AutoCompleteTextFieldState<String>> keyFrom =
      GlobalKey<AutoCompleteTextFieldState<String>>();
  GlobalKey<AutoCompleteTextFieldState<String>> keyTo =
      GlobalKey<AutoCompleteTextFieldState<String>>();

  DateTime? startDate;
  DateTime? endDate;
  DateTime? startDate2;
  DateTime? endDate2;

  Future<void> _selectDate_end(BuildContext context, bool isStartDate,
      DateTime initialdatee, DateTime firstdate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialdatee,
      firstDate: firstdate,
      lastDate: DateTime(2101),
    );

    setState(() {
      if (isStartDate) {
        startDate = selectedDate;
      } else {
        endDate = selectedDate;
      }
    });
  }

  Future<void> _selectDate2(BuildContext context, bool isStartDate,
      DateTime initialdatee, DateTime firstdate) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialdatee,
      firstDate: initialdatee,
      lastDate: DateTime(2101),
    );

    setState(() {
      if (isStartDate) {
        startDate2 = selectedDate;
      } else {
        endDate2 = selectedDate;
      }
    });
  }

  bool isContainer1Pressed = false;
  bool isContainer2Pressed = false;
  String from = "";
  String to = "";
  String name = "";
  String id = "";
  String email = "";

  bool isloading = false;
  List<BoardingPassRequestModel> boardingmodellist = [];
  List<ticket_model> ticketlist = [];
  BoardingPassRequestModel? singleproduct;

  @override
  void initState() {
    super.initState();
    getcategorylist();
    getticketlist();
  }

  void getcategorylist() async {
    boardingmodellist = await FirebaseFirestoreHelper.instance.getonbardings();

    setState(() {
      final firstJson = boardingmodellist[0];

      from = firstJson.boardinglocation;
      to = firstJson.collegebusstoplocation;
      name = firstJson.name;
      email = firstJson.email;
      id = firstJson.id;
    });
  }

  void getticketlist() async {
    setState(() {
      isloading = true;
    });
    ticketlist = await FirebaseFirestoreHelper.instance.getticket();
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      currentIndex: 0,
      onTabTapped: (index) {
        if (index == 2) {
          Routes.instance.push(mapa(), context);
        }
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Ticket_History(),
            ),
          );
        }
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScanCodePage(),
            ),
          );
        }
      },
      backgroundColor: wh,
      body: isloading
          ? Center(
              child: Container(
                color: Colors.white,
                height: 150,
                width: 300,
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 15, 66, 107),
                ),
                alignment: Alignment.center,
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getSystemDate(),
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 15, 66, 107),
                          ),
                        ),
                        IconButton(
                          color: Color.fromARGB(255, 15, 66, 107),
                          icon: const Icon(Icons.person),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfilePage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isContainer1Pressed = !isContainer1Pressed;
                          if (isContainer2Pressed) {
                            isContainer2Pressed = false;
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isContainer1Pressed
                              ? Color.fromARGB(255, 15, 66, 107)
                              : const Color.fromARGB(255, 255, 255, 255),
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "FROM: ${from}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isContainer1Pressed
                                          ? Colors.white
                                          : Color.fromARGB(255, 15, 66, 107),
                                    ),
                                  ),
                                  const SizedBox(width: 20.0),
                                  Text(
                                    "TO : ${to}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isContainer1Pressed
                                          ? Colors.white
                                          : Color.fromARGB(255, 15, 66, 107),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: ElevatedButton(
                                      style: stew,
                                      onPressed: () => _selectDate_end(context,
                                          true, DateTime.now(), DateTime.now()),
                                      child: Text(
                                        startDate == null
                                            ? 'Select Start Date'
                                            : DateFormat('MMM d, yyyy')
                                                .format(startDate!),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Flexible(
                                      child: ElevatedButton(
                                        style: stew,
                                        onPressed: () => _selectDate_end(
                                            context,
                                            false,
                                            startDate!,
                                            startDate!),
                                        child: Text(
                                          endDate == null
                                              ? 'Select End Date'
                                              : DateFormat('MMM d, yyyy')
                                                  .format(endDate!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isContainer2Pressed = !isContainer2Pressed;
                          if (isContainer1Pressed) {
                            isContainer1Pressed = false;
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isContainer2Pressed
                              ? Color.fromARGB(255, 15, 66, 107)
                              : Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "FROM : $to",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isContainer2Pressed
                                          ? Colors.white
                                          : Color.fromARGB(255, 15, 66, 107),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Text(
                                    "TO : $from",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isContainer2Pressed
                                          ? Colors.white
                                          : Color.fromARGB(255, 15, 66, 107),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: ElevatedButton(
                                      style: stew,
                                      onPressed: () => _selectDate2(context,
                                          true, DateTime.now(), DateTime.now()),
                                      child: Text(
                                        startDate2 == null
                                            ? 'Select Start Date'
                                            : DateFormat('MMM d, yyyy')
                                                .format(startDate2!),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: ElevatedButton(
                                      style: stew,
                                      onPressed: () => _selectDate2(context,
                                          false, startDate2!, startDate2!),
                                      child: Text(
                                        endDate2 == null
                                            ? 'Select End Date'
                                            : DateFormat('MMM d, yyyy')
                                                .format(endDate2!),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 15, 66, 107)),
                      onPressed: () {
                        if (isContainer1Pressed) {
                          if (startDate == null || endDate == null) {
                            showmessage("Dates empty");
                          } else {
                            Routes.instance.push(
                                BusList(
                                    from: from.toLowerCase(),
                                    to: to.toLowerCase(),
                                    startdate: startDate!,
                                    enddate: endDate!,
                                    name: name,
                                    id: id,
                                    email: email),
                                context);
                          }
                        } else if (isContainer2Pressed) {
                          if (startDate2 == null || endDate2 == null) {
                            showmessage("Dates empty");
                          } else {
                            Routes.instance.push(
                                BusList(
                                    from: to.toLowerCase(),
                                    to: from.toLowerCase(),
                                    startdate: startDate2!,
                                    enddate: endDate2!,
                                    name: name,
                                    id: id,
                                    email: email),
                                context);
                          }
                        } else {
                          showmessage("No value selected");
                        }
                        // Handle search bus logic
                      },
                      child: const Text(
                        'SEARCH BUS',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "ACTIVE TICKETS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      color: Color.fromARGB(255, 237, 237, 237),
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          ticket_model singleproduct = ticketlist[index];
                          return GestureDetector(
                              onTap: () {
                                Routes.instance.push(
                                    MyTicketView(singleproduct: singleproduct),
                                    context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: hi.TicketWidget(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    width: 350,
                                    height: 350,
                                    isCornerRounded: true,
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 120.0,
                                              height: 25.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                                border: Border.all(
                                                    width: 1.0,
                                                    color: Colors.green),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  'RIDE RIGHT',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  '',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Icon(
                                                    Icons.bus_alert_sharp,
                                                    color: Colors.pink,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 8.0),
                                                  child: Text(
                                                    '',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 20.0),
                                          child: Text(
                                            ' Active Tickets',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 25.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0, right: 52.0),
                                                child: ticketDetailsWidget(
                                                    'Ticket Number',
                                                    singleproduct.qrnumber,
                                                    'tickets',
                                                    singleproduct.tickets),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 12.0, right: 20.0),
                                                child: ticketDetailsWidget(
                                                    'From',
                                                    singleproduct.from,
                                                    'To',
                                                    singleproduct.to),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        const Padding(
                                          padding: EdgeInsets.only(
                                              top: 10.0,
                                              left: 75.0,
                                              right: 75.0),
                                          child: Center(
                                            child: Text(
                                              'RIDE RIGHT',
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 15, 66, 107),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                        itemCount: ticketlist.length,
                        separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                      ),
                    )
                  ],
                ),
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
