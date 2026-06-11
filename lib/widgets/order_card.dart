// 记账卡片组件（V4.0）
// 支持三种类型：已记账/已更新(加单)/已清台(结账)
import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../models/order.dart';
import '../models/order_item.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  final List<OrderItem> items;

  const OrderCard({
    super.key,
    required this.order,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final isClosed = order.status == 'closed';
    final badgeText = isClosed
        ? AppStrings.badgeClosed
        : AppStrings.badgeRecorded;
    final badgeColor = isClosed ? AppColors.textDim : AppColors.success;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(AppRadii.xxl),
        border: Border(
          top: BorderSide(
            color: isClosed ? AppColors.borderDefault : AppColors.borderHover,
            width: AppSizes.cardTopGlow,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '${order.tableNo}号桌',
                    style: TextStyle(
                      fontSize: AppTextSizes.h2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(order.createdAt),
                    style: TextStyle(
                      fontSize: AppTextSizes.captionSm,
                      fontFamily: 'Consolas',
                      color: AppColors.textDim,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Text(
                  '$badgeText ✓',
                  style: TextStyle(
                    fontSize: AppTextSizes.captionSm,
                    fontWeight: FontWeight.w500,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _buildItemRow(item)),
          if (isClosed && order.totalAmount > 0) ...[
            const Divider(
              color: Color(0x0F00FFCC),
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '合计 ',
                  style: TextStyle(
                    fontSize: AppTextSizes.caption,
                    color: AppColors.textDim,
                  ),
                ),
                Text(
                  '${order.totalAmount.toStringAsFixed(0)}元',
                  style: TextStyle(
                    fontSize: AppTextSizes.h2,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemRow(OrderItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                item.productName,
                style: TextStyle(
                  fontSize: AppTextSizes.body,
                  color: AppColors.textPrimary,
                ),
              ),
              if (item.isNew) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: AppColors.tagNew.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '新品',
                    style: TextStyle(
                      fontSize: 9,
                      color: AppColors.tagNew,
                    ),
                  ),
                ),
              ],
            ],
          ),
          Row(
            children: [
              if (order.status == 'closed')
                Text(
                  '${item.quantity}×${item.unitPrice.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: AppTextSizes.captionSm,
                    color: AppColors.textDim,
                  ),
                )
              else
                Text(
                  '×${item.quantity}',
                  style: TextStyle(
                    fontSize: AppTextSizes.caption,
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(width: 12),
              Text(
                '${item.lineTotal.toStringAsFixed(0)}元',
                style: TextStyle(
                  fontSize: AppTextSizes.bodySm,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}
