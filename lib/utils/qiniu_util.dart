import 'dart:async';

import 'package:flutter/services.dart';

typedef onData = void Function(dynamic event);

class QiniuUtil {
  static const MethodChannel _channel =
      const MethodChannel('sy_flutter_qiniu_storage');
  static const EventChannel _eventChannel =
      const EventChannel('sy_flutter_qiniu_storage_event');

  Stream _onChanged;

  Stream onChanged() {
    if (_onChanged == null) {
      _onChanged = _eventChannel.receiveBroadcastStream();
    }
    return _onChanged;
  }

  ///上传
  ///
  /// key 保存到七牛的文件名
  Future<bool> upload(String filepath, String token, String key) async {
    var res = await _channel.invokeMethod('upload',
        <String, String>{"filepath": filepath, "token": token, "key": key});
    return res;
  }

  /// 取消上传
  static cancelUpload() {
    _channel.invokeMethod('cancelUpload');
  }

  // var putPolicy = {
  //   'scope': 'my-bucket:sunflower.jpg',
  //   'deadline': 1451491200,
  //   'returnBody':
  //       r'''{"name":$(fname),"size":$(fsize),"w":$(imageInfo.width),"h":$(imageInfo.height),"hash":$(etag)}''', // 这是个已经经过一次序列化的 json 字符串!!!
  // };
  // var putPolicyJson = jsonEncode(putPolicy);
  // Log.i("序列完成之后的结果为:");
  // Log.i(putPolicyJson);
  // var putPolicyByte = utf8.encode(putPolicyJson);
  // var putPolicyBase64 = base64UrlEncode(putPolicyByte);
  // Log.i("base64encode 之后的结果为:" + putPolicyBase64);

  // var hasher = new Hmac(sha1, utf8.encode("MY_SECRET_KEY"));
  // var sign = hasher.convert(utf8.encode(putPolicyBase64));
  // var sign2 = hasher.convert(putPolicyByte);

  // Log.i("签名结果分别为:");
  // Log.i("${sign.bytes}");
  // Log.i("${sign2.bytes}");

  // if (sign.bytes == sign2.bytes) {
  //   Log.i("两种签名相等");
  // } else {
  //   Log.i("两种签名不等");
  // }

  // var demoByte = base64Decode(
  //     "eyJzY29wZSI6Im15LWJ1Y2tldDpzdW5mbG93ZXIuanBnIiwiZGVhZGxpbmUiOjE0NTE0OTEyMDAsInJldHVybkJvZHkiOiJ7XCJuYW1lXCI6JChmbmFtZSksXCJzaXplXCI6JChmc2l6ZSksXCJ3XCI6JChpbWFnZUluZm8ud2lkdGgpLFwiaFwiOiQoaW1hZ2VJbmZvLmhlaWdodCksXCJoYXNoXCI6JChldGFnKX0ifQ==");

  // var demoJson = utf8.decode(demoByte);
  // Log.i("demo 的原始字符串为:" + demoJson);
  // if (putPolicyJson == demoJson) {
  //   Log.i("两值相等");
  // } else {
  //   Log.i("两值不等");
  // }
}
