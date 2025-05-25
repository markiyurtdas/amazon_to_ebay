import 'package:amazon_to_ebay/model/user_model.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  UserModel mUser = UserModel();

  Future<http.Response> createPostMethod(
      String url, Map<String, dynamic> data, Map<String, String> headers,
      {String? id}) {
    if (id != null) {
      url = url + id;
    }
    headers["Authorization"] = "Bearer ${mUser.ebayAccessToken}";
    return http.post(Uri.parse(url), headers: headers, body: data);
  }

  Future<http.Response> createPostMethodWithStringBody(
      String url, String data, Map<String, String> headers,
      {String? id}) {
    if (id != null) {
      url = url + id;
    }
    headers["Authorization"] = "Bearer ${mUser.ebayAccessToken}";
    return http.post(Uri.parse(url), headers: headers, body: data);
  }

  Future<http.Response> createPutMethod(
      String url, String data, Map<String, String> headers,
      {String? id}) {
    if (id != null) {
      url = url + id;
    }
    headers["Authorization"] = "Bearer ${mUser.ebayAccessToken}";
    return http.put(
      Uri.parse(url),
      headers: headers,
      body: data,
    );
  }

  Future<http.Response> createDeleteMethod(String url, Map<String, String> map,
      Map<String, String> headers, String id) async {
    headers["Authorization"] = "Bearer ${mUser.ebayAccessToken}";
    final http.Response response = await http.delete(
      Uri.parse('$url$id'),
      headers: headers,
    );

    return response;
  }

  Future<http.Response> createGetMethod(String url, Map<String, String> headers,
      {String? id}) {
    if (id != null) {
      url = url + id;
    }
    headers["Authorization"] = "Bearer ${mUser.ebayAccessToken}";
    return http.get(Uri.parse(url), headers: headers);
  }
}
