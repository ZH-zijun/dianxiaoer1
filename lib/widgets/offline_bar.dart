// 离线状态条组件（V4.0）
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/ui_provider.dart';

class OfflineBar extends StatelessWidget {
  const OfflineBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UIProvider>(
      builder: (ctx, ui, _) {
        if (!ui.isOffline) return const SizedBox.shrink();
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: AppSizes.offlineBarHeight,
          color: AppColors.error,
          alignment: Alignment.center,
          child: Text(
            AppStrings.offlineBarText,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppTextSizes.caption,
            ),
          ),
        );
      },
    );
  }
}
