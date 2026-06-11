// 按住说话按钮（V4.0）
// 防误触 500ms，按下动画+波形，松手触发录音发送
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/ui_provider.dart';

class HoldButton extends StatefulWidget {
  final void Function() onSend;

  const HoldButton({super.key, required this.onSend});

  @override
  State<HoldButton> createState() => _HoldButtonState();
}

class _HoldButtonState extends State<HoldButton> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  Timer? _holdTimer;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _waveController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() => _isPressed = true);
    _holdTimer = Timer(const Duration(milliseconds: AppDurations.antiMistouchMs), () {
      // 防误触通过，开始有效录音
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    if (!_isPressed) return;
    _holdTimer?.cancel();
    _holdTimer = null;
    final wasPressed = _isPressed;
    setState(() => _isPressed = false);

    if (wasPressed) {
      widget.onSend();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = context.watch<UIProvider>().isOffline;
    final borderColor = isOffline ? AppColors.error : AppColors.borderHover;
    final textColor = isOffline
        ? AppColors.error
        : _isPressed
            ? AppColors.accent
            : AppColors.accent;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Container(
        height: AppSizes.holdBtnHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: _isPressed
                ? [AppColors.btnActive, AppColors.btnActive]
                : [AppColors.btnBg, AppColors.btnBg.withValues(alpha: 0.3)],
          ),
          borderRadius: BorderRadius.circular(AppRadii.holdBtn),
          border: Border.all(
            color: _isPressed ? borderColor : AppColors.borderDefault,
            width: _isPressed ? 1.5 : 1,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: borderColor.withValues(alpha: 0.25),
                    blurRadius: 40,
                    offset: const Offset(0, 0),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: _isPressed ? _buildWaveform(textColor) : Text(
            AppStrings.holdHint,
            style: TextStyle(
              fontSize: 18,
              letterSpacing: 3,
              fontWeight: FontWeight.w500,
              color: textColor.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaveform(Color color) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (ctx, _) {
        final random = Random(42);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (i) {
            final phase = _waveController.value * 2 * pi;
            final height = 12.0 + sin(phase + i * 0.8) * 5.0 + random.nextDouble() * 3;
            return Container(
              width: 4,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
