import 'package:flutter/material.dart';

class BrandAffiliate extends StatelessWidget {
  final bool isBA;

  const BrandAffiliate({super.key, required this.isBA});

  @override
  Widget build(BuildContext context) {
    return isBA
        ? ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              fixedSize: const Size(90, 10), // Set the button size to 100x30
              disabledBackgroundColor: Colors.grey,
              textStyle: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            child: const Text(
              'Brand Affiliate',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          )
        : const SizedBox(); // Returns an empty SizedBox if isNSFW is false
  }
}
