import 'package:flutter/material.dart';
import 'package:loving_brain/gen/assets.gen.dart';
import 'package:loving_brain/other/app_extentions.dart';
import 'package:loving_brain/ui/widget/base_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
    _controller.loadHtmlString("""<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Loving Brain — Privacy Policy</title>
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
    code{background:#f3f4f6;padding:2px 6px;border-radius:6px;font-family:monospace}
  </style>
</head>
<body>
  <div class="container">
    <header>
      <h1>Privacy Policy — Loving Brain</h1>
      <p class="lead">Effective date: <strong>October 30, 2025</strong></p>
    </header>

    <section class="card">
      <p>Welcome to <strong>Loving Brain</strong> — a parenting app designed to help caregivers track milestones, organize routines, and find supportive resources. We take your privacy seriously. This Privacy Policy explains what information we collect, why we collect it, how we use it, and the choices you have.</p>

      <h2>1. Who we are</h2>
      <p class="muted">Loving Brain is operated by <em>YOUR COMPANY NAME</em>. If you have questions about this policy, please contact us at <a href="mailto:privacy@yourcompany.com">privacy@yourcompany.com</a>.</p>

      <h2>2. Information we collect</h2>
      <p>We collect the following types of information when you use Loving Brain:</p>
      <ul>
        <li><strong>Account information:</strong> name, email address, profile picture (if you add one), and any information you choose to include in your profile.</li>
        <li><strong>Child-related data:</strong> names, ages, milestones, notes, photos or media you upload related to your child(ren). This data is only collected if you provide it.</li>
        <li><strong>Device & usage data:</strong> device identifiers, operating system, app version, IP address, and usage analytics (how you interact with the app, features used, timestamps) to help us improve the app.</li>
        <li><strong>Crash & performance data:</strong> anonymous reports about errors or crashes to help us maintain and improve stability.</li>
      </ul>

      <h2>3. How we collect information</h2>
      <ul>
        <li>Directly from you when you create an account, fill forms, upload content, or contact support.</li>
        <li>Automatically through the app for analytics, performance monitoring, and security.</li>
        <li>From third-party services you choose to connect (for example, if you sign-in with a social provider).</li>
      </ul>

      <h2>4. How we use your information</h2>
      <ul>
        <li>To provide and personalize the app experience (save routines, reminders, milestones).</li>
        <li>To communicate with you about updates, support requests, and important notices.</li>
        <li>To analyze usage and improve features, reliability, and performance.</li>
        <li>To protect the safety and security of users and the service.</li>
      </ul>

      <h2>5. Sharing and disclosure</h2>
      <p>We do not sell your personal information. We may share information in the following limited cases:</p>
      <ul>
        <li><strong>Service providers:</strong> trusted third-party vendors who perform services for us (hosting, analytics, crash reporting). They are contractually required to protect your data.</li>
        <li><strong>Legal reasons:</strong> if required by law, to respond to legal process, or to protect rights, property, or safety.</li>
        <li><strong>Business transfers:</strong> in the event of a merger, acquisition, or sale of assets — we will notify affected users where required by law.</li>
      </ul>

      <h2>6. Photos & media</h2>
      <p>Any photos or media you upload remain under your control. We store them to enable app features (timelines, sharing within family). If you delete an image or an account, we will remove that content according to our retention policy (see section <em>Data retention</em>).</p>

      <h2>7. Children and parental controls</h2>
      <p>Loving Brain is intended for caregivers and parents. We do not knowingly collect personal information about children under 13 without parental consent. If you add information about a child, you represent you are the parent or legal guardian and have the right to provide that information. If you believe we have collected personal information about a minor without permission, contact us and we will take steps to remove it.</p>

      <h2>8. Third-party services</h2>
      <p>The app may use third-party services (for example, analytics platforms, push notification services). Those services collect data according to their own privacy policies. We recommend reviewing their policies; the providers we use may include common services such as Firebase, Google Play services, and analytics vendors.</p>

      <h2>9. Data security</h2>
      <p>We implement reasonable administrative, technical, and physical safeguards to protect your information. No method of storage or transmission is completely secure — please use strong passwords and safeguard access to your device.</p>

      <h2>10. Data retention</h2>
      <p>We retain personal data as long as necessary to provide the service, comply with legal obligations, resolve disputes, and enforce agreements. If you delete your account, we will deactivate it immediately and schedule data for deletion according to our internal policies.</p>

      <h2>11. Your choices</h2>
      <ul>
        <li><strong>Access & update:</strong> You can access and update account details from the app settings.</li>
        <li><strong>Delete:</strong> You may delete your account from the app. Deletion will remove your profile and content per our retention policy.</li>
        <li><strong>Marketing:</strong> You can opt out of promotional emails by following unsubscribe instructions in those messages.</li>
      </ul>

      <h2>12. International transfers</h2>
      <p>Your information may be processed or stored in servers located in different countries. We take steps to ensure that transfers are conducted safely and in compliance with applicable law.</p>

      <h2>13. Changes to this policy</h2>
      <p>We may update this Privacy Policy from time to time. When we make material changes we will post the new policy with an updated effective date. Your continued use of the app after changes means you accept the revised policy.</p>

      <h2>14. Contact us</h2>
      <p>If you have questions, concerns, or requests about your data, please email us at <a href="mailto:privacy@yourcompany.com">privacy@yourcompany.com</a> or write to:</p>
      <p class="muted">YOUR COMPANY NAME<br/>Address line 1<br/>Address line 2</p>

      <footer>
        <p class="muted">Thank you for trusting Loving Brain with your family's information. We aim to be transparent and respectful of your privacy.</p>
      </footer>
    </section>
  </div>
</body>
</html>""");
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
