import 'dart:convert';

class WebViewValuesModel {
  String version;
  String fileName;

  WebViewValuesModel({this.version = '', this.fileName = ''});

  static WebViewValuesModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static WebViewValuesModel fromDynamic(dynamic dynamicData) {
    final model = WebViewValuesModel();

    model.version = dynamicData['version'];
    model.fileName = dynamicData['file_name'];
    return model;
  }

  factory WebViewValuesModel.mapFromJson(Map<String, dynamic> json) {
    return WebViewValuesModel.fromDynamic(json);
  }

  Map<String, dynamic> toJson() {
    return {"version": version, "file_name": fileName};
  }
}
