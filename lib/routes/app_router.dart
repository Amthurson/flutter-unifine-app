import 'package:go_router/go_router.dart';
import '../pages/splash_page.dart';
import '../pages/auth/verification_login_page.dart';
import '../pages/auth/password_login_page.dart';
import '../pages/auth/forgot_password_page.dart';
import '../pages/auth/register_page.dart';
import '../pages/auth/privacy_policy_page.dart';
import '../pages/main/home_page.dart';
import '../pages/contacts/contacts_page.dart';
import '../pages/contacts/new_friends_page.dart';
import '../pages/contacts/my_friends_page.dart';
import '../pages/contacts/assist_groups_page.dart';
import '../pages/profile/real_name_auth_page.dart';
import '../pages/profile/face_collection_page.dart';
import '../pages/profile/app_share_page.dart';
import '../pages/profile/about_app_page.dart';
import '../pages/message/im_message_list_page.dart';
import '../pages/test_back_button.dart';
import '../pages/profile/settings_page.dart';
import '../pages/profile/my_qrcode_page.dart';
import '../pages/profile/account_security_page.dart';
import '../pages/profile/set_phone_page.dart';
import '../pages/profile/set_password_page.dart';
import '../pages/profile/delete_account_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // 启动页
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // 测试返回按钮页面
      GoRoute(
        path: '/test-back',
        name: 'test-back',
        builder: (context, state) => const TestBackButtonPage(),
      ),

      // 验证码登录页
      GoRoute(
        path: '/verification-login',
        name: 'verification-login',
        builder: (context, state) => const VerificationLoginPage(),
      ),

      // 密码登录页
      GoRoute(
        path: '/password-login',
        name: 'password-login',
        builder: (context, state) => const PasswordLoginPage(),
      ),

      // 找回密码页
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // 快速注册页
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // 个人信息保护指引页
      GoRoute(
        path: '/privacy-policy',
        name: 'privacy-policy',
        builder: (context, state) => const PrivacyPolicyPage(),
      ),

      // 主页（带导航和侧边栏）
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),

      // 通讯录页
      GoRoute(
        path: '/contacts',
        name: 'contacts',
        builder: (context, state) => const ContactsPage(),
      ),

      // 新的朋友页
      GoRoute(
        path: '/new-friends',
        name: 'new-friends',
        builder: (context, state) => const NewFriendsPage(),
      ),

      // 我的朋友页
      GoRoute(
        path: '/my-friends',
        name: 'my-friends',
        builder: (context, state) => const MyFriendsPage(),
      ),

      // 协助组页
      GoRoute(
        path: '/assist-groups',
        name: 'assist-groups',
        builder: (context, state) => const AssistGroupsPage(),
      ),

      // 实名认证页
      GoRoute(
        path: '/real-name-auth',
        name: 'real-name-auth',
        builder: (context, state) => const RealNameAuthPage(),
      ),

      // 人脸采集页
      GoRoute(
        path: '/face-collection',
        name: 'face-collection',
        builder: (context, state) => const FaceCollectionPage(),
      ),

      // APP分享二维码页
      GoRoute(
        path: '/app-share',
        name: 'app-share',
        builder: (context, state) => const AppSharePage(),
      ),

      // 关于APP页
      GoRoute(
        path: '/about-app',
        name: 'about-app',
        builder: (context, state) => const AboutAppPage(),
      ),

      // IM消息列表页
      GoRoute(
        path: '/im-messages',
        name: 'im-messages',
        builder: (context, state) => const ImMessageListPage(),
      ),

      // 设置页
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),

      // 我的二维码页
      GoRoute(
        path: '/my-qrcode',
        name: 'my-qrcode',
        builder: (context, state) => const MyQrcodePage(),
      ),

      // 账号与安全页
      GoRoute(
        path: '/account-security',
        name: 'account-security',
        builder: (context, state) => const AccountSecurityPage(),
      ),

      // 设置手机号页
      GoRoute(
        path: '/set-phone',
        name: 'set-phone',
        builder: (context, state) => const SetPhonePage(),
      ),

      // 设置密码页
      GoRoute(
        path: '/set-password',
        name: 'set-password',
        builder: (context, state) => const SetPasswordPage(),
      ),

      // 注销账号页
      GoRoute(
        path: '/delete-account',
        name: 'delete-account',
        builder: (context, state) => const DeleteAccountPage(),
      ),
    ],
  );
}
