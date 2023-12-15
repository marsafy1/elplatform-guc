import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/category_item.dart';

class CategoryManager {
  static final CategoryManager _instance = CategoryManager._internal();

  factory CategoryManager() {
    return _instance;
  }

  CategoryManager._internal();

  final Map<String, CategoryItem> categoriesMap = {
    "all": CategoryItem(name: 'All', icon: FontAwesomeIcons.newspaper),
    "met": CategoryItem(name: 'MET', icon: FontAwesomeIcons.computer),
    "iet": CategoryItem(name: 'IET', icon: FontAwesomeIcons.networkWired),
    "bi": CategoryItem(name: 'BI', icon: FontAwesomeIcons.moneyBill),
    "mgmt": CategoryItem(name: 'MGMT', icon: FontAwesomeIcons.calendar),
    "pharmacy": CategoryItem(name: 'Pharmacy', icon: FontAwesomeIcons.store),
  };
}
