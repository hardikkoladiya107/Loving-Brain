import 'package:flutter/material.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({Key? key}) : super(key: key);

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));
    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    _controller.loadHtmlString("""
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Loving Brain — Terms & Conditions</title>
  <style>
    :root{--bg:#f7fafc;--card:#ffffff;--muted:#6b7280;--accent:#2563eb}
    body{font-family:Inter, system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial; background:var(--bg); color:#111827; margin:0; padding:40px}
    .container{max-width:900px;margin:0 auto}
    header{margin-bottom:24px;margin-top:24px;margin-left:24px}
    h1{font-size:28px;margin:0 0 6px}
    p.lead{color:var(--muted); margin:6px 0 24px}
    .card{background:var(--card);border-radius:12px;padding:28px;box-shadow:0 8px 24px rgba(16,24,40,0.04)}
    h2{font-size:18px;margin-top:18px}
    ul{margin:8px 0 16px 20px}
    .muted{color:var(--muted)}
    footer{margin-top:18px;font-size:13px;color:var(--muted)}
    a{color:var(--accent);text-decoration:none}
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>Terms & Conditions — Loving Brain</h1>
      <p class="lead">Effective date: <strong>October 30, 2025</strong></p>
    </header>

    <section class="card">
      <p>Welcome to <strong>Loving Brain</strong>. These Terms & Conditions (“Terms”) govern your use of our parenting app and services. By downloading, accessing, or using the app, you agree to these Terms. If you do not agree, please do not use Loving Brain.</p>

      <h2>1. Eligibility</h2>
      <p>You must be at least 18 years old to create an account and use Loving Brain. By using the app, you represent that you meet this requirement and that any information you provide is accurate and complete.</p>

      <h2>2. Account registration</h2>
      <p>To use certain features, you may need to register for an account. You agree to:</p>
      <ul>
        <li>Provide accurate, current, and complete information.</li>
        <li>Keep your login credentials confidential.</li>
        <li>Notify us immediately of unauthorized use of your account.</li>
      </ul>

      <h2>3. Acceptable use</h2>
      <p>You agree to use Loving Brain only for lawful purposes. You must not:</p>
      <ul>
        <li>Upload or share any content that is illegal, harmful, or violates the rights of others.</li>
        <li>Interfere with app operation, attempt to hack, or introduce malicious code.</li>
        <li>Use the app for commercial or advertising purposes without our permission.</li>
      </ul>

      <h2>4. User content</h2>
      <p>You may upload content such as notes, milestones, or photos (“User Content”). You retain ownership of your content but grant Loving Brain a limited, non-exclusive, worldwide, royalty-free license to store, display, and use it solely for providing the app’s functionality.</p>
      <p>We do not claim ownership of your data and will not use it for advertising or resale.</p>

      <h2>5. Data and privacy</h2>
      <p>Your use of Loving Brain is also governed by our <a href="privacy_policy.html">Privacy Policy</a>. Please read it carefully to understand how we collect, use, and protect your data.</p>

      <h2>6. Intellectual property</h2>
      <p>All trademarks, logos, app design, and other content provided by Loving Brain are the property of the company or its licensors. You may not copy, modify, or distribute any part of the app without prior written consent.</p>

      <h2>7. Subscription and payments</h2>
      <p>Some features may require a paid subscription. By purchasing, you agree to the pricing and renewal terms shown in the app store. Payments are handled securely through the respective platform (Google Play or App Store), and we do not store payment information.</p>

      <h2>8. Termination</h2>
      <p>We may suspend or terminate your access if you violate these Terms or misuse the app. Upon termination, your right to use Loving Brain will cease immediately, and your data will be handled according to our Privacy Policy.</p>

      <h2>9. Disclaimer of warranties</h2>
      <p>Loving Brain is provided “as is” without warranties of any kind. We do not guarantee that the app will be error-free or uninterrupted. Your use is at your own risk.</p>

      <h2>10. Limitation of liability</h2>
      <p>To the maximum extent permitted by law, Loving Brain and its affiliates are not liable for indirect, incidental, or consequential damages resulting from your use of the app, loss of data, or inability to access the service.</p>

      <h2>11. Changes to the app and terms</h2>
      <p>We may update, modify, or discontinue parts of the app at any time. We may also update these Terms periodically. Continued use of the app after updates means you accept the revised Terms.</p>

      <h2>12. Governing law</h2>
      <p>These Terms are governed by the laws of your local jurisdiction unless otherwise required by applicable law. Any disputes shall be handled in the courts of that jurisdiction.</p>

      <h2>13. Contact us</h2>
      <p>For questions or concerns about these Terms, please contact us at <a href="mailto:support@yourcompany.com">support@yourcompany.com</a>.</p>

      <footer>
        <p class="muted">Thank you for using Loving Brain. We’re committed to supporting parents and caregivers in a safe, transparent, and respectful way.</p>
      </footer>
    </section>
  </div>
</body>
</html>
""");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,

      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          _appBar().appPadding(top: 60, left: 20),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BaseButton(
          child: Assets.icons.icBackIcon.image(height: 36, width: 36),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
