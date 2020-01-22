import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:chat/api/api.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/net_intercept.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

///TODO: 每个用户应该上传到自己的文件夹!!!
class QiniuUtil {
  //七牛的请求
  static const String QINIU_UPLOAD = 'http://up-z2.qiniup.com';

  static const String QINIU_STORAGE_URL = 'http://qiniu.tomtiddler.top/';

  static final QiniuUtil _singleton = QiniuUtil._internal();

  static QiniuUtil get instance => QiniuUtil();

  factory QiniuUtil() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  QiniuUtil._internal() {
    var options = BaseOptions(
      connectTimeout: 25000,
      receiveTimeout: 30000,
      responseType: ResponseType.plain,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      // baseUrl: baseUrl,
    );
    _dio = Dio(options);

    _dio.interceptors.add(LoggingInterceptor());
  }

  uploadImageTest() async {
    Log.i("上传图片测试进入此处");
    String token = await Api.getQiNiuToken();
    Log.i("获取到七牛临时的 token 为: $token");

    FormData formData = new FormData.fromMap({
      "token": token,
      //文件存入七牛会重新命名,所以此处并不指定对应的
      "file": await MultipartFile.fromFile(
        "/Users/tomtiddler/Code/flutter-code/chat/images/avatar1.jpg",
      ),
    });
    _dio.options.headers['content-type'] = "multipart/form-data";
    Response response = await _dio.post(QINIU_UPLOAD, data: formData);
    Log.i("返回的结果为: ${response.data}");
  }

  Future<String> uploadImage(Uint8List bytes) async {
    String token = await Api.getQiNiuToken();
    FormData formData = new FormData.fromMap({
      "token": token,
      //文件存入七牛会重新命名,所以此处并不指定对应的
      "file": await MultipartFile.fromBytes(bytes),
    });
    _dio.options.headers['content-type'] = "multipart/form-data";
    Response response = await _dio.post(QINIU_UPLOAD, data: formData);

    var data = jsonDecode(response.data);
    if (data['key'] != null) {
      return data['key'];
    }
    return "";
  }

  static String getImageFullPath(String key) {
    return QINIU_STORAGE_URL + key;
  }
}
