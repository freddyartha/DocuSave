import 'dart:convert';

import 'package:docusave/app/mahas/constants/input_formatter.dart';

class WebViewValuesModel {
  int version;
  int prevVersion;
  String fileName;

  WebViewValuesModel({
    this.version = 0,
    this.prevVersion = 0,
    this.fileName = '',
  });

  static WebViewValuesModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static WebViewValuesModel fromDynamic(dynamic dynamicData) {
    final model = WebViewValuesModel();

    model.version = InputFormatter.dynamicToInt(dynamicData['version']) ?? 0;
    model.prevVersion =
        InputFormatter.dynamicToInt(dynamicData['prev_version']) ?? 0;
    model.fileName = dynamicData['file_name'];
    return model;
  }

  factory WebViewValuesModel.mapFromJson(Map<String, dynamic> json) {
    return WebViewValuesModel.fromDynamic(json);
  }

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "prev_version": prevVersion,
      "file_name": fileName,
    };
  }
}
