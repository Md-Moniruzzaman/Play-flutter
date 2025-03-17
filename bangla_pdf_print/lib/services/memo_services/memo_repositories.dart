import 'dart:convert';

import 'package:CBD/model/Memo/memo_details_data_model.dart';
import 'package:CBD/model/Memo/memo_list_by_sl_list.dart';
import 'package:CBD/model/Memo/memo_outlet_list_data_model.dart';
import 'package:CBD/service/all_services.dart';
import 'package:CBD/service/memo_services/memo_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MemoRepositories {
  //------------------------------ memo Outlet Screen -------------------------------
  Future<MemoOutletListDataModel?> getMomoOutletListRepositories(
    String memoUrl,
    String cid,
    String userId,
    String userPass,
    String routeId,
    String deviceID,
    String depotId,
    String orderDate,
  ) async {
    MemoOutletListDataModel? apiResponseData;
    try {
      final http.Response response = await MemoDataProvider()
          .memoOutletListDataProvider(memoUrl, cid, userId, userPass, routeId,
              deviceID, depotId, orderDate);
      var responseBody = json.decode(response.body);
      if (response.statusCode == 200 &&
          responseBody["status"] == "Successful") {
        apiResponseData = memoOutletListDataModelFromJson(response.body);
        return apiResponseData;
      } else {
        AllServices().dynamicToastMessage(
            responseBody["ret_str"].toString(), Colors.red, Colors.white, 14);
        return null;
      }
    } catch (e) {
      AllServices().dynamicToastMessage("$e", Colors.red, Colors.white, 14);
    }
    return null;
  }

//----------------------------- sl wise outlet info print--------------------------
  Future<MemoDetailsDataModel?> getMomoRepositories(
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
    MemoDetailsDataModel? apiResponseData;
    try {
      final http.Response response = await MemoDataProvider().memoDataProvider(
        memoUrl,
        cid,
        userId,
        userPass,
        routeId,
        deviceID,
        depotId,
        depotName,
        orderSL,
      );
      var responseBody = json.decode(response.body);

      if (response.statusCode == 200 &&
          responseBody["status"] == "Successful") {
        apiResponseData = memoDetailsDataModelFromJson(response.body);
        return apiResponseData;
      } else {
        AllServices().dynamicToastMessage(
            responseBody["ret_str"].toString(), Colors.red, Colors.white, 14);
        return null;
      }
    } catch (e) {
      print("$e");
      AllServices().dynamicToastMessage("$e", Colors.red, Colors.white, 14);
    }
    return null;
  }

//----------------------------- sl wise outlet info print--------------------------
  Future<MemoListBySlList?> getMemoOrderSl(
    String memoUrl,
    String cid,
    String userId,
    String userPass,
    String routeId,
    String deviceID,
    String depotId,
    String depotName,
    String orderSLlist,
  ) async {
    MemoListBySlList? apiResponseData;
    try {
      final http.Response response = await MemoDataProvider().memoListByOrderSl(
        memoUrl,
        cid,
        userId,
        userPass,
        routeId,
        deviceID,
        depotId,
        depotName,
        orderSLlist,
      );
      var responseBody = json.decode(response.body);
      print("responseBody  4----------------------$responseBody");

      if (response.statusCode == 200 &&
          responseBody["status"] == "Successful") {
        apiResponseData = memoListByOrderFromJson(response.body);

        return apiResponseData;
      } else {
        AllServices().dynamicToastMessage(
            responseBody["ret_str"].toString(), Colors.red, Colors.white, 14);
        return null;
      }
    } catch (e) {
      AllServices().dynamicToastMessage("$e", Colors.red, Colors.white, 14);
    }
    return null;
  }
}
