import 'package:docusave/app/mahas/auth_controller.dart';
import 'package:docusave/app/mahas/models/menu_item_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  final List<MenuItemModel> onBoardingList = [
    MenuItemModel(
      title: "onboarding_title_1".tr,
      subtitle: "onboarding_subtitle_1".tr,
      image: "assets/images/onboarding_1.png",
    ),
    MenuItemModel(
      title: "onboarding_title_2".tr,
      subtitle: "onboarding_subtitle_2".tr,
      image: "assets/images/onboarding_2.png",
    ),
    MenuItemModel(
      title: "onboarding_title_3".tr,
      subtitle: "onboarding_subtitle_3".tr,
      image: "assets/images/onboarding_3.png",
    ),
    MenuItemModel(
      title: "request_notification_title".tr,
      subtitle: "request_notification_subtitle".tr,
      image: "assets/images/request_notification.png",
    ),
    MenuItemModel(
      title: "request_camera_title".tr,
      subtitle: "request_camera_subtitle".tr,
      image: "assets/images/request_camera.png",
    ),
  ];
  RxInt onBoardingIndex = 0.obs;
  final box = GetStorage();

  void prevOnTap() {
    if (onBoardingIndex.value >= 0) {
      onBoardingIndex--;
    }
  }

  void nextOnTap() {
    if (onBoardingIndex.value < onBoardingList.length - 1) {
      onBoardingIndex++;
    } else {
      if (onBoardingIndex.value == 2) {
        onBoardingIndex++;
      }
    }
  }

  void requestPermission() async {
    if (onBoardingIndex.value == 3) {
      bool result =
          await AuthController.instance.requestNotificationPermission();
      if (result) onBoardingIndex++;
    } else if (onBoardingIndex.value == 4) {
      bool result = await AuthController.instance.requestCameraPermission();
      if (result) {
        box.write('first_open_app', false);
        AuthController.instance.onInit();
      }
    }
  }
}
