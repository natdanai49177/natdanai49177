import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Order.dart';
import 'IPservice.dart';

class OrderAPI {
  static String url = IPGlobalService.url;

  static Future<String> create(OrderDetail order, String amaId) async {
    var urlRegister = Uri.parse('$url/api/order/create.php');
    var response = await http.post(
      urlRegister,
      headers: {
        'Content-Type': 'application/json',
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode({
        "careTakerId": order.careTaker,
        "hours": order.hours,
        "price": order.price,
        "amaId": amaId,
      }),
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result["message"];
    }
    return "Something went wrong";
  }

  static Future<String> update(String orderId, String status) async {
    var urlRegister = Uri.parse('$url/api/order/update.php');
    var response = await http.post(
      urlRegister,
      headers: {
        'Content-Type': 'application/json',
      },
      encoding: Encoding.getByName('utf-8'),
      body: jsonEncode(
        {"orderId": orderId, "status": status},
      ),
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result["message"];
    }
    return "Something went wrong";
  }

  static Future<OrderDetail?> getById(
      {required String id, String userType = '2'}) async {
    var urlRegister = Uri.parse(
        '$url/api/order/read_single.php?userType=$userType&userId=$id');
    var response = await http.get(
      urlRegister,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      try {
        final result = jsonDecode(response.body);
        var value = result.toString();
        if(value == "{message: No order Found}") return null;
        return OrderDetail.fromJson(result);
      }
      catch (error) {
        var msg = jsonDecode(response.body)["message"];
      }
      return null;
    }
    return null;
  }
}
