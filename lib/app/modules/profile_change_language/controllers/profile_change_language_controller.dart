import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/inputs/input_radio_component.dart';
import 'package:docusave/app/mahas/components/texts/text_component.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileChangeLanguageController extends GetxController {
  final box = GetStorage();
  final pilihBahasaCon = InputRadioController(
    items: [
      RadioButtonItem(
        text: "Bahasa Indonesia (ID)",
        value: 1,
        pngUrl: "assets/images/language_id.png",
      ),
      RadioButtonItem(
        text: "English (EN)",
        value: 2,
        pngUrl: "assets/images/language_en.png",
      ),
    ],
  );

  int currentSelectedLanguage = 1;

  @override
  void onInit() {
    if (Get.locale?.languageCode == 'id') {
      pilihBahasaCon.value = 1;
    } else if (Get.locale?.languageCode == 'en') {
      pilihBahasaCon.value = 2;
    }
    currentSelectedLanguage = pilihBahasaCon.value;
    pilihBahasaCon.onChanged = (item) async {
      if (item.value != currentSelectedLanguage) {
        bool? konfirmasiBahasa = await ReusableWidgets.confirmationBottomSheet(
          title: "title_change_language".tr,
          children: [
            TextComponent(
              value: "confirm_change_language".tr,
              fontWeight: FontWeight.w500,
            ),
          ],
        );
        if (konfirmasiBahasa == true) {
          currentSelectedLanguage = item.value;
          if (item.value == 1) {
            Get.updateLocale(Locale('id', 'ID'));
            pilihBahasaCon.value = item.value;
          } else if (item.value == 2) {
            Get.updateLocale(Locale('en', 'EN'));
            pilihBahasaCon.value = item.value;
          }
          UserModel userModel = UserModel(
            userid: MahasConfig.userProfile?.userid ?? "",
            name: MahasConfig.userProfile?.name ?? "",
            email: MahasConfig.userProfile?.email ?? "",
            selectedLanguage: pilihBahasaCon.value == 1 ? "id" : "en",
            updatedat: Timestamp.now(),
            profilepic: MahasConfig.userProfile?.profilepic,
            subscriptionplan: MahasConfig.userProfile?.subscriptionplan,
            createdat: MahasConfig.userProfile?.createdat,
          );
          await FirebaseRepository.updateUserProfile(userModel: userModel).then(
            (value) async {
              bool result = await ReusableWidgets.dialogSuccess(
                title: "berhasil_ganti_bahasa".tr,
              );
              if (result) {
                Get.back();
              }
            },
          );
        } else if (konfirmasiBahasa == false) {
          pilihBahasaCon.value = currentSelectedLanguage;
        }
      }
    };
    super.onInit();
  }
}
