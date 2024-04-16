import 'package:sarakel/Widgets/drawers/community_drawer/list_controller.dart';
import 'package:sarakel/models/community.dart';

Future<List<Community>> fetchSuggestions(String query) async {
  List<Community> suggestions = await loadCircles();
  suggestions = suggestions
      .where(
          (element) => element.name.toLowerCase().contains(query.toLowerCase()))
      .toList();

  return suggestions;
}
