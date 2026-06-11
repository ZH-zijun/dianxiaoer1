// 打赏弹窗（V4.0）
// 三档选择 + 确认打赏 → 拉起支付
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/ui_provider.dart';

class RewardPanel extends StatefulWidget {
  const RewardPanel({super.key});

  @override
  State<RewardPanel> createState() => _RewardPanelState();
}

class _RewardPanelState extends State<RewardPanel> {
  int _selectedIndex = 1; // 默认中间档 50元

  static const _tiers = [
    {'amount': 30, 'label': AppStrings.rewardTier1},
    {'amount': 50, 'label': AppStrings.rewardTier2},
    {'amount': 100, 'label': AppStrings.rewardTier3},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.xxl)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 关闭按钮
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                context.read<UIProvider>().setShowReward(false);
                Navigator.pop(context);
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Icon(Icons.close, size: 16, color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppStrings.rewardTitle,
            style: TextStyle(
              fontSize: AppTextSizes.heroUnit,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.rewardSubtitle,
            style: TextStyle(
              fontSize: AppTextSizes.bodySm,
              color: AppColors.textDim,
            ),
          ),
          const SizedBox(height: 20),
          // 三档选择
          Row(
            children: List.generate(3, (i) {
              final tier = _tiers[i];
              final isSelected = _selectedIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Container(
                    margin: EdgeInsets.only(
                      left: i == 0 ? 0 : 6,
                      right: i == 2 ? 0 : 6,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent.withValues(alpha: 0.08) : AppColors.cardBg,
                      borderRadius: BorderRadius.circular(AppRadii.md),
                      border: Border.all(
                        color: isSelected ? AppColors.accent : AppColors.borderDefault,
                        width: isSelected ? 1.5 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.15),
                                blurRadius: 12,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${tier['amount']}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? AppColors.accent : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '元',
                          style: TextStyle(
                            fontSize: AppTextSizes.captionSm,
                            color: AppColors.textDim,
                          ),
                        ),
                        Text(
                          tier['label'] as String,
                          style: TextStyle(
                            fontSize: AppTextSizes.captionSm,
                            color: AppColors.textDim,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.rewardHint,
            style: TextStyle(fontSize: AppTextSizes.captionSm, color: AppColors.textDim),
          ),
          const SizedBox(height: 12),
          // 确认按钮
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _tiers[_selectedIndex]['amount']);
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
              child: Text(AppStrings.rewardConfirm),
            ),
          ),
        ],
      ),
    );
  }
}
