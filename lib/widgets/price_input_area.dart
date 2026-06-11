// 价格输入区组件（V4.0）
// AI 解析到未知品名时显示，引导用户输入价格
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/ui_provider.dart';

class PriceInputArea extends StatefulWidget {
  final void Function(Map<String, double>) onConfirm;

  const PriceInputArea({super.key, required this.onConfirm});

  @override
  State<PriceInputArea> createState() => _PriceInputAreaState();
}

class _PriceInputAreaState extends State<PriceInputArea> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newProducts = context.watch<UIProvider>().newProducts;
    if (newProducts.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadii.xxl),
        border: Border(
          top: BorderSide(
            color: AppColors.accentSecondary.withValues(alpha: 0.4),
            width: AppSizes.cardTopGlow,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📌 ${AppStrings.newProductLabel}',
            style: TextStyle(
              fontSize: AppTextSizes.caption,
              color: AppColors.accentSecondary,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          ...newProducts.map((product) {
            final name = product['name'] as String;
            _controllers.putIfAbsent(name, () => TextEditingController());
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: AppTextSizes.body,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.inputBg,
                        borderRadius: BorderRadius.circular(AppRadii.sm),
                      ),
                      child: TextField(
                        controller: _controllers[name],
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: AppTextSizes.input,
                          fontFamily: 'Consolas',
                          color: AppColors.accent,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          border: InputBorder.none,
                          hintText: '价格',
                          hintStyle: TextStyle(color: AppColors.textDim, fontSize: AppTextSizes.input),
                          suffixText: '元/份',
                          suffixStyle: TextStyle(fontSize: AppTextSizes.captionSm, color: AppColors.textDim),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                final prices = <String, double>{};
                for (final entry in _controllers.entries) {
                  final val = double.tryParse(entry.value.text);
                  if (val != null && val > 0) {
                    prices[entry.key] = val;
                  }
                }
                if (prices.isNotEmpty) {
                  widget.onConfirm(prices);
                  context.read<UIProvider>().clearNewProducts();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.bgPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                textStyle: TextStyle(
                  fontSize: AppTextSizes.caption,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(AppStrings.confirmPrice),
            ),
          ),
        ],
      ),
    );
  }
}
