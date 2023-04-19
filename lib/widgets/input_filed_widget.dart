import 'package:flutter/material.dart';

class InputFiledWidget extends StatelessWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final bool? enabled;
  final bool? readOnly;

  const InputFiledWidget(
      {super.key,
      required this.title,
      required this.hint,
      required this.controller,
      this.suffixIcon,
      this.enabled,
      this.readOnly});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormField(
              readOnly: readOnly??false,
              controller: controller,
              enabled: enabled,
              validator: (value) {
                if (value?.isEmpty ?? false) {
                  return '$title is missing';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: suffixIcon,
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                ),
                disabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.all(Radius.circular(20.0),),
                ),
                filled: true,
              ),
            ),
      ],
    );
  }
}
