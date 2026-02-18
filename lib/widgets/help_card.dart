import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HelpCard extends ConsumerStatefulWidget {
  final VoidCallback? onTap;
  final String title;
  final String subtitle;
  final String assetPath;
  const HelpCard(
    this.title,
    this.subtitle,
    this.assetPath,
    this.onTap, {
    super.key,
  });

  @override
  ConsumerState<HelpCard> createState() => _HelpCardState();
}

class _HelpCardState extends ConsumerState<HelpCard> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: screenWidth * 0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(31, 112, 112, 112),
              blurRadius: 10.0,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Row(
            children: [
              Image.asset(
                widget.assetPath,
                fit: BoxFit.contain,
                height: 32,
                width: 32,
              ),
              SizedBox(width: 26),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontFamily: 'SFProText',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      fontFamily: 'SFProText',
                      fontSize: 10,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 22,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
