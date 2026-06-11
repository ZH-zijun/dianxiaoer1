// 首次引导页（V4.0）
// 首次安装启动 / API Key 未配置时弹出
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/config_provider.dart';
import '../providers/ui_provider.dart';

class OnboardingDialog extends StatefulWidget {
  const OnboardingDialog({super.key});

  @override
  State<OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<OnboardingDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bgGradientMid,
          borderRadius: BorderRadius.circular(AppRadii.xxl),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '📋',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.onboardingTitle,
              style: TextStyle(
                fontSize: AppTextSizes.heroUnit,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.onboardingBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTextSizes.bodySm,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(AppRadii.sm),
              ),
              child: TextField(
                controller: _controller,
                style: TextStyle(
                  fontSize: AppTextSizes.input,
                  fontFamily: 'Consolas',
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.apiKeyLabel,
                  hintStyle: TextStyle(color: AppColors.textDim),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // TODO: 打开教程链接
              },
              child: Text(
                AppStrings.howToGetApiKey,
                style: TextStyle(
                  fontSize: AppTextSizes.captionSm,
                  color: AppColors.accent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () {
                  final key = _controller.text.trim();
                  if (key.isNotEmpty) {
                    context.read<ConfigProvider>().setApiKey(key);
                  }
                  context.read<UIProvider>().setShowOnboarding(false);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.bgPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  textStyle: TextStyle(
                    fontSize: AppTextSizes.body,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(AppStrings.onboardingStart),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
