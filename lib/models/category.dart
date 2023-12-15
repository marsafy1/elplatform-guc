import '../components/categories/category_icon.dart';

class Category {
  String name;
  CategoryIcon icon;
  bool selected = false;
  Function addCategory;
  Function removeCategory;

  Category(
      {required this.name,
      required this.icon,
      required this.addCategory,
      required this.removeCategory});
}
