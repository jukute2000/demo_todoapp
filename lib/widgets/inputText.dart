import 'package:flutter/material.dart';

class inputText extends StatelessWidget {
  const inputText(
      {super.key,
      required this.keyboardType,
      required this.labelText,
      required this.icons,
      required this.controller,
      required this.check});
  final TextInputType keyboardType;
  final String labelText;
  final IconData icons;
  final TextEditingController controller;
  final bool check;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        keyboardType: keyboardType,
        controller: controller,
        obscureText: check,
        style: const TextStyle(fontSize: 20),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icons,
            size: 36,
          ),
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
          filled: true,
          fillColor: Colors.grey.shade200,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
