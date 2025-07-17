import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:docusave/app/data/firebase_repository.dart';
import 'package:docusave/app/mahas/components/widgets/reusable_widgets.dart';
import 'package:docusave/app/mahas/constants/mahas_config.dart';
import 'package:docusave/app/mahas/lang/translation_service.dart';
import 'package:docusave/app/mahas/mahas_service.dart';
import 'package:docusave/app/models/user_model.dart';
import 'package:docusave/app/models/user_notification_model.dart';
import 'package:docusave/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  static AuthController instance =
      Get.isRegistered<AuthController>()
          ? Get.find<AuthController>()
          : Get.put(AuthController());

  final box = GetStorage();
  late Rx<User?> firebaseUser;
  String? notificationToken;

  @override
  void onInit() async {
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.authStateChanges().distinct());
    debounce(
      firebaseUser,
      _setInitialScreen,
      time: Duration(milliseconds: 500),
    );
    super.onInit();
  }

  void _setInitialScreen(User? user) async {
    if (Get.currentRoute == Routes.HOME || Get.currentRoute == Routes.LOGIN) {
      if (EasyLoading.isShow) EasyLoading.dismiss();
      await EasyLoading.show();
    }

    final firstOpen = await box.read('first_open_app');
    if (firstOpen != false) {
      Get.toNamed(Routes.ONBOARDING);
    } else {
      await requestNotificationPermission();
      if (user != null) {
        await FirebaseRepository.addUserToFirestore(
          userModel: UserModel(
            userid: user.uid,
            name: user.displayName ?? "",
            email: user.email ?? "",
            selectedLanguage: TranslationService.locale.languageCode,
            createdat: Timestamp.now(),
            subscriptionplan: "free",
          ),
        );
        Get.updateLocale(TranslationService.locale);
        if (notificationToken != null && notificationToken!.isNotEmpty) {
          await FirebaseRepository.addUserNotificationToken(
            userNotificationModel: UserNotificationModel(
              notificationToken: notificationToken!,
              createdat: Timestamp.now(),
            ),
            userId: user.uid,
          );
        }
        await FirebaseRepository.addUserDeviceInfo(user.uid);
      }
      await EasyLoading.dismiss();

      if (MahasConfig.userProfile != null &&
          MahasConfig.userProfile!.moneytrackershortcut == true) {
        MahasConfig.isInitialShortcut = true;
        Get.toNamed(Routes.MONEY_TRACKER_SETUP);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    }
  }

  Future<bool> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Dapatkan token FCM (yang juga mengandalkan APNs di iOS)
      notificationToken = await messaging.getToken();
      // Dapatkan APNs token (iOS only)
      await messaging.getAPNSToken();
    }
    return true;
  }

  //perlu diperbaiki untuk UI/UX yang lebih bagus
  Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.camera.request();
    }
    return true;
  }

  Future<void> signInWithGoogle({bool isLinkingUser = false}) async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    await EasyLoading.show();
    try {
      var r = await _signInWithCredentialGoogle(isLinkingUser);
      box.write('apple_login', null);
      if (r == null) {
        await EasyLoading.dismiss();
      }
    } catch (e) {
      // bool internetError = MahasService.isInternetCausedError(e.toString());
      // if (internetError) {
      //   Helper.errorToast();
      // } else {
      //   Helper.errorToast(message: e.toString());
      // }
      // await EasyLoading.dismiss();
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
    }
    await EasyLoading.dismiss();
  }

  Future<UserCredential?> _signInWithCredentialGoogle(
    bool isLinkingUser,
  ) async {
    GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn(scopes: <String>["email"]).signIn();
    if (googleSignInAccount == null) return null;
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    if (isLinkingUser) {
      await _linkAccountCredential(credential);
      return null;
    } else {
      return await auth.signInWithCredential(credential);
    }
  }

  Future<void> _linkAccountCredential(AuthCredential credential) async {
    User? user = auth.currentUser;
    if (user != null) {
      if (user.email.toString().endsWith("privaterelay.appleid.com")) {
        if (EasyLoading.isShow) await EasyLoading.dismiss();
        ReusableWidgets.notifBottomSheet(
          subtitle:
              "Tidak dapat menautkan akun karena email Apple bersifat privat",
        );
      } else {
        try {
          await user.linkWithCredential(credential);
        } catch (e) {
          if (e.toString().toLowerCase().contains(
                "associated with a different user account",
              ) ||
              e.toString().toLowerCase().contains(
                "already in use by another account",
              )) {
            await GoogleSignIn().signOut();
            ReusableWidgets.notifBottomSheet(
              subtitle:
                  "Akun yang anda pilih sudah terhubung dengan pengguna lain",
            );
          } else if (e.toString().toLowerCase().contains(
            "do not correspond to the previously signed in user",
          )) {
            ReusableWidgets.notifBottomSheet(
              subtitle: "Tidak dapat menautkan akun dengan email yang berbeda",
            );
          } else {
            ReusableWidgets.notifBottomSheet(
              subtitle: "Terjadi kesalahan saat menautkan akun anda",
            );
          }
        }
      }
    }
    if (EasyLoading.isShow) await EasyLoading.dismiss();
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential?> _signInWithCredentialApple(bool isLinkingUser) async {
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );
    if (isLinkingUser) {
      await _linkAccountCredential(oauthCredential);
      return null;
    } else {
      return await auth.signInWithCredential(oauthCredential);
    }
  }

  Future<void> signInWithApple({bool isLinkingUser = false}) async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    await EasyLoading.show();
    try {
      await _signInWithCredentialApple(isLinkingUser);
      box.write('apple_login', true);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code != AuthorizationErrorCode.canceled) {
        ReusableWidgets.notifBottomSheet(subtitle: e.message);
      }
      await EasyLoading.dismiss();
    }
  }

  Future<void> singInWithPassword(String email, String pass) async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    await EasyLoading.show();
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);
    } catch (e) {
      if (e.toString().toLowerCase().contains("no user record") ||
          e.toString().toLowerCase().contains("malformed")) {
        ReusableWidgets.notifBottomSheet(subtitle: "wrong_credential".tr);
      } else {
        ReusableWidgets.notifBottomSheet(subtitle: e.toString());
      }
    }
    await EasyLoading.dismiss();
  }

  Future<void> signOut({bool deleteToken = true}) async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    await EasyLoading.show();
    //jangan lupa tambahkan delete notif tokennya
    await auth.signOut();
    await GoogleSignIn().signOut();
    MahasConfig.userProfile = null;
    await EasyLoading.dismiss();
  }

  Future<void> deleteAccount() async {
    if (EasyLoading.isShow) EasyLoading.dismiss();
    await EasyLoading.show();
    UserCredential? userCredential;
    try {
      //jangan lupa tambahkan delete notif tokennya
      if (box.read('apple_login') == true) {
        userCredential = await _signInWithCredentialApple(false);
      } else {
        userCredential = await _signInWithCredentialGoogle(false);
      }
      if (userCredential?.user != null) {
        await userCredential!.user!.delete();
      }
      auth.signOut();
      await GoogleSignIn().signOut();
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code != AuthorizationErrorCode.canceled) {
        ReusableWidgets.notifBottomSheet(subtitle: e.message);
      }
    } catch (e) {
      ReusableWidgets.notifBottomSheet(subtitle: e.toString());
    }
    await EasyLoading.dismiss();
  }
}
