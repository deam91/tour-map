import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Color color;
  final String btnText;

  const RoundedButton(
      {Key? key,
      required this.color,
      required this.btnText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(50.0),
        child: MaterialButton(
          onPressed: () {},
          minWidth: 200.0,
          height: 60.0,
          child: Text(
            btnText,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
