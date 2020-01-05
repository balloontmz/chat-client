class BaseEntity<T> {
  int ret;
  String message;
  T data;
  T localization;
  T meta;
  String storageUrl;

  BaseEntity(this.ret, this.message, this.data, this.meta, this.localization,
      this.storageUrl);

  BaseEntity.fromJson(Map<String, dynamic> json, String url) {
    ret = json["ret"];
    message = json["msg"];
    storageUrl = url;
    if (json.containsKey("data")) {
      if (T.toString() == "String") {
        data = json["data"].toString() as T;
      } else if (T.toString() == "Map<dynamic, dynamic>") {
        data = json["data"] as T;
      } else {
        data = json["data"];
      }
    }

    if (json.containsKey("localization")) {
      if (T.toString() == "String") {
        localization = json["localization"].toString() as T;
      } else if (T.toString() == "Map<dynamic, dynamic>") {
        localization = json["localization"] as T;
      } else {
        localization = json["localization"];
      }
    }

    if (json.containsKey("meta")) {
      if (T.toString() == "String") {
        meta = json["meta"].toString() as T;
      } else if (T.toString() == "Map<dynamic, dynamic>") {
        meta = json["meta"] as T;
      } else {
        meta = json["meta"];
      }
    }
  }
}
