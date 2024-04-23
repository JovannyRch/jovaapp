import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String fullName;
  final Color backgroundColor;
  final Color textColor;
  final double radius;

  Avatar({
    required this.fullName,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.radius = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    String initials = getInitials(fullName);

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Text(
        initials,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String getInitials(String name) {
    List<String> names = name.split(' ');
    String initials = '';
    if (names.length > 1) {
      initials = names[0][0] +
          names[1][
              0]; // Tomar la primera letra de los dos primeros nombres/palabras
    } else if (names.isNotEmpty) {
      initials = names[0][0]; // Solo hay un nombre, tomar la primera letra
    }
    return initials.toUpperCase();
  }
}
