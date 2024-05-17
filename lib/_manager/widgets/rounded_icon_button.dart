import 'package:flutter/material.dart';

class RoundedIconBtn extends StatelessWidget {
  const RoundedIconBtn({
    Key? key,
    required this.bgColor,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  final Color bgColor;
  final IconData icon;
  final Color iconColor;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            color: bgColor, borderRadius: BorderRadius.circular(30)),
        child: Icon(
          icon,
          color: iconColor,
        ),
      ),
    );
  }
}

class ColoredRoundedSquare extends StatelessWidget {
  const ColoredRoundedSquare({
    Key? key,
    required this.edge,
    required this.color,
    this.isSquare = true,
    this.height = 0.0,
    this.child,
  }) : super(key: key);

  final double edge;
  final Color color;
  final bool isSquare;
  final double height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Container(
            width: edge,
            height: isSquare ? edge : height,
            color: color,
            child: child));
  }
}
