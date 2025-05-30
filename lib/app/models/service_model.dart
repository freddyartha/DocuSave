import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';

Map<String, dynamic> serviceModelToJson(ServiceModel data) => data.toJson();

class ServiceModel {
  String documentid;
  String productname;
  Timestamp servicedate;
  String storename;
  String? problemdescription;
  String? servicedescription;
  double price;
  String currency;
  int? warrantyperioddays;
  Timestamp? warrantyexpirydate;
  List<String> beforeserviceimages;
  List<String> afterserviceimages;
  int servicestatus;
  Timestamp? pickupdate;
  bool? pickupremindersent;
  bool? warrantyremindersent;
  Timestamp createdat;
  Timestamp? updatedat;

  ServiceModel({
    required this.documentid,
    required this.productname,
    required this.servicedate,
    required this.storename,
    this.problemdescription,
    this.servicedescription,
    required this.price,
    required this.currency,
    this.warrantyperioddays,
    this.warrantyexpirydate,
    required this.beforeserviceimages,
    required this.afterserviceimages,
    required this.servicestatus,
    this.pickupdate,
    this.pickupremindersent,
    this.warrantyremindersent,
    required this.createdat,
    this.updatedat,
  });

  static ServiceModel fromJson(String jsonString) {
    final data = json.decode(jsonString);
    return fromDynamic(data);
  }

  static ServiceModel fromDynamic(dynamic dynamicData) {
    final model = ServiceModel(
      documentid: dynamicData['documentId'],
      productname: dynamicData['productName'],
      servicedate:
          InputFormatter.dynamicToTimestamp(dynamicData['serviceDate']) ??
          Timestamp.now(),
      storename: dynamicData['storeName'],
      problemdescription: dynamicData['problemDescription'],
      servicedescription: dynamicData['serviceDescription'],
      price: InputFormatter.dynamicToDouble(dynamicData['price']) ?? 0,
      currency: dynamicData['currency'],
      warrantyperioddays: InputFormatter.dynamicToInt(
        dynamicData['warrantyPeriodDays'],
      ),
      warrantyexpirydate: InputFormatter.dynamicToTimestamp(
        dynamicData['warrantyExpiryDate'],
      ),
      beforeserviceimages: [],
      afterserviceimages: [],
      servicestatus:
          InputFormatter.dynamicToInt(dynamicData['serviceStatus']) ?? 0,
      pickupdate: InputFormatter.dynamicToTimestamp(dynamicData['pickUpDate']),
      pickupremindersent: InputFormatter.dynamicToBool(
        dynamicData['pickUpReminderSent'],
      ),
      warrantyremindersent: InputFormatter.dynamicToBool(
        dynamicData['warrantyReminderSent'],
      ),
      createdat:
          InputFormatter.dynamicToTimestamp(dynamicData['createdAt']) ??
          Timestamp.now(),
      updatedat:
          InputFormatter.dynamicToTimestamp(dynamicData['updatedAt']) ??
          Timestamp.now(),
    );
    if (dynamicData['beforeServiceImages'] != null) {
      final detailT = dynamicData['beforeServiceImages'];
      for (var e in detailT) {
        model.beforeserviceimages.add(e);
      }
    }
    if (dynamicData['afterServiceImages'] != null) {
      final detailT = dynamicData['afterServiceImages'];
      for (var e in detailT) {
        model.afterserviceimages.add(e);
      }
    }

    return model;
  }

  Map<String, dynamic> toJson() => {
    'documentId': documentid,
    'productName': productname,
    'serviceDate': servicedate,
    'storeName': storename,
    'problemDescription': problemdescription,
    'serviceDescription': servicedescription,
    'price': price,
    'currency': currency,
    'warrantyPeriodDays': warrantyperioddays,
    'warrantyExpiryDate': warrantyexpirydate,
    'beforeServiceImages': beforeserviceimages,
    'afterServiceImages': afterserviceimages,
    'serviceStatus': servicestatus,
    'pickUpDate': pickupdate,
    'pickUpReminderSent': pickupremindersent,
    'warrantyReminderSent': warrantyremindersent,
    'createdAt': createdat,
    'updatedAt': updatedat,
  };
}
