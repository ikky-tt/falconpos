import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:falconpos/model/modelthaiprovince.dart';

class ProvincModel {
  dynamic? id;
  String? code;
  String? nameTh;
  String? nameEn;
  dynamic geographyId;

  ProvincModel(
      {this.id, this.code, this.nameTh, this.nameEn, this.geographyId});

  factory ProvincModel.fromJson(Map<dynamic, dynamic> json) =>
      ProvincModel(
        id: json["id"],
        code: json["code"],
        nameTh: json["name_th"],
        nameEn: json["name_en"],
        geographyId: json["geography_id"],
      );

  static List<ProvincModel> fromJsonList(List list) {
    return list.map((item) => ProvincModel.fromJson(item)).toList();
  }


}

class AmphuresModel {
  dynamic? id;
  String? code;
  String? nameTh;
  String? nameEn;
  dynamic? province_id;

  AmphuresModel(
      {this.id, this.code, this.nameTh, this.nameEn, this.province_id});


  factory AmphuresModel.fromJson(Map<dynamic, dynamic> json) =>
      AmphuresModel(
          id: json["id"],
          code: json["code"],
          nameTh: json["name_th"],
          nameEn: json["name_en"],
          province_id: json['province_id']
      );

  static List<AmphuresModel> fromJsonList(List list) {
    return list.map((item) => AmphuresModel.fromJson(item)).toList();
  }


}

class DistricModel {
  dynamic? id;
  String? zip_code;
  String? nameTh;
  String? nameEn;
  dynamic? amphure_id;

  DistricModel({this.id, this.zip_code, this.nameTh, this.nameEn, this.amphure_id});


  factory DistricModel.fromJson(Map<dynamic, dynamic> json) =>
      DistricModel(
          id: json["id"],
          zip_code: json["zip_code"],
          nameTh: json["name_th"],
          nameEn: json["name_en"],
          amphure_id: json["amphure_id"]

      );

  static List<DistricModel> fromJsonList(List list) {
    return list.map((item) => DistricModel.fromJson(item)).toList();
  }


}

class ApiSerivcesProvice {

  late Dio _dio;

  ApiSerivcesProvice() {
    _dio = Dio();
    _dio.options.contentType = Headers.formUrlEncodedContentType;

  }
  String apiUrl = 'https://vpos.falconcirrus.com:4100/assets/json/dbpv.json';
  Future getProvieJson() async {
    try {
      Response res = await _dio.get('https://vpos.falconcirrus.com:4100/assets/json/dbpv.json',
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future getProvie(scr) async {
    try {
      Response res = await _dio.post(apiUrl, data: {'key': "provinc",'scr':scr},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  Future getAmp(code,scr) async {
    try {
      Response res = await _dio.post(
          apiUrl, data: {'key': "amphures", 'code': code,'scr':scr},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  Future getdistric(code,scr) async {
    try {
      Response res = await _dio.post(
          apiUrl, data: {'key': "districts", 'code': code,'scr':scr},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }

}

Future<List<ProvincModel>> getDataProvice(String filter) async {
  var res = await ApiSerivcesProvice().getProvie(filter);
  Iterable list = json.decode(res.data);

  List<ProvincModel> models = list.map((item) => ProvincModel.fromJson(item))
      .toList();

  //print(models.length);

  return models;
}

Future<List<AmphuresModel>> getDataAmp(code,scr) async {
  var res = await ApiSerivcesProvice().getAmp(code,scr);
  Iterable list = json.decode(res.data);

  List<AmphuresModel> models = list.map((item) => AmphuresModel.fromJson(item))
      .toList();

  //print(models.length);

  return models;
}

Future<List<DistricModel>> getDataDistir(code,scr) async {
  var res = await ApiSerivcesProvice().getdistric(code,scr);
  Iterable list = json.decode(res.data);
  print(list);
  print(list.runtimeType);
  List<DistricModel> models = list.map((item) => DistricModel.fromJson(item))
      .toList();
  //print(models.length);
  return models;
}

Future<List<Thaiprovice>> getThaiProvince(scr) async {


  var res = await ApiSerivcesProvice().getProvieJson();
  Iterable list = res.data;


  List<Thaiprovice> models = list.map((item) => Thaiprovice.fromJson(item))
      .toList();

  List<Thaiprovice> md = models.where((e) {

    return  e.province.contains(scr) ||  e.amphoe.contains(scr) ||  e.district.contains(scr) ||  e.zipcode.toString().contains(scr);

  }).toList();
  print(md.length);
  return md;


}