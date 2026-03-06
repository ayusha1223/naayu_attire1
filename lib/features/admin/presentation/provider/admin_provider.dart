import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/admin/domain/usecases/get_orders.dart';

class AdminProvider extends ChangeNotifier {

  final GetOrdersUsecase getOrdersUsecase;

  AdminProvider(this.getOrdersUsecase);

  List orders = [];
  bool loading = false;

  Future<void> loadOrders() async {

    loading = true;
    notifyListeners();

    orders = await getOrdersUsecase();

    loading = false;
    notifyListeners();

  }

}