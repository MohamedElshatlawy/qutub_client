import 'package:flutter/foundation.dart';

class BottomNavProvider extends ChangeNotifier {
  int selectedIndex = 3;

  onTapClick(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  String getTabName() {
    switch (selectedIndex) {
      case 0:
        return 'الطلبات';
      case 1:
        return 'المفضلة';
      case 2:
        return 'المشتريات';
      case 3:
        return 'الرئيسية';
    }
    return '';
  }
}
