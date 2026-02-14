import 'package:flutter/material.dart';

class OutlinedBtn extends StatelessWidget {
  final String title;final VoidCallback onTap;
  const OutlinedBtn({super.key, required this.title, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
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
