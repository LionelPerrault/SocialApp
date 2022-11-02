import 'dart:ui';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrimaryInput extends StatelessWidget {
  PrimaryInput(
      {super.key,
      required this.onChange,
      required this.label,
      required this.icon});
  final GestureTapCallback onChange;
  String label;
  var icon = const Icon(
    Icons.person_outline_rounded,
    color: Colors.white,
  );
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (newIndex) {
        onChange();
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(35, 35, 35, 1), //<-- SEE HERE
        focusColor: Colors.white,
        //add prefix icon
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10), // <-- SEE HERE
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.grey, width: 0.1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide(color: Colors.grey, width: 0.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 0.1),
          borderRadius: BorderRadius.circular(20.0),
        ),
        hintText: label,
        //make hint text
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontFamily: "verdana_regular",
          fontWeight: FontWeight.w400,
        ),

        //create lable
      ),
      onSaved: (String? value) {
        // This optional block of code can be used to run
        // code when the user saves the form.
      },
      validator: (String? value) {
        return (value != null && value.contains('@'))
            ? 'Do not use the @ char.'
            : null;
      },
    );
  }
}
