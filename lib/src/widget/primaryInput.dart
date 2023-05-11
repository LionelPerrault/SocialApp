import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PrimaryInput extends StatefulWidget {
  Function onChange;
  Function validator;
  String label;
  bool isObscure = true;
  bool obscureText = false;
  String initialValue = '';
  var icon = const Icon(
    Icons.person_outline_rounded,
    color: Colors.white,
  );
  var eyeIcon;
  PrimaryInput({
    Key? key,
    required this.onChange,
    required this.label,
    this.obscureText = false,
    required this.validator,
    required this.initialValue,
    this.icon = const Icon(
      null,
    ),
    this.eyeIcon,
  }) : super(key: key);
  @override
  State createState() => PrimaryInputState();
}

class PrimaryInputState extends State<PrimaryInput> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _formKey,
      onChanged: (newIndex) {
        widget.onChange(newIndex);
      },
      initialValue: widget.initialValue,
      obscureText: widget.obscureText,
      style: const TextStyle(
          color: Colors.white, fontSize: 14, fontFamily: "Hind"),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromRGBO(35, 35, 35, 1), //<-- SEE HERE
        focusColor: Colors.white,
        //add prefix icon
        contentPadding: const EdgeInsets.symmetric(vertical: 3), // <-- SEE HERE
        prefixIcon: widget.icon,
        suffixIcon: widget.eyeIcon,
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
        hintText: widget.label,
        //make hint text
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
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
        widget.validator(value);
        return null;
      },
    );
  }
}
