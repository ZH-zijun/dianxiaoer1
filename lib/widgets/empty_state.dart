// 空状态组件（V4.0）
import 'package:flutter/material.dart';
import '../config/constants.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '📝',
              style: TextStyle(
                fontSize: 64,
                color: AppColors.textPrimary.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.emptyTitle,
              style: TextStyle(
                fontSize: AppTextSizes.h2,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.emptyHint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppTextSizes.bodySm,
                color: AppColors.textDim,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
