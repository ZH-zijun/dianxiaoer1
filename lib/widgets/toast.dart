// Toast 组件（V4.0）
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/ui_provider.dart';

class ToastOverlay extends StatelessWidget {
  const ToastOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UIProvider>(
      builder: (ctx, ui, _) {
        final message = ui.toastMessage;
        if (message == null) return const SizedBox.shrink();
        return Positioned(
          top: AppSizes.toastTopOffset,
          left: 0,
          right: 0,
          child: Center(
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: AppDurations.toastFadeMs),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xD9000000),
                  borderRadius: BorderRadius.circular(AppRadii.xxl),
                  border: Border.all(color: AppColors.borderDefault),
                ),
                child: Text(
                  message,
                  style: TextStyle(
                    color: AppColors.accent,
                    fontSize: AppTextSizes.toast,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
