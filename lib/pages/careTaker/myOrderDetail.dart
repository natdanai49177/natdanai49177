import 'package:flutter/material.dart';
import 'package:take_ama/models/Order.dart';
import 'package:take_ama/services/OrderAPI.dart';
import 'package:take_ama/utils/storageLocal.dart';
import 'package:take_ama/pages/careTaker/myOrder.dart';

class MyOrderDetail extends StatefulWidget {
  const MyOrderDetail({Key? key}) : super(key: key);

  @override
  State<MyOrderDetail> createState() => _MyOrderDetailState();
}

class _MyOrderDetailState extends State<MyOrderDetail> {
  @override
  Widget build(BuildContext context) {
    OrderDetail order =
    ModalRoute.of(context)!.settings.arguments as OrderDetail;
    return Scaffold(
      appBar: AppBar(title: const Text('Status')),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Visibility(
            visible: order.orderStatus == 'pending' &&
                globalProfile!.userType == '2',
            child: ElevatedButton(
              child: const Text('Accept'),
              onPressed: () {
                updateStatus("1", order.id!);
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            child: const Text('Reject'),
            onPressed: () {
              updateStatus("9", order.id!);
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: const Text('Complete'),
            onPressed: () {
              updateStatus("2", order.id!);
            },
          ),
        ],
      ),
    );
  }

  updateStatus(String status, String orderId) async {
    await OrderAPI.update(orderId, status);
    Navigator.pop(context);
  }
}
