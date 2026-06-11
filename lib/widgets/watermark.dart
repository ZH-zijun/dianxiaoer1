// 水印层组件（V4.0）
// 覆盖全屏的半透明水印，打赏后隐藏
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/config_provider.dart';

class Watermark extends StatelessWidget {
  const Watermark({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConfigProvider>(
      builder: (ctx, config, _) {
        if (config.hasPaid) return const SizedBox.shrink();
        return const _WatermarkView();
      },
    );
  }
}

class _WatermarkView extends StatelessWidget {
  const _WatermarkView();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: List.generate(6, (i) {
          final leftOffset = -100.0 + i * 160.0;
          return Positioned(
            left: leftOffset,
            top: 0,
            bottom: 0,
            width: 200,
            child: Transform.rotate(
              angle: AppSizes.watermarkRotation,
              child: Center(
                child: Text(
                  AppStrings.watermarkText,
                  style: TextStyle(
                    fontSize: AppSizes.watermarkFontSize,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary.withValues(alpha: AppSizes.watermarkOpacity),
                    letterSpacing: 8,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
