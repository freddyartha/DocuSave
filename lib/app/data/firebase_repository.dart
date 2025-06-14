import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/article_model.dart';
import 'package:docusave/app/models/receipt_model.dart';
import 'package:docusave/app/models/service_model.dart';
import 'package:docusave/app/models/suggestion_model.dart';
import 'package:docusave/app/models/user_devices_model.dart';
import 'package:docusave/app/models/user_model.dart';
import 'package:docusave/app/models/user_notification_model.dart';
import 'package:docusave/app/models/warranty_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

enum ImageLocationType {
  profile,
  receipt,
  warranty,
  beforeService,
  afterService,
}

class FirebaseRepository {
  static String userCollection = 'users';
  static String notificationTokensCollection = 'notificationTokens';
  static String userDevicesCollection = 'userDevices';
  static String articlesCollection = 'articles';
  static String receiptCollection = 'receipts';
  static String warrantyCollection = 'warranties';
  static String suggestionsCollection = 'suggestions';
  static String servicesCollection = 'services';

  //queries
  static final getToReceiptCollection = FirebaseFirestore.instance.collection(
    "$userCollection/${auth.currentUser?.uid}/$receiptCollection",
  );
  static final getToWarrantyCollection = FirebaseFirestore.instance.collection(
    "$userCollection/${auth.currentUser?.uid}/$warrantyCollection",
  );
  static final getToServiceCollection = FirebaseFirestore.instance.collection(
    "$userCollection/${auth.currentUser?.uid}/$servicesCollection",
  );

