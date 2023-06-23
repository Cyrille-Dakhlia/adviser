import 'dart:convert';

import 'package:adviser/0_data/models/advice_model.dart';
import 'package:http/http.dart' as http;

abstract class AdviceRemoteDataSource {
  /// Request a random advice from API.
  ///
  /// - Returns [AdviceModel] if succesfull
  /// - Throws a server exception if status code is not 200
  Future<AdviceModel> getRandomAdviceFromApi();
}

const apiUri = 'https://api.flutter-community.com/api/v1/advice';

class AdviceRemoteDataSourceImpl implements AdviceRemoteDataSource {
  final client = http.Client();

  @override
  Future<AdviceModel> getRandomAdviceFromApi() async {
    final response = await client.get(
      Uri.parse(apiUri),
      headers: {'content-type': 'application/json'},
    );

    return AdviceModel.fromJson(jsonDecode(response.body));
  }
}