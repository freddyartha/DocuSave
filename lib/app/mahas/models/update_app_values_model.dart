import 'dart:convert';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

class UpdateappvaluesModel {
  String? version;
  bool? mustUpdate;
  String? urlUpdate;
  int? dismissDuration;

  UpdateappvaluesModel();

  static UpdateappvaluesModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static UpdateappvaluesModel fromDynamic(dynamic dynamicData) {
    final model = UpdateappvaluesModel();

    model.version = dynamicData['version'];
    model.mustUpdate = InputFormatter.dynamicToBool(dynamicData['must_update']);
    model.urlUpdate = dynamicData['url_update'];
    model.dismissDuration = InputFormatter.dynamicToInt(
      dynamicData['dismiss_duration'],
    );

    return model;
  }

  factory UpdateappvaluesModel.mapFromJson(Map<String, dynamic> json) {
    return UpdateappvaluesModel.fromDynamic(json);
  }

  Map<String, dynamic> toJson() {
    return {
      "version": version,
      "must_update": mustUpdate,
      "url_update": urlUpdate,
      "dismiss_duration": dismissDuration,
    };
  }
}
