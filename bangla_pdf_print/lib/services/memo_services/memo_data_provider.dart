import 'dart:convert';

import 'package:CBD/service/memo_services/memo_apis.dart';
import 'package:http/http.dart' as http;

class MemoDataProvider {
  //--------------------- Memo Outlet List   ------------------------------
  Future<http.Response> memoOutletListDataProvider(
    String memoUrl,
    String cid,
    String userId,
    String userPass,
    String routeId,
    String deviceID,
    String depotId,
    String orderDate,
  ) async {
    Map<String, dynamic> body = {
      "cid": cid,
      "user_id": userId,
      "user_pass": userPass,
      "device_id": deviceID,
      "route_id": routeId,
      "depot_id": depotId,
      "delivery_date": orderDate,
    };

    final response = await http.post(
      Uri.parse(
        MemoApis().memoOutlitsApis(memoUrl),
      ),
      body: body,
    );

    return response;
  }

  //--------------------- memo ------------------------------
  Future<http.Response> memoDataProvider(
    String memoUrl,
    String cid,
    String userId,
    String userPass,
    String routeId,
    String deviceID,
    String depotId,
    String depotName,
    String orderSL,
  ) async {
    Map<String, dynamic> body = {
      "cid": cid,
      "user_id": userId,
      "user_pass": userPass,
      "route_id": routeId,
      "device_id": deviceID,
      "depot_id": depotId,
      "depot_name": depotId,
      "order_sl": orderSL,
    };

    // print("memo api----------------------${MemoApis().memoDetails(memoUrl)}");
    // print("memo body----------------------${jsonEncode(body)}");

    final response = await http.post(
      Uri.parse(
        MemoApis().memoDetails(memoUrl),
      ),
      body: body,
    );

    print("response----------------------${response.statusCode}");
    return response;
  }

  //-------------------- memo List --------------------------
  Future<http.Response> memoListByOrderSl(
    String memoUrl,
    String cid,
    String userId,
    String userPass,
    String routeId,
    String deviceID,
    String depotId,
    String depotName,
    String orderSlList,
  ) async {
    Map<String, dynamic> body = {
      "cid": cid,
      "user_id": userId,
      "user_pass": userPass,
      "route_id": routeId,
      "device_id": deviceID,
      "depot_id": depotId,
      "depot_name": depotId,
      "order_sl": orderSlList,
    };

    final response = await http.post(
      Uri.parse(
        MemoApis().memByOrderSl(memoUrl),
      ),
      body: body,
    );

    // print("response----------------------${response.statusCode}");

    return response;
  }
}
