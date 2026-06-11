// 开机问候卡片（V4.0）
// 打赏入口仅此一处（宪法第16条）
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/config_provider.dart';
import '../providers/ui_provider.dart';

class GreetingCard extends StatelessWidget {
  const GreetingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ConfigProvider, UIProvider>(
      builder: (ctx, config, ui, _) {
        final days = _calculateDays();
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(AppRadii.xl),
            border: Border(
              top: BorderSide(
                color: AppColors.borderDefault,
                width: AppSizes.cardTopGlow,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.05),
                blurRadius: 40,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$days',
                    style: TextStyle(
                      fontSize: AppTextSizes.hero,
                      fontWeight: FontWeight.w300,
                      color: AppColors.accent,
                      shadows: [
                        Shadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      '天',
                      style: TextStyle(
                        fontSize: AppTextSizes.heroUnit,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.greetingText,
                style: TextStyle(
                  fontSize: AppTextSizes.body,
                  color: AppColors.textSecondary,
                ),
              ),
              if (!config.hasPaid) ...[
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () => ui.setShowReward(true),
                  child: Text(
                    AppStrings.rewardLink,
                    style: TextStyle(
                      fontSize: AppTextSizes.caption,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  int _calculateDays() {
    try {
      final start = DateTime(2026, 6, 10);
      final now = DateTime.now();
      return now.difference(start).inDays + 1;
    } catch (_) {
      return 1;
    }
  }
}
