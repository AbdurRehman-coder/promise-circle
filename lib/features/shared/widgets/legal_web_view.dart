import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:sbp_app/core/theming/app_colors.dart';
import 'package:sbp_app/core/utils/text_styles.dart';

class LegalWebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const LegalWebViewPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<LegalWebViewPage> createState() => _LegalWebViewPageState();
}

class _LegalWebViewPageState extends State<LegalWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.title,
          style: AppTextStyles.bodyTextStyle.copyWith(
            color: AppColors.blackColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        // CLEAR EXIT BUTTON
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.blackColor),
          onPressed: () => Navigator.of(context).pop(), // Returns to Create Account
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: AppColors.blackColor),
            ),
        ],
      ),
    );
  }
}