import 'package:flutter/material.dart';
import 'package:take_ama/models/Order.dart';
import 'package:take_ama/models/UserLogin.dart';
import 'package:take_ama/pages/careTaker/myOrderDetail.dart';
import 'package:take_ama/services/OrderAPI.dart';
import 'package:take_ama/utils/storageLocal.dart';
import 'package:take_ama/utils/validatefield.dart';

class CaretakerDetailPage extends StatefulWidget {
  const CaretakerDetailPage({Key? key}) : super(key: key);

  @override
  State<CaretakerDetailPage> createState() => _CaretakerDetailPageState();
}

class _CaretakerDetailPageState extends State<CaretakerDetailPage> {
  var txtAmount = TextEditingController();
  var txtHours = TextEditingController();
  OrderDetail orderDetail = OrderDetail();

  @override
  Widget build(BuildContext context) {
    Profile profile = ModalRoute.of(context)!.settings.arguments as Profile;
    return Scaffold(
      appBar: AppBar(
        title: const Text('CareTaker'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 15,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              "Name: ${profile.firstName} ${profile.lastName}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(profile.detail ?? ''),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: txtHours,
              onChanged: (String? v) {
                v = v ?? "";
                if (int.tryParse(v) != null) {
                  double amount = double.parse(v) * 150;
                  txtAmount.text = '$amount';
                }
                if (v == '') {
                  txtAmount.text = '0';
                }
                setState(() {});
              },
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "จำนวนชั่วโมง",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              controller: txtAmount,
              readOnly: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  String? validateString =
                  ValidateField.validateNumber(txtAmount.text);
                  print('$validateString ${txtAmount.text}');
                  if (validateString == null) {
                    orderDetail.amaName = globalProfile!.firstName!;
                    orderDetail.price = txtAmount.text;
                    orderDetail.hours = txtHours.text;
                    orderDetail.careTaker = profile.id;

                    createOrder();
                    Navigator.pop(context);
                  }
                },
                child: const Text("Confirm"),
              ),
            ],
          )
        ],
      ),
    );
  }

  void createOrder() async {
    await OrderAPI.create(orderDetail, globalProfile!.id!);
  }
}
