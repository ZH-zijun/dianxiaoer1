// 感谢信弹窗（V4.0）
// 仅在打赏支付成功后弹出
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/ui_provider.dart';

class ThanksDialog extends StatelessWidget {
  const ThanksDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.bgGradientMid,
          borderRadius: BorderRadius.circular(AppRadii.xxl),
          border: Border.all(color: AppColors.borderDefault),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.1),
              blurRadius: 60,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🎁',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.thanksTitle,
              style: TextStyle(
                fontSize: AppTextSizes.h1,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.thanksBody,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTextSizes.body,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.read<UIProvider>().setShowThanks(false);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.bgPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  textStyle: TextStyle(
                    fontSize: AppTextSizes.body,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: Text(AppStrings.thanksDismiss),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
