import 'package:flutter/material.dart';

class NSFWButton extends StatelessWidget {
  final bool isNSFW;

  const NSFWButton({super.key, required this.isNSFW});

  @override
  Widget build(BuildContext context) {
    return isNSFW
        ? ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(90, 10), // Set the button size to 100x30
              disabledBackgroundColor: Colors.red,
              textStyle: const TextStyle(
                fontSize: 10,
                color: Colors.white,
              ),
            ),
            child: const Text(
              'NSFW',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          )
        : const SizedBox(); // Returns an empty SizedBox if isNSFW is false
  }
}
