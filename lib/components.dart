import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class OpenSans extends StatelessWidget {
  final text;
  final size;
  final color;
  final fontWeight;

  const OpenSans(
      {super.key,
      required this.text,
      required this.size,
      this.color,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      style: GoogleFonts.openSans(
        fontSize: size,
        fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
        color: color == null ? Colors.black : color,
      ),
    );
  }
}

class Poppins extends StatelessWidget {
  final text;
  final size;
  final color;
  final fontWeight;
  const Poppins(
      {super.key,
      required this.text,
      required this.size,
      this.color,
      this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toString(),
      style: GoogleFonts.poppins(
        fontSize: size,
        color: color == null ? Colors.black : color,
        fontWeight: fontWeight == null ? FontWeight.normal : fontWeight,
      ),
    );
  }
}

class TextForm extends StatelessWidget {
  final text;
  final containerWidth;
  final hintText;
  final controller;
  final digitsOnly;
  final validator;
  const TextForm({
    super.key,
    required this.text,
    required this.containerWidth,
    required this.hintText,
    required this.controller,
    this.digitsOnly,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OpenSans(text: text, size: 13.0),
        SizedBox(
          height: 5.0,
        ),
        SizedBox(
          width: containerWidth,
          child: TextFormField(
            controller: controller,
            validator: validator,
            // null hoile sokol character rakhte parbo r null na hoile sudhu digits nibe
            inputFormatters: digitsOnly != null
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            decoration: InputDecoration(
              hintStyle: GoogleFonts.poppins(fontSize: 13.0),
              hintText: hintText,
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.red),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(color: Colors.teal),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                borderSide: BorderSide(color: Colors.tealAccent, width: 2.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}

// show dialogue
DialogBox(BuildContext context, String title) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(32.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(width: 2.0, color: Colors.black),
      ),
      title: OpenSans(text: title, size: 20.0),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          color: Colors.black,
          child: OpenSans(
            text: 'Okay',
            size: 20.0,
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
