import 'package:easy_container/easy_container.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shnatter/src/helpers/helper.dart';
import 'package:shnatter/src/widget/mprimary_button.dart';

class PhoneNumberScreen extends StatefulWidget {
  static const id = 'PhoneNumberScreen';
  Function onBack;

  PhoneNumberScreen({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PhoneNumberScreenState createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  String? phoneNumber;

  final _formKey = GlobalKey<FormState>();
  bool isNullOrBlank(String? data) => data?.trim().isEmpty ?? true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "We'll send an SMS with a verification code...",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 15),
          EasyContainer(
            elevation: 0,
            borderRadius: 10,
            child: Form(
              key: _formKey,
              child: IntlPhoneField(
                autofocus: true,
                invalidNumberMessage: 'Invalid Phone Number!',
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(fontSize: 18),
                onChanged: (phone) => phoneNumber = phone.completeNumber,
                initialCountryCode: 'US',
                flagsButtonPadding: const EdgeInsets.only(right: 10),
                showDropdownIcon: false,
                keyboardType: TextInputType.phone,
              ),
            ),
          ),
          const SizedBox(height: 15),
          MyPrimaryButton(
            onPressed: () async {
              if (isNullOrBlank(phoneNumber) ||
                  !_formKey.currentState!.validate()) {
                Helper.showToast('Please enter a valid phone number!');
              } else {
                widget.onBack(phoneNumber);
              }
            },
            buttonName: "Verify",
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
