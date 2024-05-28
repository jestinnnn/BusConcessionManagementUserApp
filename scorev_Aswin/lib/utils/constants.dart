import 'package:flutter/material.dart';

const Color bl = Colors.black;
const Color wh = Colors.white;

BorderSide bs = const BorderSide(color: bl, width: 1);
RoundedRectangleBorder br = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(8),
);

ButtonStyle ste = ElevatedButton.styleFrom(
    backgroundColor: bl,
    foregroundColor: wh,
    side: const BorderSide(color: bl, width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ));
ButtonStyle stew = ElevatedButton.styleFrom(
    backgroundColor: wh,
    foregroundColor: bl,
    side: const BorderSide(color: bl, width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ));

ButtonStyle stewh = ElevatedButton.styleFrom(
    backgroundColor: wh,
    foregroundColor: bl,
    side: const BorderSide(color: bl, width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    minimumSize: const Size.fromHeight(60));
