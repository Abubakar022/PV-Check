import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VerifyWebView extends StatefulWidget {
  final String url;
  final String title;

  const VerifyWebView({super.key, required this.url, required this.title});

  @override
  State<VerifyWebView> createState() => _VerifyWebViewState();
}

class _VerifyWebViewState extends State<VerifyWebView> {
  late final WebViewController _controller;
  bool isLoading = true;
  bool hasError = false; // ✅ track error state

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) {
            setState(() {
              isLoading = true;
              hasError = false;
            });
          },
          onPageFinished: (_) async {
            setState(() => isLoading = false);

            // ✅ Disable copy / text selection
            await _controller.runJavaScript(
              """
              document.documentElement.style.userSelect='none';
              document.documentElement.style.webkitUserSelect='none';
              document.documentElement.style.msUserSelect='none';
              document.documentElement.style.mozUserSelect='none';
              document.documentElement.style.webkitTouchCallout='none';
              """,
            );
          },
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
              hasError = true; // show error screen instead of WebView
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ).createShader(bounds),
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!hasError)
            WebViewWidget(controller: _controller)
          else
            _buildErrorView(), // ✅ custom error UI
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  /// Custom error widget
  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            icon: const Icon(Icons.refresh),
            label: const Text("Retry"),
            onPressed: () {
              setState(() {
                hasError = false;
                isLoading = true;
              });
              _controller.loadRequest(Uri.parse(widget.url));
            },
          ),
        ],
      ),
    );
  }
}
