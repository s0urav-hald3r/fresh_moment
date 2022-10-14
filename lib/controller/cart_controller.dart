import 'package:fresh_moment/controller/dish_controller.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxList cartList = [].obs;
  Map itemCount = {}.obs;
  double totalPrice = 0.0;

  DishController dishController = Get.find<DishController>();

  addDish(String dishId) {
    cartList.add(dishId);
    if (itemCount.containsKey(dishId)) {
      itemCount.update(dishId, (value) => value + 1);
    } else {
      itemCount.addAll({dishId: 1});
    }
    totalPrice += dishController.dishList
        .firstWhere((element) => element.id == dishId)
        .dishPrice;
  }

  removeDish(String dishId) {
    if (cartList.contains(dishId)) {
      cartList.remove(dishId);
      itemCount.update(dishId, (value) => value - 1);
    }
    totalPrice -= dishController.dishList
        .firstWhere((element) => element.id == dishId)
        .dishPrice;
  }

  reserCart() {
    cartList.clear();
    itemCount.clear();
    totalPrice = 0.0;
  }

  get cartLength => cartList.length;
  get totalCartPrice => totalPrice;
}
