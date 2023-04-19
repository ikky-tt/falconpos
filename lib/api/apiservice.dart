import 'dart:convert';
import 'dart:async';
import 'package:dio/dio.dart';

import 'constant.dart';

class ApiSerivces {
  Dio _dio = Dio();

  ApiSerivces() {
    _dio = Dio();
    _dio.options.contentType = Headers.formUrlEncodedContentType;

  }

  Future LoginApi(String username, String password) async {
    try {
      print(url);
      Response res = await _dio.post(url + '/loginapp',
          data: {
            'username': username,
            'password': password,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        print(res);
        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  Future chklogin(id) async {
    try {

      Response res = await _dio.post(url + '/chklogin',
          data: {
            'id': id,
          },
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        print(res);
        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future Invoicesub() async {
    try {
      Response res = await _dio.get(url + '/getputaway',
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

  Future UpdateStatusinvoice(id) async {
    try {
      Response res = await _dio.post(url + '/updatestatusinvo',
          data: {'id': id},
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

  Future PickupOrder() async {
    try {
      Response res = await _dio.get(url + '/getpickuporder',
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

  Future PickupSub(docno) async {
    try {
      Response res = await _dio.post(url + '/getpickup',
          data: {'docno': docno},
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

  Future UpdateStatusStockout(id, docno) async {
    try {
      Response res = await _dio.post(url + '/updatestatusstockout',
          data: {'id': id, 'docno': docno},
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

  Future CheckLot(lotid) async {
    try {
      Response res = await _dio.post(url + '/chklot',
          data: {'lotid': lotid},
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

  Future companyinfo() async {
    try {
      Response res = await _dio.post(url + '/companyinfo',
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

  Future saleorder(docno) async {
    try {
      Response res = await _dio.post(url + '/saleorder',
          data: {'docno': docno},
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

  Future saleorderSub(docno) async {
    try {
      Response res = await _dio.post(url + '/saleordersub',
          data: {'docno': docno},
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

  Future PackingOrder() async {
    try {
      Response res = await _dio.get(url + '/getpacking',
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

  Future PackingUpdate(id) async {
    try {
      Response res = await _dio.post(url + '/updatepacksub',
          data: {'id': id},
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

  Future PackingUpdatecanel(id) async {
    try {
      Response res = await _dio.post(url + '/updatepacksubcancel',
          data: {'id': id},
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

  Future Packingchkstatus(docno) async {
    try {
      Response res = await _dio.post(url + '/chkstatupacking',
          data: {'id': docno},
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

  Future batchpick() async {
    try {
      Response res = await _dio.post(url + '/batchpickupapi',
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

  Future batchpicksub(docno) async {
    try {
      Response res = await _dio.post(url + '/batchpickupapisub',
          data: {'docno': docno},
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

  Future batchpicksubchk(docno) async {
    try {
      Response res = await _dio.post(url + '/batchpickupapisubchk',
          data: {'docno': docno},
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

  Future GetProudct(scr) async {
    try {
      Response res = await _dio.post(url + '/getprodcutapi',
          data: {'scr': scr},
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

  Future GetProudctde(id) async {
    try {
      Response res = await _dio.post(url + '/getprodcutapide',
          data: {'id': id},
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

  Future updateProudctpostion(id, pid) async {
    try {
      Response res = await _dio.post(url + '/updateproductposition',
          data: {'id': id, 'pid': pid},
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

  Future updatetoken(id, token) async {
    try {
      Response res = await _dio.post(url + '/updatetoken',
          data: {'id': id, 'token': token},
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

  Future newOrder() async {
    try {
      Response res = await _dio.post(url + '/newordershow',
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

  Future newpickshow() async {
    try {
      Response res = await _dio.post(url + '/orderpickshowapi',
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

  Future newsentshow() async {
    try {
      Response res = await _dio.post(url + '/ordersentshowapi',
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

  Future OrederNewConfirm() async {
    try {
      Response res = await _dio.post(url + '/newordershowapi',
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

  Future UpdateStatusNeworder(id, docno) async {
    try {
      Response res = await _dio.post(url + '/updatastatusstockapi',
          data: {'gencode': docno, 'empname': 'app'},
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

  Future UpdateStatusNeworderchk(id, docno) async {
    try {
      Response res = await _dio.post(url + '/chkinvostatusstock',
          data: {'gencode': id},
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

  Future newPutAway() async {
    try {
      Response res = await _dio.post(url + '/newputaway',
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

  Future CoustomerShow(scr, start, stop) async {
    try {
      Response res = await _dio.post(url + '/apicustomer',
          data: {'scr': scr, 'start': start, 'stop': stop},
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

  Future CoustomerShowSelect(scr) async {
    try {
      Response res = await _dio.post(url + '/apicustomerselect',
          data: {'scr': scr},
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

  Future GetProductPos(scr, branchid) async {
    try {
      Response res = await _dio.post(url + '/apiproductscrpos',
          data: {'scr': scr, 'branchid': branchid},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        // print(res);

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future GetSalechanel() async {
    try {
      Response res = await _dio.post(url + '/selectsalechanel',
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        // print(res);

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future GetBranch() async {
    try {
      Response res = await _dio.post(url + '/selectbranch',
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        // print(res);
        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future GetProductsku(scr, branchid) async {
    try {
      Response res = await _dio.post(url + '/apiproductscrpossku',
          data: {'scr': scr, 'branchid': branchid},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        // print(res);

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future GetProductid(id, branchid) async {
    try {
      Response res = await _dio.post(url + '/apiproductscrposid',
          data: {'id': id, 'branchid': branchid},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        // print(res);

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future updateaddserail(gencode, serialnumber) async {
    try {
      Response res = await _dio.post(url + '/apiupdateserialpossub',
          data: {'gencode': gencode, 'serialnumber': serialnumber},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        // print(res);

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future Getserailbranch(branchid) async {
    try {
      Response res = await _dio.post(url + '/getbranchserial',
          data: {'branchid': branchid,},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        // print(res);

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future updateserailbranch(brachid,serialnumber) async {
    try {
      Response res = await _dio.post(url + '/updatebranchserail',
          data: {'brachid': brachid,'serialnumber':serialnumber},
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        // print(res);

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }
  Future GetProducttype() async {
    try {
      Response res = await _dio.post(url + '/apiproducttype',
          options: Options(contentType: Headers.formUrlEncodedContentType));

      if (res.statusCode == 200) {
        print(res);

        return res;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print(e);
    }
  }

  Future Coustomeradd(
      name,
      lname,
      tel,
      email,
      gender,
      purpose,
      age,
      birthday,
      social,
      country,
      address,
      province,
      district,
      subdistrict,
      zipcode,
      remark) async {
    try {
      Response res = await _dio.post(url + '/apicustomeradd',
          data: {
            'name': name,
            'email': email,
            'tel': tel,
            'lname': lname,
            'purpose': purpose,
            'birthday': birthday,
            'address': address,
            'district': district,
            'subdistrict': subdistrict,
            'province': province,
            'zip': zipcode,
            'country': country,
            'age': age,
            'social': social,
            'gender': gender,
            'remark':remark
          },
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

  Future Coustomeredit(
      id,
      name,
      lname,
      tel,
      email,
      gender,
      purpose,
      age,
      birthday,
      social,
      country,
      address,
      province,
      district,
      subdistrict,
      zipcode,
      remark) async {
    try {
      Response res = await _dio.post(url + '/apicustomerupdate',
          data: {
            'id': id,
            'name': name,
            'email': email,
            'tel': tel,
            'lname': lname,
            'purpose': purpose,
            'birthday': birthday,
            'address': address,
            'district': district,
            'subdistrict': subdistrict,
            'province': province,
            'zip': zipcode,
            'country': country,
            'age': age,
            'social': social,
            'gender': gender,
            'remark':remark
          },
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

  Future Coustomerdel(id) async {
    try {
      Response res = await _dio.post(url + '/apicustomerdel',
          data: {
            'id': id,
          },
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

  Future ApiDocno() async {
    try {
      Response res = await _dio.post(url + '/apidocno',
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

  Future AddItem(
      docno, proid, sku, name, qty, price, totprice, dicount, wh) async {
    try {
      Response res = await _dio.post(url + '/inserttmppos',
          data: {
            "docno": docno,
            "proid": proid,
            "sku": sku,
            "name": name,
            "qty": qty,
            "price": price,
            "totprice": price,
            "dicount": dicount,
            "wh": wh
          },
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

  Future UpDateItem(id, qty, totprice) async {
    try {
      Response res = await _dio.post(url + '/updatepos',
          data: {"id": id, "qty": qty, "totprice": totprice},
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

  Future DeleteItem(id) async {
    try {
      Response res = await _dio.post(url + '/apidelsuptmp',
          data: {"id": id},
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

  Future ContChart(docno) async {
    try {
      Response res = await _dio.post(url + '/apicountcart',
          data: {
            "docno": docno,
          },
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

  Future SumChart(docno) async {
    try {
      Response res = await _dio.post(url + '/apisumpos',
          data: {
            "docno": docno,
          },
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

  Future ShowChart(docno) async {
    try {
      Response res = await _dio.post(url + '/apiposshow',
          data: {
            "docno": docno,
          },
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

  Future PosAdd(docno, gencode, custid, custcode, custname, sum, tax, befortax,
      disconut, branch, branchid, wh, emp) async {
    try {
      Response res = await _dio.post(url + '/apiposadd',
          data: {
            "docno": docno,
            "gencode": gencode,
            "customerid": custid,
            "customercode": custcode,
            "cusotomername": custname,
            "tax": tax,
            "befortax": befortax,
            "disconut": disconut,
            "sum": sum,
            "branch": branch,
            "branchid": branchid,
            "wh": wh,
            "emp": emp
          },
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
  Future PosAdd2(docno, gencode, custid, custcode, custname, sum, tax, befortax,
      disconut, branch, branchid, wh, emp,salechanel,DateTime date) async {
    try {
      Response res = await _dio.post(url + '/apiposaddmodifie',
          data: {
            "docno": docno,
            "gencode": gencode,
            "customerid": custid,
            "customercode": custcode,
            "cusotomername": custname,
            "tax": tax,
            "befortax": befortax,
            "disconut": disconut,
            "sum": sum,
            "branch": branch,
            "branchid": branchid,
            "wh": wh,
            "emp": emp,
            "salech":salechanel,
            "date":date
          },
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

  Future PosReportapi(start, stop ,branchid) async {
    try {
      Response res = await _dio.post(url + '/posreportsaleorder',
          data: {"datestart": start, "datestop": stop,"branchid":branchid},
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
  Future PosReportapiAll(start, stop ,branchid) async {
    try {
      Response res = await _dio.post(url + '/posreportsaleorderall',
          data: {"datestart": start, "datestop": stop ,"branchid":branchid},
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

  Future PosReportsumapi(start, stop , branchid) async {
    try {
      Response res = await _dio.post(url + '/posreportsaleordersum',
          data: {"datestart": start, "datestop": stop,"branchid":branchid},
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
  Future PosReportsumitemapi(start, stop,branchid) async {
    try {
      Response res = await _dio.post(url + '/posreportsaleordersumitem',
          data: {"datestart": start, "datestop": stop,"branchid":branchid},
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

  Future UpdatePayment(id, pay, payment) async {
    try {
      Response res = await _dio.post(url + '/updatepayment',
          data: {'id': id, 'pay': pay, 'payment': payment},
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

  Future PosAddNote(id, text) async {
    try {
      Response res = await _dio.post(url + '/apiposaddnote',
          data: {'id': id, 'text': text},
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
  Future Updatestockoutapi(gencode, empname) async {
    try {
      Response res = await _dio.post(url + '/updatestockoutapi',
          data: {'gencode': gencode, 'payment': empname},
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
  Future CanelOrer(gencode) async {
    try {
      Response res = await _dio.post(url + '/poscancelorder',
          data: {'gencode': gencode},
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

  Future settingslip(name, vatid, tel, address1, address2, endline1, endline2,
      endline3, ip, brach) async {
    try {
      Response res = await _dio.post(url + '/settingslip',
          data: {
            'name': name,
            'vatid': vatid,
            'tel': tel,
            'address1': address1,
            'address2': address2,
            'endline1': endline1,
            'endline2': endline2,
            'endline3': endline3,
            'ip': ip,
            'brach': 'สาขาที่ 1'
          },
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

  Future settingselectslip(brach) async {
    try {
      Response res = await _dio.post(url + '/setectprintslipsetting',
          data: {'brach': 'สาขาที่ 1'},
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

  Future branchshowstock(proid) async {
    try {
      Response res = await _dio.post(url + '/branchshowstock',
          data: {'proid': proid},
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
  Future logoout(id,name) async {
    try {
      Response res = await _dio.post(url + '/logout',
          data: {'id': id,'name':name},
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
  Future CycelCountapi(proid,qty,wh,branchid,branchname,datetime,empname) async {
    try {
      Response res = await _dio.post(url + '/cycelcount',
          data: {'proid': proid,'wh':wh,'branchid':branchid,'branchname':branchname,'date':datetime,'empname':empname,'qty':qty},
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
  Future ChekCycelcount(proid,date,branchid,wh) async {
    try {
      Response res = await _dio.post(url + '/chkecyclecount',
          data: {'proid': proid,'wh':wh,'branchid':branchid,'date':date},
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

  Future ReportDetailDay(start, stop ,branchid) async {
    try {
      Response res = await _dio.post(url + '/reportdetailday',
          data: {"datestart": start, "datestop": stop,"branchid":branchid},
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
  Future ReportDetailDaygencode(gencode) async {
    try {
      Response res = await _dio.post(url + '/apigetreportdaybyid',
          data: {"gencode":gencode},
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
  Future ReportDetailDaygencodeimg(gencode) async {
    try {
      Response res = await _dio.post(url + '/apigetreportdayimgbyid',
          data: {"gencode":gencode},
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
  Future ReportDetailDaydel(gencode) async {
    try {
      Response res = await _dio.post(url + '/apigetreportdaydel',
          data: {"gencode":gencode},
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