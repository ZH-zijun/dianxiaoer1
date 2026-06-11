// 骨架屏组件（V4.0）
import 'package:flutter/material.dart';
import '../config/constants.dart';

class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDurations.shimmerCycleMs),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, _) {
        final shimmerOffset = _controller.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(AppRadii.xxl),
            border: Border(
              top: BorderSide(
                color: AppColors.borderDefault,
                width: AppSizes.cardTopGlow,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _shimmerLine(shimmerOffset, 0.4),
              const SizedBox(height: 10),
              _shimmerLine(shimmerOffset, 0.65),
              const SizedBox(height: 10),
              _shimmerLine(shimmerOffset, 0.9),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerLine(double offset, double widthRatio) {
    return Container(
      height: 14,
      width: MediaQuery.of(context).size.width * 0.7 * widthRatio,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment(offset * 2 - 1, 0),
          end: Alignment(offset * 2, 0),
          colors: [
            AppColors.shimmerBase,
            AppColors.shimmerHighlight,
            AppColors.shimmerBase,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
