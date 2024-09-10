import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Backgroud extends StatelessWidget {
  const Backgroud({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: const AssetImage("assets/images/football.jpg"),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.3), BlendMode.dstATop),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
