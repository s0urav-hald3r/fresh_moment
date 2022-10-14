import 'package:get/get.dart';

class CartController extends GetxController {
  RxList cartList = [].obs;
  Map itemCount = {}.obs;

  addDish(String dishId) {
    cartList.add(dishId);
    if (itemCount.containsKey(dishId)) {
      itemCount.update(dishId, (value) => value + 1);
    } else {
      itemCount.addAll({dishId: 1});
    }
  }

  removeDish(String dishId) {
    if (cartList.contains(dishId)) {
      cartList.remove(dishId);
      itemCount.update(dishId, (value) => value - 1);
    }
  }

  reserCart() {
    cartList.clear();
    itemCount.clear();
  }

  get cartLength => cartList.length;
}
