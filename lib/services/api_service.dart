import 'api.dart';
import 'package:http/http.dart' as http;

class APIService {
  APIService(this.api);
  final API api;

  Future<String> getBusinesses() async {
    final uri = api.searchUri();
    final response = await http.get(uri.toString(),
        headers: {'Authorization': 'Bearer ${api.apiKey}'});
    if (response.statusCode == 200) {
      return response.body.toString();
    }
    throw response;
  }
}
