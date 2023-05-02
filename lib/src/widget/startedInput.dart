import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StartedInput extends StatefulWidget {
  Function onChange;
  Function validator;
  bool obscureText = false;
  var icon = const Icon(
    Icons.person_outline_rounded,
    color: Colors.white,
  );

  StartedInput(
      {Key? key,
      required this.onChange,
      this.obscureText = false,
      required this.validator,
      this.icon = const Icon(
        null,
      ),
      this.text = ''})
      : super(key: key);
  String text = '';
  @override
  State createState() => StartedInputState();
}

class StartedInputState extends State<StartedInput> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _formKey,
      controller: controller,
      onChanged: (newIndex) {
        widget.onChange(newIndex);
      },
      obscureText: widget.obscureText,
      style: const TextStyle(color: Colors.black, fontSize: 11),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,

        fillColor: Colors.white, //<-- SEE HERE
        focusColor: Colors.white,
        //add prefix icon
        // contentPadding: const EdgeInsets.symmetric(vertical: 3), // <-- SEE HERE
        // prefixIcon: widget.icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(0.0),
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
