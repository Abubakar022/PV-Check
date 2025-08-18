import 'package:flutter/material.dart';
import 'verify_webview.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget _gradientButton(BuildContext context, String text, String url) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyWebView(url: url, title: text),
            ),
          );
        },
        child: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Colors.white70],
          ).createShader(bounds),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // kept for fallback
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.blue, Colors.purple],
          ).createShader(bounds),
          child: const Text(
            "Solar Panel Verification",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.white, // fallback
            ),
          ),
        ),
        //centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _gradientButton(context, "Canadian Solar", "https://snquerycn.csisolar.com/indexEn.html"),
              _gradientButton(context, "LONGi Solar", "https://www.longi.com/en/modules-authenticity/"),
              _gradientButton(context, "JA Solar", "https://product.jasolar.com/en.html"),
              _gradientButton(context, "Jinko Solar", "https://cs.jinkosolar.com/app/index.html#/customer-complaint/authenticity"),
            ],
          ),
        ),
      ),
    );
  }
}
