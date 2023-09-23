import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final texttheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "404",
              style: texttheme.titleLarge!.copyWith(
                color: Colors.black,
              ),
            ),
            Text(
              "Terjadi kesalahan",
              style: texttheme.titleSmall!.copyWith(
                color: Colors.black,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
