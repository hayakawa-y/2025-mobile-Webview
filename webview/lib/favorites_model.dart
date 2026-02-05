import 'package:flutter/foundation.dart';


class FavoritesModel extends ChangeNotifier {

  final Set<int> _favoriteIndices = {};


  bool isFavorite(int itemNo) {
    return _favoriteIndices.contains(itemNo);
  }


  void toggleFavorite(int itemNo) {
    if (_favoriteIndices.contains(itemNo)) {
      _favoriteIndices.remove(itemNo);
    } else {
      _favoriteIndices.add(itemNo);
    }

    notifyListeners();
  }
}