  static Future<bool> checkUserExist(String userId) async {
    try {
      DocumentSnapshot snapshot =
          await firestore.collection(userCollection).doc(userId).get();

      if (snapshot.exists) {
        MahasConfig.userProfile = UserModel.fromDynamic(
          snapshot.data() as Map<String, dynamic>,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> addUserToFirestore({required UserModel userModel}) async {
    try {
      bool isExist = await checkUserExist(userModel.userid);
      if (!isExist) {
        await firestore
            .collection(userCollection)
            .doc(userModel.userid)
            .set(userModelToJson(userModel));
        await checkUserExist(userModel.userid);
      }
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
    }
  }

  static Future<bool> updateUserProfile({required UserModel userModel}) async {
    try {
      await firestore
          .collection(userCollection)
          .doc(userModel.userid)
          .update(userModelToJson(userModel));
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<String?> saveImageToFirebaseStorage({
    required ImageLocationType imageLocationType,
    required String fileName,
    required File imageFile,
    Function()? onErrorFunction,
  }) async {
    try {
      Reference storageRef = _getFirebaseStorageRef(
        imageLocationType: imageLocationType,
        fileName: fileName,
      );

      //hapus gambar jika sudah ada kemudian upload ulang
      await _checkAndDeleteFileIfExist(fileRef: storageRef);

      // Upload file
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      // Dapatkan URL gambar
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      ReusableWidgets.notifBottomSheet(
        title: "failed_upload_image".tr,
        subtitle: e.toString(),
      );
      onErrorFunction;
      return null;
    }
  }

  static String getFileNameWithoutExtension(String url) {
    Uri uri = Uri.parse(url);
    String fullPath = Uri.decodeFull(
      uri.path.split('/o/').last.split('?').first,
    );
    String fileNameWithExtension = fullPath.split('/').last;
    String fileName = fileNameWithExtension.split('.').first;
    return fileName;
  }

  static Future<void> removeImageFromFirebaseStorage({
    required ImageLocationType imageLocationType,
    required String fileName,
  }) async {
    try {
      //hapus gambar jika sudah ada kemudian upload ulang
      await _checkAndDeleteFileIfExist(
        fileRef: _getFirebaseStorageRef(
          imageLocationType: imageLocationType,
          fileName: fileName,
        ),
      );
    } catch (e) {
      ReusableWidgets.notifBottomSheet(
        title: "failed_upload_image".tr,
        subtitle: e.toString(),
      );
    }
  }

  static Reference _getFirebaseStorageRef({
    required ImageLocationType imageLocationType,
    required String fileName,
  }) {
    Reference storageRef;
    if (imageLocationType == ImageLocationType.profile) {
      storageRef = firebaseStorage.child('profile/$fileName.jpg');
    } else if (imageLocationType == ImageLocationType.receipt) {
      storageRef = firebaseStorage.child('receipt/$fileName.jpg');
    } else if (imageLocationType == ImageLocationType.warranty) {
      storageRef = firebaseStorage.child('warranty/$fileName.jpg');
    } else if (imageLocationType == ImageLocationType.beforeService) {
      storageRef = firebaseStorage.child('before_service/$fileName.jpg');
    } else {
      storageRef = firebaseStorage.child('after_service/$fileName.jpg');
    }
    return storageRef;
  }

  static Future<bool> _checkIfFileExists(Reference fileRef) async {
    try {
      await fileRef.getDownloadURL();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> _checkAndDeleteFileIfExist({
    required Reference fileRef,
  }) async {
    bool isExist = await _checkIfFileExists(fileRef);
    if (isExist) {
      try {
        await fileRef.delete();
      } catch (e) {
        ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      }
    }
  }

  static Future<bool> checkUserNotificationExist(
    String userId,
    String? notificationToken,
  ) async {
    try {
      DocumentSnapshot snapshot =
          await firestore
              .collection(userCollection)
              .doc(userId)
              .collection(notificationTokensCollection)
              .doc(notificationToken)
              .get();
      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> addUserNotificationToken({
    required UserNotificationModel userNotificationModel,
    required String userId,
  }) async {
    try {
      bool isExist = await checkUserNotificationExist(
        userId,
        userNotificationModel.notificationToken,
      );
      if (!isExist) {
        await firestore
            .collection(userCollection)
            .doc(userId)
            .collection(notificationTokensCollection)
            .doc(userNotificationModel.notificationToken)
            .set(userNotificationModelToJson(userNotificationModel));
      }
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
    }
  }

  static Future<bool> checkUserDeviceExist(
    String userId,
    String? deviceId,
  ) async {
    try {
      DocumentSnapshot snapshot =
          await firestore
              .collection(userCollection)
              .doc(userId)
              .collection(userDevicesCollection)
              .doc(deviceId)
              .get();
      if (snapshot.exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> addUserDeviceInfo(String userId) async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      bool isExist = await checkUserDeviceExist(userId, androidInfo.id);
      if (!isExist) {
        await _addUserDeviceFirestore(
          androidInfo.id,
          userId,
          UserDevicesModel(
            device: androidInfo.device,
            deviceName: androidInfo.name,
            brand: androidInfo.brand,
            os: androidInfo.version.release,
            isPhysicalDevice: androidInfo.isPhysicalDevice,
            lastLogin: Timestamp.now(),
            createdat: Timestamp.now(),
          ),
        );
      } else {
        await _updateUserDeviceLastLogin(androidInfo.id, userId);
      }
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      bool isExist = await checkUserDeviceExist(
        userId,
        iosInfo.identifierForVendor ?? iosInfo.name,
      );
      if (!isExist) {
        await _addUserDeviceFirestore(
          iosInfo.identifierForVendor ?? iosInfo.name,
          userId,
          UserDevicesModel(
            device: iosInfo.utsname.machine,
            deviceName: iosInfo.name,
            brand: "apple",
            os: iosInfo.systemVersion,
            isPhysicalDevice: iosInfo.isPhysicalDevice,
            lastLogin: Timestamp.now(),
            createdat: Timestamp.now(),
          ),
        );
      } else {
        await _updateUserDeviceLastLogin(
          iosInfo.identifierForVendor ?? iosInfo.name,
          userId,
        );
      }
    }
  }

  static Future<void> _addUserDeviceFirestore(
    String deviceId,
    String userId,
    UserDevicesModel userDevicesModel,
  ) async {
    try {
      await firestore
          .collection(userCollection)
          .doc(userId)
          .collection(userDevicesCollection)
          .doc(deviceId)
          .set(userDevicesModelToJson(userDevicesModel));
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
    }
  }

  static Future<void> _updateUserDeviceLastLogin(
    String deviceId,
    String userId,
  ) async {
    try {
      await firestore
          .collection(userCollection)
          .doc(userId)
          .collection(userDevicesCollection)
          .doc(deviceId)
          .update({"lastLogin": Timestamp.now()});
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
    }
  }

  static Future<List<ArticleModel>?> getArticles() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection(articlesCollection).get();
      return snapshot.docs
          .map(
            (doc) =>
                ArticleModel.fromDynamic(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return null;
    }
  }

  //suggestions
  static Future<bool> addSuggestionToFirestore({
    required SuggestionModel suggestionModel,
  }) async {
    try {
      await firestore
          .collection(suggestionsCollection)
          .doc(suggestionModel.documentid)
          .set(suggestionModelToJson(suggestionModel));
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  //Receipt
  static Future<bool> addReceiptToFirestore({
    required String userUid,
    required ReceiptModel receiptModel,
  }) async {
    try {
      await firestore
          .collection("$userCollection/$userUid/$receiptCollection")
          .doc(receiptModel.documentid)
          .set(receiptModelToJson(receiptModel));
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<bool> updateReceiptById({
    required String userUid,
    required ReceiptModel receiptModel,
  }) async {
    try {
      await firestore
          .collection("$userCollection/$userUid/$receiptCollection")
          .doc(receiptModel.documentid)
          .update(receiptModelToJson(receiptModel));
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<ReceiptModel?> getReceiptById({
    required String documentId,
    required String userUid,
  }) async {
    try {
      var result =
          await firestore
              .collection("$userCollection/$userUid/$receiptCollection")
              .doc(documentId)
              .get();

      return ReceiptModel.fromDynamic(result.data());
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return null;
    }
  }

  static Future<bool> deleteReceiptById({
    required String documentId,
    required String userUid,
  }) async {
    try {
      await firestore
          .collection("$userCollection/$userUid/$receiptCollection")
          .doc(documentId)
          .delete();
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  //Warranty
  static Future<bool> addWarrantyToFirestore({
    required String userUid,
    required WarrantyModel model,
  }) async {
    try {
      await firestore
          .collection("$userCollection/$userUid/$warrantyCollection")
          .doc(model.documentid)
          .set(warrantyModelToJson(model));
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<bool> updateWarrantyById({
    required String userUid,
    required WarrantyModel model,
  }) async {
    try {
      await firestore
          .collection("$userCollection/$userUid/$warrantyCollection")
          .doc(model.documentid)
          .update(warrantyModelToJson(model));
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<WarrantyModel?> getWarrantytById({
    required String documentId,
    required String userUid,
  }) async {
    try {
      var result =
          await firestore
              .collection("$userCollection/$userUid/$warrantyCollection")
              .doc(documentId)
              .get();

      return WarrantyModel.fromDynamic(result.data());
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return null;
    }
  }

  static Future<bool> deleteWarrantyById({
    required String documentId,
    required String userUid,
  }) async {
    try {
      await firestore
          .collection("$userCollection/$userUid/$warrantyCollection")
          .doc(documentId)
          .delete();
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  //Service
  static Future<bool> addServiceToFirestore({
    required String userUid,
    required ServiceModel serviceModel,
  }) async {
    try {
      await firestore
          .collection("$userCollection/$userUid/$servicesCollection")
          .doc(serviceModel.documentid)
          .set(serviceModelToJson(serviceModel));
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<bool> updateServiceById({
    required String userUid,
    required ServiceModel serviceModel,
  }) async {
    try {
      await firestore
          .collection("$userCollection/$userUid/$servicesCollection")
          .doc(serviceModel.documentid)
          .update(serviceModelToJson(serviceModel));
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<ServiceModel?> getServiceById({
    required String documentId,
    required String userUid,
  }) async {
    try {
      var result =
          await firestore
              .collection("$userCollection/$userUid/$servicesCollection")
              .doc(documentId)
              .get();

      return ServiceModel.fromDynamic(result.data());
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return null;
    }
  }

  static Future<bool> deleteServiceById({
    required String documentId,
    required String userUid,
  }) async {
    try {
      await firestore
          .collection("$userCollection/$userUid/$servicesCollection")
          .doc(documentId)
          .delete();
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<List<WarrantyModel>?> getExpiringWarranties(
    String userUid,
  ) async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final oneMonthLater = Timestamp.fromDate(
        DateTime.now().add(Duration(days: 30)),
      );

      final snapshot =
          await firestore
              .collection("$userCollection/$userUid/$warrantyCollection")
              .where(
                'warrantyExpiryDate',
                isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart),
              )
              .where('warrantyExpiryDate', isLessThanOrEqualTo: oneMonthLater)
              .orderBy('warrantyExpiryDate')
              .get();

      return snapshot.docs
          .map((doc) => WarrantyModel.fromDynamic(doc.data()))
          .toList();
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return null;
    }
  }
}
