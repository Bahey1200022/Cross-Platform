import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider =
    StateProvider<bool>((ref) => false); // Initially not authenticated
