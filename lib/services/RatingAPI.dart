import 'dart:convert';
import 'package:http/http.dart' as http;

import 'IPservice.dart';

class RatingAPI {
  static String url = IPGlobalService.url;
  static Future<String> updateRating(
      {required String username, required double? ratingstart}) async {
    var urlApi = Uri.parse('$url/api/rating/create.php');
    final response = await http.post(urlApi,
        headers: {
          'Content-Type': 'application/json',
        },
        encoding: Encoding.getByName('utf-8'),
        body: jsonEncode({
          'user_id': username,
          'star': ratingstart,
        }));
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result['message'];
    }
    return "Something went wrong";
  }

  static Future<double> getRating() async {
    var urlGetStarRating = Uri.parse('$url/api/rating/read.php');
    var response = await http.get(
      urlGetStarRating,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      var value = double.tryParse(result['total_star'].toString());
      double rating = value ?? 0;
      return rating;
    }
    return 0;
  }
}
