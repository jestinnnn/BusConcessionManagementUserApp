import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:score/checkout_ui.dart';
import 'package:score/constants/constants.dart';

import 'package:score/firebase_helper/firebase_firestore_helper/firestore_helper.dart';
import 'package:score/pages/home_page.dart';

import 'models/checkout_result.dart';

class MyDemoPage extends StatefulWidget {
  final String name;
  final String id;
  final String email;
  final String from;
  final String to;
  final DateTime startdate;
  final DateTime enddate;
  final int price;
  final int tickeynumber;

  const MyDemoPage(
      {Key? key,
      required this.from,
      required this.to,
      required this.startdate,
      required this.enddate,
      required this.tickeynumber,
      required this.price,
      required this.name,
      required this.id,
      required this.email})
      : super(key: key);

  @override
  State<MyDemoPage> createState() => _MyDemoPageState();
}

class _MyDemoPageState extends State<MyDemoPage> {
  Future<void> _nativePayClicked(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Native Pay requires setup')));
  }

  Future<void> _cashPayClicked(BuildContext context) async {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Cash Pay requires setup')));
  }

  @override
  Widget build(BuildContext context) {
    final demoOnlyStuff = DemoOnlyStuff();

    final GlobalKey<CardPayButtonState> _payBtnKey =
        GlobalKey<CardPayButtonState>();

    Future<void> _creditPayClicked(
        CardFormResults results, CheckOutResult checkOutResult) async {
      _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.processing);
      await FirebaseFirestoreHelper.instance.AddTicket(widget.from, widget.to,
          widget.startdate, widget.enddate, widget.tickeynumber);
      await FirebaseFirestoreHelper.instance.Pricehistory(
          widget.from,
          widget.to,
          widget.startdate,
          widget.price.toString(),
          widget.tickeynumber.toString(),
          widget.enddate,
          widget.name,
          widget.email,
          widget.id);

      await demoOnlyStuff.callTransactionApi(_payBtnKey);
      ShowLoaderDialog(context);
      await delayedFlow();
      Navigator.pop(context);

      showCustomDialog(
          context: context,
          content: "payment sucessful",
          buttonText: "OK",
          navigateFrom: HomePage(),
          title: "Confirmation");

      print(results);

      for (PriceItem item in checkOutResult.priceItems) {
        print('Item: ${item.name} - Quantity: ${item.quantity}');
      }

      final String subtotal =
          (checkOutResult.subtotalCents / 100).toStringAsFixed(2);
      print('Subtotal: \$$subtotal');

      final String total =
          (checkOutResult.totalCostCents / 100).toStringAsFixed(2);
      print('Total: rs $total');
    }

    final List<PriceItem> _priceItems = [
      PriceItem(
          name: 'Ticket Price',
          quantity: widget.tickeynumber,
          itemCostCents: widget.price),
    ];

    const String _payToName = 'Payment';

    final _isApple = kIsWeb ? false : Platform.isIOS;

    const _footer = CheckoutPageFooter(
      // These are example url links only. Use your own links in live code
      privacyLink: 'https://[Credit Processor].com/privacy',
      termsLink: 'https://[Credit Processor].com/payment-terms/legal',
      note: 'Powered By [Credit Processor]',
      noteLink: 'https://[Credit Processor].com/',
    );

    Function? _onBack = Navigator.of(context).canPop()
        ? () => Navigator.of(context).pop()
        : null;

    return Scaffold(
      appBar: null,
      body: CheckoutPage(
        data: CheckoutData(
          priceItems: _priceItems,
          payToName: _payToName,
          displayNativePay: !kIsWeb,
          onNativePay: (checkoutResults) => _nativePayClicked(context),
          onCashPay: (checkoutResults) => _cashPayClicked(context),
          isApple: _isApple,
          onCardPay: (paymentInfo, checkoutResults) =>
              _creditPayClicked(paymentInfo, checkoutResults),
          onBack: _onBack,
          payBtnKey: _payBtnKey,
          displayTestData: true,
        ),
        footer: _footer,
      ),
    );
  }
}

class DemoOnlyStuff {
  bool shouldSucceed = true;

  Future<void> provideSomeTimeBeforeReset(
      GlobalKey<CardPayButtonState> _payBtnKey) async {
    await Future.delayed(const Duration(seconds: 2), () {
      _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.ready);
      return;
    });
  }

  Future<void> callTransactionApi(
      GlobalKey<CardPayButtonState> _payBtnKey) async {
    await Future.delayed(const Duration(seconds: 2), () {
      if (shouldSucceed) {
        _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.success);
        shouldSucceed = false;
      } else {
        _payBtnKey.currentState?.updateStatus(CardPayButtonStatus.fail);
        shouldSucceed = true;
      }
      provideSomeTimeBeforeReset(_payBtnKey);
      return;
    });
  }
}
