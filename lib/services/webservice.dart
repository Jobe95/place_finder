import 'dart:convert';

import 'package:place_finder/models/place.dart';
import 'package:place_finder/utils/urlHelper.dart';
import 'package:http/http.dart' as http;

class Webservice {
  Future<List<Place>> fetchPlacesByKeywordAndPosition(
      String keyword, double latitude, double longitude) async {
    final url =
        UrlHelper.urlForPLaceKeywordAndLocation(keyword, latitude, longitude);
    print('URL: $url');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final Iterable results = jsonResponse['results'];
      return results.map((place) => Place.fromJSON(place)).toList();
    } else {
      throw Exception('Gick ej att genomföra request');
    }
  }
}
