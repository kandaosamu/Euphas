import 'package:euphas/config/constants.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton(
      {super.key, required this.title, required this.enabled, required this.onPressed});

  final String title;
  final bool enabled;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: screenWidth * 0.8,
      height: screenHeight * 0.6,
      child: InkWell(
        onTap: () => enabled ? onPressed() : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Card(
            child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(title,style: big,),
                    !enabled ? Container(color: Colors.grey.withOpacity(0.5)) : const SizedBox.shrink(),
                    !enabled ? const Icon(Icons.lock) : const SizedBox.shrink()
                  ],
                )),
          ),
        ),
      ),
    );
  }
}