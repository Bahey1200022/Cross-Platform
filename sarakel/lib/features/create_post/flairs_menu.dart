import 'package:flutter/material.dart';

class FlairsMenu extends StatefulWidget {
  final Function(bool) onSpoilerChanged;
  final Function(bool) onNSFWChanged;
  final Function(bool) onBAChanged;

  const FlairsMenu(
      {super.key,
      required this.onSpoilerChanged,
      required this.onNSFWChanged,
      required this.onBAChanged});

  @override
  // ignore: library_private_types_in_public_api
  _FlairsMenuState createState() => _FlairsMenuState();
}

class _FlairsMenuState extends State<FlairsMenu> {
  bool nsfw = false;
  bool spoiler = false;
  bool brandAffiliate = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: ListView(
        shrinkWrap: true,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Universal tags',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          SwitchListTile(
            title: const Text(
              'Not Safe for Work (NSFW)',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'Tag posts with sensitive or adult content',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            value: nsfw,
            onChanged: (bool value) {
              setState(() {
                nsfw = value;
              });
              // Handle NSFW tag toggle
              widget.onNSFWChanged(nsfw);
            },
            activeColor: Colors.blue,
            secondary: const Icon(Icons.no_adult_content, color: Colors.black),
          ),
          SwitchListTile(
            title: const Text(
              'Spoiler',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'Tag posts that may ruin a surprise',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            value: spoiler,
            onChanged: (bool value) {
              setState(() {
                spoiler = value;
              });
              // Handle Spoiler tag toggle
              widget.onSpoilerChanged(spoiler); // Notify parent widget
            },
            activeColor: Colors.blue,
            secondary:
                const Icon(Icons.warning_amber_outlined, color: Colors.black),
          ),
          SwitchListTile(
            title: const Text(
              'Brand Affiliate',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'Made for a brand or business',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
            value: brandAffiliate,
            onChanged: (bool value) {
              setState(() {
                brandAffiliate = value;
              });
              // Handle Brand Affiliate tag toggle
              widget.onBAChanged(brandAffiliate);
            },
            activeColor: Colors.blue,
            secondary:
                const Icon(Icons.monetization_on_outlined, color: Colors.black),
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}
