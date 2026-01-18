import 'package:flutter/material.dart';

class OutlinedBtn extends StatelessWidget {
  final String title;
  const OutlinedBtn({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
        foregroundColor: WidgetStatePropertyAll<Color>(Colors.black),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontFamily: 'SFProText',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down_outlined),
        ],
      ),
    );
  }
}
