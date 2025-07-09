import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:docusave/app/mahas/components/others/reusable_statics.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/input_formatter.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/article_model.dart';
import 'package:docusave/app/models/money_tracker_budget_model.dart';
import 'package:docusave/app/models/money_tracker_summary_model.dart';
import 'package:docusave/app/models/receipt_model.dart';
import 'package:docusave/app/models/service_model.dart';
import 'package:docusave/app/models/suggestion_model.dart';
import 'package:docusave/app/models/money_tracker_model.dart';
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
  static String moneyTrackerCollection = 'moneyTracker';
  static String moneyTrackerSummaryCollection = 'moneyTrackerSummary';

  //queries
  static CollectionReference getToReceiptCollection(String userUid) =>
      firestore.collection("$userCollection/$userUid/$receiptCollection");
  static CollectionReference getToWarrantyCollection(String userUid) =>
      firestore.collection("$userCollection/$userUid/$warrantyCollection");
  static CollectionReference getToServiceCollection(String userUid) =>
      firestore.collection("$userCollection/$userUid/$servicesCollection");
  static CollectionReference getToMoneyTrackerCollection(String userUid) =>
      firestore.collection("$userCollection/$userUid/$moneyTrackerCollection");
  static CollectionReference getToSummaryMoneyTrackerCollection(
    String userUid,
  ) => firestore.collection(
    "$userCollection/$userUid/$moneyTrackerSummaryCollection",
  );

  //private get by id
  static DocumentReference _goToReceiptById(
    String userUid,
    String documentId,
  ) => getToReceiptCollection(userUid).doc(documentId);
  static DocumentReference _goToWarrantyById(
    String userUid,
    String documentId,
  ) => getToWarrantyCollection(userUid).doc(documentId);
  static DocumentReference _goToServiceById(
    String userUid,
    String documentId,
  ) => getToServiceCollection(userUid).doc(documentId);
  static DocumentReference _goToMoneyTrackerById(
    String userUid,
    String documentId,
  ) => getToMoneyTrackerCollection(userUid).doc(documentId);
  static DocumentReference _goToSummaryMoneyTrackerById(
    String userUid,
    String monthKey,
  ) => getToSummaryMoneyTrackerCollection(userUid).doc(monthKey);

  //firestore actions
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
      await _goToReceiptById(
        userUid,
        receiptModel.documentid,
      ).set(receiptModelToJson(receiptModel));
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
      await _goToReceiptById(
        userUid,
        receiptModel.documentid,
      ).update(receiptModelToJson(receiptModel));
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
      var result = await _goToReceiptById(userUid, documentId).get();
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
      await _goToReceiptById(userUid, documentId).delete();
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
      await _goToWarrantyById(
        userUid,
        model.documentid,
      ).set(warrantyModelToJson(model));
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
      await _goToWarrantyById(
        userUid,
        model.documentid,
      ).update(warrantyModelToJson(model));
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
      var result = await _goToWarrantyById(userUid, documentId).get();
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
      await _goToWarrantyById(userUid, documentId).delete();
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
      await _goToServiceById(
        userUid,
        serviceModel.documentid,
      ).set(serviceModelToJson(serviceModel));
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
      await _goToServiceById(
        userUid,
        serviceModel.documentid,
      ).update(serviceModelToJson(serviceModel));
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
      var result = await _goToServiceById(userUid, documentId).get();
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
      await _goToServiceById(userUid, documentId).delete();
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
          await getToWarrantyCollection(userUid)
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

  static Future<MoneyTrackerModel?> getMoneyTrackerById({
    required String documentId,
    required String userUid,
  }) async {
    try {
      var result = await _goToMoneyTrackerById(userUid, documentId).get();
      return MoneyTrackerModel.fromDynamic(result.data());
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return null;
    }
  }

  static Future<bool> addMoneyTrackerToFirestore({
    required String userUid,
    required String monthKey,
    required MoneyTrackerModel moneyTrackerModel,
    required MoneyTrackerSummaryModel moneyTrackerSummaryModel,
  }) async {
    try {
      final summaryRef = _goToSummaryMoneyTrackerById(userUid, monthKey);
      final moneyTrackerRef = _goToMoneyTrackerById(
        userUid,
        moneyTrackerModel.documentid,
      );

      await firestore.runTransaction((transaction) async {
        //summary
        final summarySnapshot = await transaction.get(summaryRef);

        //money tracker
        transaction.set(
          moneyTrackerRef,
          moneyTrackerModelToJson(moneyTrackerModel),
        );

        //summary
        if (!summarySnapshot.exists) {
          // Jika summary bulan ini belum ada
          transaction.set(
            summaryRef,
            moneyTrackerSummaryModelToJson(moneyTrackerSummaryModel),
          );
        } else {
          // Jika sudah ada, update total
          final currentData = MoneyTrackerSummaryModel.fromDynamic(
            summarySnapshot.data(),
          );
          final weekIndex =
              InputFormatter.getWeekOfMonth(moneyTrackerModel.date.toDate()) -
              1;
          if (moneyTrackerModel.type == 2 &&
              !moneyTrackerModel.category.contains(11)) {
            currentData.weeklyexpense[weekIndex] +=
                moneyTrackerModel.totalamount;
          }

          transaction.update(
            summaryRef,
            moneyTrackerSummaryModelToJson(
              MoneyTrackerSummaryModel(
                documentid: currentData.documentid,
                totalincome:
                    currentData.totalincome +
                    moneyTrackerSummaryModel.totalincome,
                totalexpense:
                    currentData.totalexpense +
                    moneyTrackerSummaryModel.totalexpense,
                weeklyexpense: currentData.weeklyexpense,
                createdat: currentData.createdat,
                updatedat: Timestamp.now(),
              ),
            ),
          );
        }
      });
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<bool> updateMoneyTrackerToFirestore({
    required String userUid,
    required String monthKey,
    required MoneyTrackerModel oldMoneyTrackerModel,
    required MoneyTrackerModel updatedMoneyTrackerModel,
  }) async {
    try {
      final summaryRef = _goToSummaryMoneyTrackerById(userUid, monthKey);
      final moneyTrackerRef = _goToMoneyTrackerById(
        userUid,
        oldMoneyTrackerModel.documentid,
      );

      await firestore.runTransaction((transaction) async {
        //summary
        final summarySnapshot = await transaction.get(summaryRef);

        if (summarySnapshot.exists) {
          final summaryData = MoneyTrackerSummaryModel.fromDynamic(
            summarySnapshot.data(),
          );

          double updatedIncome = summaryData.totalincome;
          double updatedExpense = summaryData.totalexpense;
          final weekIndex =
              InputFormatter.getWeekOfMonth(
                updatedMoneyTrackerModel.date.toDate(),
              ) -
              1;
          if (updatedMoneyTrackerModel.type == 1) {
            updatedIncome =
                updatedIncome -
                oldMoneyTrackerModel.totalamount +
                updatedMoneyTrackerModel.totalamount;
          } else {
            updatedExpense =
                updatedExpense -
                oldMoneyTrackerModel.totalamount +
                updatedMoneyTrackerModel.totalamount;

            if (!updatedMoneyTrackerModel.category.contains(11)) {
              summaryData.weeklyexpense[weekIndex] =
                  summaryData.weeklyexpense[weekIndex] -
                  oldMoneyTrackerModel.totalamount +
                  updatedMoneyTrackerModel.totalamount;
            }
          }

          transaction.update(
            summaryRef,
            moneyTrackerSummaryModelToJson(
              MoneyTrackerSummaryModel(
                documentid: summaryData.documentid,
                totalincome: updatedIncome,
                totalexpense: updatedExpense,
                weeklyexpense: summaryData.weeklyexpense,
                createdat: summaryData.createdat,
                updatedat: Timestamp.now(),
              ),
            ),
          );
        }

        //update money tracker
        transaction.update(
          moneyTrackerRef,
          moneyTrackerModelToJson(updatedMoneyTrackerModel),
        );
      });
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<bool> subtractMoneyTrackerSummaryFirestore({
    required String userUid,
    required String moneyTrackerDocumentId,
  }) async {
    final moneyTrackerRef = _goToMoneyTrackerById(
      userUid,
      moneyTrackerDocumentId,
    );
    try {
      await firestore.runTransaction((transaction) async {
        final moneyTrackerSnapshot = await transaction.get(moneyTrackerRef);

        if (moneyTrackerSnapshot.exists) {
          final moneyTrackerData = MoneyTrackerModel.fromDynamic(
            moneyTrackerSnapshot.data(),
          );

          final summaryRef = _goToSummaryMoneyTrackerById(
            userUid,
            ReusableStatics.getMonthKey(moneyTrackerData.date.toDate()),
          );

          final summarySnapshot = await transaction.get(summaryRef);
          final summaryData = MoneyTrackerSummaryModel.fromDynamic(
            summarySnapshot.data(),
          );

          double removedIncome = 0;
          double removedExpense = 0;
          final weekIndex =
              InputFormatter.getWeekOfMonth(moneyTrackerData.date.toDate()) - 1;
          if (moneyTrackerData.type == 1) {
            removedIncome = moneyTrackerData.totalamount;
          } else {
            removedExpense = moneyTrackerData.totalamount;

            if (!moneyTrackerData.category.contains(11)) {
              summaryData.weeklyexpense[weekIndex] =
                  summaryData.weeklyexpense[weekIndex] -
                  moneyTrackerData.totalamount;
            }
          }

          //update summary
          transaction.update(
            summaryRef,
            moneyTrackerSummaryModelToJson(
              MoneyTrackerSummaryModel(
                documentid: summaryData.documentid,
                totalincome: summaryData.totalincome - removedIncome,
                totalexpense: summaryData.totalexpense - removedExpense,
                weeklyexpense: summaryData.weeklyexpense,
                createdat: summaryData.createdat,
                updatedat: Timestamp.now(),
              ),
            ),
          );

          // delete money Tracker
          transaction.delete(moneyTrackerRef);
        }
      });
      return true;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return false;
    }
  }

  static Future<MoneyTrackerSummaryModel?> getMoneyTrackerSummaryByMonthKey({
    required String monthKey,
    required String userUid,
  }) async {
    try {
      var result = await _goToSummaryMoneyTrackerById(userUid, monthKey).get();
      if (result.exists) {
        return MoneyTrackerSummaryModel.fromDynamic(result.data());
      }
      return null;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return null;
    }
  }

  static Future<MoneyTrackerSummaryModel?> addBudgetMoneyTrackerToFirestore({
    required String userUid,
    required MoneyTrackerBudgetModel moneyTrackerBudgetModel,
  }) async {
    try {
      final summaryRef = _goToSummaryMoneyTrackerById(
        userUid,
        moneyTrackerBudgetModel.documentid,
      );

      await firestore.runTransaction((transaction) async {
        transaction.set(
          summaryRef,
          moneyTrackerBudgetModelToJson(moneyTrackerBudgetModel),
          SetOptions(merge: true),
        );
      });
      final summarySnapshot = await summaryRef.get();
      if (summarySnapshot.exists) {
        return MoneyTrackerSummaryModel.fromDynamic(summarySnapshot.data());
      }
      return null;
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      return null;
    }
  }
}
