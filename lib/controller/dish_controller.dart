import 'package:fresh_moment/model/dish.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DishController extends GetxController {
  RxList dishList = [].obs;
  List storageList = [];
  final storageBox = GetStorage();
  RxBool loading = false.obs;

  Future addDish(
      String id, String imageUrl, String dishName, double dishPrice) async {
    loading.value = true;
    Dish dish = Dish(
        id: id, imageUrl: imageUrl, dishName: dishName, dishPrice: dishPrice);
    dishList.add(dish);
    storageList.add(dish.toMap());
    await storageBox.write('dishes', storageList);
    Future.delayed(const Duration(milliseconds: 500), (() {
      loading.value = false;
    }));
  }

  Future restoreDish() async {
    loading.value = true;
    List dishes = storageBox.read('dishes') ?? [];
    for (var dish in dishes) {
      dishList.add(Dish.fromMap(dish));
      storageList.add(dish);
    }
    Future.delayed(const Duration(milliseconds: 500), (() {
      loading.value = false;
    }));
  }

  Future deleteDish(String id) async {
    loading.value = true;
    Dish dish = dishList.firstWhere((element) => element.id == id);
    dishList.remove(dish);
    storageList.remove(dish.toMap());
    await storageBox.write('dishes', storageList);
    Future.delayed(const Duration(milliseconds: 500), (() {
      loading.value = false;
    }));
  }
}
