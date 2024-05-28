import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:score/constants/routes.dart';
import 'package:score/pages/common_scaffold.dart';
import 'package:score/pages/home_page.dart';
import 'package:score/pages/ticket_booking_history.dart';
import 'package:score/qrpage/ticketslist.dart';
import 'package:score/services/map_service.dart';
import 'package:score/utils/constants.dart';

class ScanCodePage extends StatefulWidget {
  const ScanCodePage({super.key});

  @override
  State<ScanCodePage> createState() => _ScanCodePageState();
}

class _ScanCodePageState extends State<ScanCodePage> {
  String? value;
  TextEditingController text = TextEditingController();
  MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    returnImage: true,
  );

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      currentIndex: 3,
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
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        }
      },
      backgroundColor: wh,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 30, 8, 8),
        child: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: hi(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: TextField(
                    cursorColor: Colors.white,
                    controller: text,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        focusColor: Colors.white,
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        iconColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        prefixIconColor: Colors.white,
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: "Type Bus Hash",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        prefixIcon: Icon(Icons.search)),
                    onEditingComplete: () => Routes.instance
                        .push(ticketActive(data: text.text), context)),
                padding: EdgeInsets.all(4),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget hi() {
    return MobileScanner(
      controller: _scannerController,
      onDetect: (capture) {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;
        for (final barcode in barcodes) {
          print('Barcode found! ${barcode.rawValue}');
        }
        if (image != null) {
          showDialog(
            context: context,
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    value = barcodes.first.rawValue;
                  });
                  Routes.instance.push(ticketActive(data: value!), context);
                },
                child: AlertDialog(
                  title: Text(
                    barcodes.first.rawValue ?? "",
                  ),
                  content: Image(
                    image: MemoryImage(image),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
