import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _key = UniqueKey();

  late WebViewController _webViewController;
  bool isBtnEnabled = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _willExit();
      },
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              leading: Builder(builder: (childContext) {
                return IconButton(
                  onPressed: isBtnEnabled
                      ? () async {
                          await _willExit();
                        }
                      : null,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: isBtnEnabled ? Colors.white : Colors.white70,
                    size: 26.0,
                  ),
                );
              }),
              backgroundColor: HexColor('#236361'), /*Colors.red,*/
            ),
            body: Stack(
              children: [
                WebView(
                  key: _key,
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl:
                      'https://www.google.com/', //'http://54.244.198.217/DemoEzzar/',
                  gestureNavigationEnabled: true,
                  zoomEnabled: true,
                  onWebViewCreated: (WebViewController controller) {
                    _webViewController = controller;
                  },
                  onPageFinished: (str) async {
                    isBtnEnabled = await _webViewController.canGoBack();
                    setState(() {});
                  },
                ),
              ],
            )),
      ),
    );
  }

  Future<bool> _willExit() async {
    if (await _webViewController.canGoBack()) {
      await _webViewController.goBack();
      return false;
    }
    return true;
  }
}
