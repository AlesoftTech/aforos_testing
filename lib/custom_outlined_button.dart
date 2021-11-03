import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomOutlinedButton extends StatelessWidget {

  final Function onPressed;
  final String text;
  final Color color;
  final Color textColor;
  final bool isFilled;

  const CustomOutlinedButton({Key? key,
    required this.onPressed,
    required this.text,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    required this.isFilled
  }) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
        ),
        side: MaterialStateProperty.all(
          BorderSide(color: color)
        ),
        backgroundColor:MaterialStateProperty.all(
            isFilled ? color : Colors.transparent
        ),
      ),
        onPressed: ()=>onPressed(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 16,
            color: this.textColor
          ),
        ),
      ),
    );
  }
}
