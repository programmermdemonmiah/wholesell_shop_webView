import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wholesell_shop/res/app_text_style/app_text_style.dart';
import 'package:wholesell_shop/res/color_manager/app_colors.dart';
import 'package:wholesell_shop/view_model/controller/web_view/web_show_view_model.dart';

class WebViewPage extends StatefulWidget {
  final String webUrl;

  const WebViewPage({super.key, required this.webUrl});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebShowViewModel>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          if (await controller.webController.canGoBack()) {
            controller.webController.goBack();
            return false;
          } else {
            _showExitDialog();
            return false;
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Obx(
              () => RefreshIndicator(
                backgroundColor: AppColors.goldColor,
                color: AppColors.whiteBg,
                onRefresh: () async {
                  await Future.delayed(
                    const Duration(seconds: 1),
                    () async {
                      // print("reload access again");
                      await controller.webController.reload();
                    },
                  );
                },
                child: Stack(
                  children: [
                    _inAppBarWebView(controller, widget.webUrl),
                    if (controller.progress.value < 1)
                      LinearProgressIndicator(
                        value: controller.progress.value,
                        minHeight: 5.sp,
                        color: Colors.green,
                        backgroundColor: AppColors.whiteBg,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _inAppBarWebView(WebShowViewModel controller, String webUrl) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(webUrl)),
      initialOptions: InAppWebViewGroupOptions(
        crossPlatform: InAppWebViewOptions(
          javaScriptEnabled: true,
          useShouldOverrideUrlLoading: true,
        ),
      ),
      onWebViewCreated: (wcontroller) {
        controller.webController = wcontroller;
      },
      onProgressChanged: (wcontroller, progress) {
        controller.progress.value = progress / 100;
        debugPrint('WebView is loading (progress : $progress%)');
      },
      shouldOverrideUrlLoading: (controller, request) async {
        debugPrint('Loading URL: ${request.request.url}');
        return NavigationActionPolicy.ALLOW;
      },
      onLoadError: (controller, url, code, message) {
        debugPrint('Load Error: $message');
      },
      onLoadHttpError: (controller, url, statusCode, description) {
        debugPrint('HTTP Error: $description');
      },
      onReceivedServerTrustAuthRequest: (controller, challenge) async {
        return ServerTrustAuthResponse(
          action: ServerTrustAuthResponseAction.PROCEED,
        );
      },
    );
  }

  void _showExitDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text(
              "Are you sure you want to exit the app?",
              style: AppTextStyle.text2(context: context),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "No",
                style: AppTextStyle.tittleSmall3(context: context),
              ),
              onPressed: () {
                Navigator.of(context).pop();
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
}
