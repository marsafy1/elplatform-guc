import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/category_item.dart';

class LostAndFoundsManager {
  static final LostAndFoundsManager _instance =
      LostAndFoundsManager._internal();

  factory LostAndFoundsManager() {
    return _instance;
  }

  LostAndFoundsManager._internal();

  final Map<String, CategoryItem> categoriesMap = {
    "all": CategoryItem(name: 'All', icon: FontAwesomeIcons.newspaper),
    "phones": CategoryItem(name: 'Phones', icon: FontAwesomeIcons.phone),
    "cards": CategoryItem(name: 'Cards', icon: FontAwesomeIcons.creditCard),
    "money": CategoryItem(name: 'Money', icon: FontAwesomeIcons.moneyBill),
    "keys": CategoryItem(name: 'Keys', icon: FontAwesomeIcons.key),
    "books": CategoryItem(name: 'Books', icon: FontAwesomeIcons.book),
  };
}
