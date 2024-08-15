import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesell_shop/res/app_routes/app_routes_name.dart';
import 'package:wholesell_shop/res/app_text_style/app_text_style.dart';
import 'package:wholesell_shop/res/assets_manager/assets_image.dart';
import 'package:wholesell_shop/res/color_manager/app_colors.dart';
import 'package:wholesell_shop/utils/ui_const.dart';
import 'package:http/http.dart' as http;

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkInternetConnection() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("PlatformException: ${e.message}");
      result = [ConnectivityResult.none];
    }
    if (!mounted) return;

    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    late ConnectivityResult data;
    for (int i = 0; i < _connectionStatus.length; i++) {
      data = _connectionStatus[i];
    }
    if (data == ConnectivityResult.mobile ||
        data == ConnectivityResult.wifi ||
        data == ConnectivityResult.ethernet ||
        data == ConnectivityResult.vpn) {
      // Perform an additional check to verify internet connectivity
      final bool hasInternet = await _hasInternetConnection();
      if (hasInternet) {
        _navigateToHomePage();
        print("Connected to Internet");
      } else {
        _showNoInternetDialog();
        print("No Internet Connection");
      }
    } else {
      _showNoInternetDialog();
      print("No Internet Connection");
    }
  }

  Future<bool> _hasInternetConnection() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }

  void _navigateToHomePage() {
    Future.delayed(const Duration(seconds: 2), () {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomePage()),
      // );
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutesName.homeView,
        (route) => false,
      );
      // Get.offAllNamed(AppRoutesName.homeView);
    });
  }

  void _showNoInternetDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "No Internet Connection",
            style: AppTextStyle.tittleBig4(context: context),
          ),
          content: SingleChildScrollView(
              child: Text(
            "Please check your internet connection and try again.",
            style: AppTextStyle.text2(context: context),
          )),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Retry",
                style: AppTextStyle.tittleSmall3(context: context),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _checkInternetConnection();
                _connectivitySubscription = _connectivity.onConnectivityChanged
                    .listen(_updateConnectionStatus);
              },
            ),
            TextButton(
              child: Text(
                "Exit",
                style: AppTextStyle.tittleSmall3(context: context),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _exitApp();
              },
            ),
          ],
        );
      },
    );
  }

  void _exitApp() {
    Future.delayed(const Duration(milliseconds: 100), () {
      SystemNavigator.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe7eefc),
      appBar: AppBar(
        backgroundColor: const Color(0xffe7eefc),
      ),
      body: SafeArea(
        child: Container(
          height: Get.height,
          width: Get.width,
          color: const Color(0xffe7eefc),
          // color: primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              gapH(4),
              Center(
                child: Image.asset(
                  AssetsImage.logo,
                  // height: Get.height,
                  // width: Get.width,
                  // filterQuality: FilterQuality.high,
                  fit: BoxFit.fitWidth,
                ),
                // child: Text("test"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Made with love ',
                        style: AppTextStyle.text1(
                            context: context, color: AppColors.primaryColor),
                      ),
                      Icon(
                        Icons.favorite_rounded,
                        color: AppColors.primaryColor,
                        size: 18.sp,
                      )
                    ],
                  ),
                  Text(
                    'v1.0',
                    style: AppTextStyle.text2(
                        context: context, color: AppColors.primaryColor),
                  ),
                  gapH(7)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
