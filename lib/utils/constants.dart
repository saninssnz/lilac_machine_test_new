import 'package:flutter/material.dart';

const primaryColor = Color(0xFFFFB900);

InputDecoration buildInputDecoration({String? hintText, Widget? suffixIcon,String? labelText}) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide:
      BorderSide(style: BorderStyle.none, color: Colors.grey.shade100),
    ),
    fillColor: Colors.white,
    alignLabelWithHint: true,
    isDense: true,
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: primaryColor),
      borderRadius: BorderRadius.circular(10),
    ),
    contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
    hintText: hintText,
    suffixIcon: suffixIcon,
    labelText: labelText,
    labelStyle:  TextStyle(
        color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
    counter: Text(""),
    hintStyle: TextStyle(
        color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w500),
  );
}

List<String> videosList = [
  "https://drive.google.com/file/d/13HzPDMq6aTK2o2rK6jNBIdJFTxBhViNj/view?usp=drive_link",
  "https://drive.google.com/file/d/1J-jzixZa8vMvXxZWMBoL8dzlKTmfNMTO/view?usp=drive_link",
  "https://drive.google.com/file/d/1A0xr7FVG05h8LeeAEnA0RzWQOy8n-R0g/view?usp=drive_link"
];