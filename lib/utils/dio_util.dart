import 'dart:convert';

import 'package:chat/api/api.dart';
import 'package:chat/utils/base_entity.dart';
import 'package:chat/utils/log_util.dart';
import 'package:chat/utils/net_error_handle.dart';
import 'package:chat/utils/token_util.dart';
import 'package:chat/utils/net_intercept.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioUtil {
  static final DioUtil _singleton = DioUtil._internal();

  static DioUtil get instance => DioUtil();

  factory DioUtil() {
    return _singleton;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  DioUtil._internal() {
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

    /// Fiddler抓包代理配置 https://www.jianshu.com/p/d831b1f7c45b
//    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//        (HttpClient client) {
//      client.findProxy = (uri) {
//        //proxy all request to localhost:8888
//        return "PROXY 10.41.0.132:8888";
//      };
//      client.badCertificateCallback =
//          (X509Certificate cert, String host, int port) => true;
//    };
    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());

    /// 刷新Token
    // _dio.interceptors.add(TokenInterceptor());
    /// 打印Log(生产模式去除)
    TokenUtil.getEnvironment().then((res) {
      if (res != "production") {
        _dio.interceptors.add(LoggingInterceptor());
      }
    });

    /// 适配数据(根据自己的数据结构，可自行选择添加)
    _dio.interceptors.add(AdapterInterceptor());
  }

  // 数据返回格式统一，统一处理异常
  Future<BaseEntity<T>> _request<T>(String method, String url,
      {dynamic data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    String storageUrl = "";
    await TokenUtil.getEnvironment().then((res) {
      if (res == "dev") {
        Log.e('进入此处');
        storageUrl = Api.DEV_BASE_URL;
        url = Api.DEV_BASE_URL + url;
      } else {
        Log.e('进入此处2');
        storageUrl = Api.BASE_URL;
        url = Api.BASE_URL + url;
      }
    });

    var response = await _dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    try {
      /// 集成测试无法使用 isolate
      Map<String, dynamic> _map = Api.isTest
          ? parseData(response.data.toString())
          : await compute(parseData, response.data.toString());
      return BaseEntity.fromJson(_map, storageUrl);
    } catch (e) {
      print(e);
      return BaseEntity(
          ExceptionHandle.parse_error, "数据解析错误", null, null, null, null);
    }
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  Future requestNetwork<T>(Method method, String url,
      {Function(BaseEntity<T> t) onSuccess,
      Function(int code, String msg) onError,
      dynamic params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options,
      bool isList: false}) async {
    String m = _getRequestMethod(method);
    return await _request<T>(m, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken)
        .then((BaseEntity<T> result) {
      if (result.ret == 1) {
        if (onSuccess != null) {
          onSuccess(result);
        }
      } else {
        _onError(result.ret, result.message, onError);
      }
    }, onError: (e, _) {
      _cancelLogPrint(e, url);
      NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回List<T>)
  asyncRequestNetwork<T>(Method method, String url,
      {Function(T t) onSuccess,
      Function(List<T> list) onSuccessList,
      Function(int code, String msg) onError,
      dynamic params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options,
      bool isList: false}) {
    String m = _getRequestMethod(method);
    //此处原来使用 rxdart 进行异步请求,后来 Observable 移除,改为了原生的
    Stream.fromFuture(_request<T>(m, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken))
        .asBroadcastStream()
        .listen((result) {
      if (result.ret == 1) {
        if (onSuccess != null) {
          onSuccess(result.data);
        }
      } else {
        _onError(result.ret, result.message, onError);
      }
    }, onError: (e) {
      _cancelLogPrint(e, url);
      NetError error = ExceptionHandle.handleException(e);
      _onError(error.code, error.msg, onError);
    });
  }

  _cancelLogPrint(dynamic e, String url) {
    if (e is DioError && CancelToken.isCancel(e)) {
      Log.i("取消请求接口： $url");
    }
  }

  _onError(int code, String msg, Function(int code, String mag) onError) {
    Log.e("接口请求异常： code: $code, msg: $msg");
    if (onError != null) {
      onError(code, msg);
    }
  }

  String _getRequestMethod(Method method) {
    String m;
    switch (method) {
      case Method.get:
        m = "GET";
        break;
      case Method.post:
        m = "POST";
        break;
      case Method.put:
        m = "PUT";
        break;
      case Method.patch:
        m = "PATCH";
        break;
      case Method.delete:
        m = "DELETE";
        break;
      case Method.head:
        m = "HEAD";
        break;
    }
    return m;
  }
}

Map<String, dynamic> parseData(String data) {
  return json.decode(data);
}

enum Method { get, post, put, patch, delete, head }
