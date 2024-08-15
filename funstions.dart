import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/enums/enums.dart';
import '/auth/firebase_auth/auth_util.dart';

int sumOfTwoInt(
  int? int1,
  int? int2,
) {
  int one = 0;
  if (int1 != null) one = int1;
  int two = 0;
  if (int2 != null) two = int2;
  return one + two;
}

bool greaterThan(
  int value1,
  int value2,
) {
  return value1 > value2;
}

String getmonth(int monthInt) {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  return months[monthInt - 1];
}

DateTime getFirstDate() {
  DateTime now = DateTime.now();
  return now.subtract(Duration(
      days: now.day - 1,
      hours: now.hour,
      minutes: now.minute,
      seconds: now.second,
      milliseconds: now.millisecond));
}

bool checkIfMonthCrossedBy(DateTime lastDate) {
  return lastDate.month != DateTime.now().month;
}
