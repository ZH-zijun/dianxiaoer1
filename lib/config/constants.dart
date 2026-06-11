// 店小二 全局常量（V4.0）
// 所有数值常量、颜色、字号、圆角统一管理，禁止代码中出现裸数字
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // 色板（方向2 微调暖色）
  static const Color bgPrimary = Color(0xFF0D0D1A);
  static const Color bgGradientStart = Color(0xFF0D0D1A);
  static const Color bgGradientMid = Color(0xFF0F0F1E);
  static const Color bgGradientEnd = Color(0xFF111122);
  static const Color accent = Color(0xFF00FFCC);
  static const Color accentSecondary = Color(0xFFA890FF);
  static const Color textPrimary = Color(0xFFF0F0F0);
  static const Color textSecondary = Color(0xCCDCDCFF);
  static const Color textDim = Color(0xB3DCDCFF);
  static const Color success = Color(0xFF00FFCC);
  static const Color error = Color(0xFFFF4444);
  static const Color borderDefault = Color(0x0F00FFCC);
  static const Color borderHover = Color(0x6600FFCC);
  static const Color cardBg = Color(0x05FFFFFF);
  static const Color inputBg = Color(0x4D000000);
  static const Color btnBg = Color(0x0F00FFCC);
  static const Color btnActive = Color(0x2600FFCC);
  static const Color shimmerBase = Color(0x0AFFFFFF);
  static const Color shimmerHighlight = Color(0x0FFFFFFF);
  static const Color overlay = Color(0xB3000000);
  static const Color tagNew = Color(0xFFA0FFCC);

  static const List<Color> bgGradient = [bgGradientStart, bgGradientMid, bgGradientEnd];
}

class AppTextSizes {
  AppTextSizes._();

  static const double hero = 42.0;
  static const double heroUnit = 18.0;
  static const double h1 = 20.0;
  static const double h2 = 17.0;
  static const double body = 14.0;
  static const double bodySm = 13.0;
  static const double caption = 12.0;
  static const double captionSm = 11.0;
  static const double input = 12.0;
  static const double toast = 13.0;
}

class AppRadii {
  AppRadii._();

  static const double full = 9999.0;
  static const double xxl = 20.0;
  static const double xl = 16.0;
  static const double lg = 14.0;
  static const double md = 10.0;
  static const double sm = 8.0;
  static const double holdBtn = 34.0;
}

class AppDurations {
  AppDurations._();

  static const int antiMistouchMs = 500;
  static const int toastDurationMs = 2000;
  static const int toastFadeMs = 300;
  static const int toastHoldMs = 1700;
  static const int aiTimeoutSeconds = 30;
  static const int shimmerCycleMs = 1500;
  static const int networkingTimeoutSeconds = 10;
  static const int colorCycleMs = 3000;
}

class AppSizes {
  AppSizes._();

  static const double topbarHeight = 56.0;
  static const double holdBtnHeight = 68.0;
  static const double offlineBarHeight = 36.0;
  static const double iconBtnSize = 36.0;
  static const double toastTopOffset = 120.0;
  static const double watermarkFontSize = 80.0;
  static const double watermarkOpacity = 0.12;
  static const double watermarkRotation = -0.5236; // -30 deg
  static const double cardTopGlow = 1.0;
  static const double btnBottomSpacing = 80.0;
  static const double appBarHeight = 56.0;
  static const double appBarOpacity = 0.85;
}

class AppDefaults {
  AppDefaults._();

  static const String defaultShopName = '我的小店';
  static const String defaultApiKey = '';
  static const bool defaultHasPaid = false;
  static const int defaultDbVersion = 1;
  static const String dbFileName = 'dianxiaoer.db';
}

class AppStrings {
  AppStrings._();

  static const String appName = '店小二';
  static const String watermarkText = '店小二·待打赏';
  static const String holdHint = '按住说话';
  static const String releaseHint = '松手发送，0.5秒防误触';
  static const String recordingHint = '松手发送';
  static const String loadingHint = '正在识别...';
  static const String emptyTitle = '今日暂无订单';
  static const String emptyHint = '按住下方按钮说话\n即可记账、加单、结账';
  static const String settingsTitle = '设置';
  static const String shopSettings = '店铺设置';
  static const String shopName = '店名';
  static const String modelConfig = '大模型配置';
  static const String serviceProvider = '服务商';
  static const String apiKeyLabel = 'API Key';
  static const String viewTutorial = '查看教程';
  static const String save = '保存';
  static const String dataManage = '数据管理';
  static const String exportDb = '导出数据库';
  static const String importDb = '恢复数据库';
  static const String exportPdf = '导出PDF报表';
  static const String disclaimerLabel = '免责声明';
  static const String viewDisclaimer = '查看免责声明';
  static const String footer = '店小二团队';
  static const String rewardTitle = '支持一下作者';
  static const String rewardSubtitle = '店小二持续更新离不开您的支持';
  static const String rewardTier1 = '一包烟';
  static const String rewardTier2 = '两包烟';
  static const String rewardTier3 = '一条烟';
  static const String rewardConfirm = '确认打赏';
  static const String rewardHint = '请在弹窗中完成支付';
  static const String thanksTitle = '感谢您的支持！';
  static const String thanksBody = '您的打赏是我们持续更新的最大动力。店小二会一直陪伴您的大排档生意。';
  static const String thanksDismiss = '知道了';
  static const String onboardingTitle = '欢迎使用店小二';
  static const String onboardingBody = '语音记账助手，烧烤店老板的好帮手。配置AI大模型后即可使用。';
  static const String howToGetApiKey = '如何获取API Key？';
  static const String onboardingStart = '开始使用';
  static const String newProductLabel = '新品询价';
  static const String confirmPrice = '确认价格';
  static const String offlineBarText = '网络不可用，消息待处理';
  static const String badgeRecorded = '已记账';
  static const String badgeUpdated = '已更新';
  static const String badgeClosed = '已清台';
  static const String badgePending = '待发送';
  static const String rewardLink = '打赏一盒烟钱，感谢作者';
  static const String toastRecorded = '{}已记账成功';
  static const String toastUpdated = '{}加单已更新';
  static const String toastClosed = '{}已清台';
  static const String toastNetworkError = '网络不可用，请稍后重试';
  static const String toastAiTimeout = 'AI 解析超时，请重试';
  static const String toastApiKeyInvalid = 'API Key 无效，请在设置中重新配置';
  static const String toastRateLimit = '请求太频繁，请稍后重试';
  static const String toastServiceError = 'AI 服务异常，请稍后重试';
  static const String productNotInCatalog = '未收录品名';
  static const String greetingDay = '{}天';
  static const String greetingText = '店小二已陪伴您';
}
