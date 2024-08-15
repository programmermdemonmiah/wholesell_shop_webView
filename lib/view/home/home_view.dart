import 'package:flutter/material.dart';
import 'package:wholesell_shop/view/web_view/web_view_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const WebViewPage(webUrl: "https://ecomb2c.nibizapps.com/");
  }
}
