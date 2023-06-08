import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Decoration? decoration;
  final VoidCallback onPressed;
  final Widget child;

  const CustomIconButton({
    Key? key,
    this.decoration,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: IconButton(
        onPressed: onPressed,
        icon: child,
      ),
    );
  }
}
