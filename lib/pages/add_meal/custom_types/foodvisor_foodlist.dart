import 'package:carbonet/pages/add_meal/foodvisor_vision.dart';

class FoodVisorFoodlist {
  final List<FoodItem> list;
  FoodItem? selected;

  FoodVisorFoodlist({required this.list}) {
    assert(list.isNotEmpty, "Provide a non-empty list");
    selected = list.reduce((curr, next) => curr.confidence > next.confidence ? curr : next);
  }
}