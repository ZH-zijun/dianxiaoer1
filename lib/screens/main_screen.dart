// 主界面（V4.0）
// 对应设计稿：开机问候卡片 → 记账卡片列表 → 按住说话按钮
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/constants.dart';
import '../providers/config_provider.dart';
import '../providers/order_provider.dart';
import '../providers/ui_provider.dart';
import '../services/ai_service.dart';
import '../widgets/greeting_card.dart';
import '../widgets/order_card.dart';
import '../widgets/hold_button.dart';
import '../widgets/watermark.dart';
import '../widgets/toast.dart';
import '../widgets/offline_bar.dart';
import '../widgets/skeleton_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/reward_panel.dart';
import '../widgets/thanks_dialog.dart';
import '../widgets/onboarding_dialog.dart';
import '../widgets/price_input_area.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late final AnimationController _statusBarController;
  late final Animation<Color?> _statusBarColor;

  @override
  void initState() {
    super.initState();
    _statusBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDurations.colorCycleMs),
    )..repeat(reverse: true);

    _statusBarColor = ColorTween(
      begin: AppColors.accent,
      end: AppColors.accent.withValues(alpha: 0.4),
    ).animate(CurvedAnimation(parent: _statusBarController, curve: Curves.easeInOut));
    _init();
  }

  Future<void> _init() async {
    final configProvider = context.read<ConfigProvider>();
    await configProvider.loadConfig();

    if (!mounted) return;
    final ui = context.read<UIProvider>();

    // 检查是否需要首次引导
    final apiKey = configProvider.apiKey;
    if (apiKey.isEmpty || apiKey == AppDefaults.defaultApiKey) {
      ui.setShowOnboarding(true);
    }

    // 加载今日订单
    context.read<OrderProvider>().loadTodayOrders();

    // 监听打赏事件
    ui.addListener(() {
      if (ui.showReward) {
        _showRewardPanel();
      }
      if (ui.showOnboarding) {
        showDialog(context: context, builder: (_) => const OnboardingDialog());
      }
    });
  }

  @override
  void dispose() {
    _statusBarController.dispose();
    super.dispose();
  }

  void _showRewardPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const RewardPanel(),
    ).then((amount) {
      if (amount != null && amount is int) {
        _handlePayment(amount);
      }
    });
  }

  Future<void> _handlePayment(int amount) async {
    final ui = context.read<UIProvider>();
    // TODO: 接入支付 SDK
    // 模拟支付成功
    context.read<ConfigProvider>().markPaid();
    ui.setShowReward(false);
    ui.showToast('打赏成功，感谢您的支持');
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      ui.setShowThanks(true);
      showDialog(
        context: context,
        builder: (_) => const ThanksDialog(),
      );
    }
  }

  void _handleVoiceSend() {
    // TODO: 启动录音
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => _RecordingDialog(),
    ).then((text) {
      if (text != null && text is String && text.isNotEmpty) {
        _processVoice(text);
      }
    });
  }

  Future<void> _processVoice(String text) async {
    final ui = context.read<UIProvider>();
    final config = context.read<ConfigProvider>();
    final orderProvider = context.read<OrderProvider>();

    ui.setParsing(true);

    try {
      final response = await orderProvider.processVoiceText(text, config.apiKey);

      if (response.isNewOrder) {
        await orderProvider.createOrder(response);
        ui.showToast('${response.tableNo}号桌已记账');
      } else if (response.isAddItems) {
        // 加单通过 tableNo 匹配最近未清台订单
        final todayOrders = orderProvider.todayOrders;
        final active = todayOrders.where((o) => o.status != 'closed' && o.tableNo == response.tableNo);
        if (active.isNotEmpty) {
          await orderProvider.addItems(active.first.id!, response);
          ui.showToast('${response.tableNo}号桌已加单');
        }
      } else if (response.isCloseOrder) {
        final todayOrders = orderProvider.todayOrders;
        final target = todayOrders.where((o) => o.status != 'closed' && o.tableNo == response.tableNo);
        if (target.isNotEmpty) {
          await orderProvider.closeOrder(target.first.id!);
          ui.showToast('${response.tableNo}号桌已清台');
        }
      }

      // 检查是否有新品需要输入价格
      final newItems = response.items.where((i) => i.isNew).toList();
      if (newItems.isNotEmpty) {
        final newProducts = newItems.map((i) => {
          'name': i.name,
          'quantity': i.quantity,
        }).toList();
        ui.setNewProducts(newProducts.cast<Map<String, dynamic>>());
      }
    } on AiException catch (e) {
      ui.showToast(e.message);
    } catch (e) {
      ui.showToast('网络异常，已加入离线队列');
      await orderProvider.enqueueOffline(text);
    } finally {
      ui.setParsing(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // 背景渐变
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x0800FFCC),
                  Colors.transparent,
                  Color(0x0500FFCC),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const OfflineBar(),
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.accent,
                    onRefresh: () => context.read<OrderProvider>().loadTodayOrders(),
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                            child: Column(
                              children: [
                                const GreetingCard(),
                                Consumer<OrderProvider>(
                                  builder: (ctx, orderProvider, _) {
                                    if (orderProvider.isLoading) {
                                      return Column(
                                        children: List.generate(3, (_) => const SkeletonCard()),
                                      );
                                    }

                                    final orders = orderProvider.todayOrders;
                                    if (orders.isEmpty) {
                                      return const EmptyState();
                                    }

                                    return Column(
                                      children: orders.map((order) {
                                        final items = orderProvider.getItemsForOrder(order.id ?? 0);
                                        return OrderCard(order: order, items: items);
                                      }).toList(),
                                    );
                                  },
                                ),
                                Consumer<UIProvider>(
                                  builder: (ctx, ui, _) {
                                    if (ui.newProducts.isNotEmpty) {
                                      return PriceInputArea(onConfirm: (prices) {
                                        // 价格确认后更新本地数据库单价
                                      });
                                    }
                                    return const SizedBox.shrink();
                                  },
                                ),
                                const SizedBox(height: AppSizes.btnBottomSpacing),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 按住说话按钮
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: HoldButton(onSend: _handleVoiceSend),
                ),
              ],
            ),
          ),
          // 水印
          const Watermark(),
          // Toast
          const ToastOverlay(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(AppSizes.appBarHeight),
      child: Consumer2<ConfigProvider, UIProvider>(
        builder: (ctx, config, ui, _) {
          return AppBar(
            backgroundColor: AppColors.bgPrimary.withValues(alpha: 0.85),
            surfaceTintColor: Colors.transparent,
            title: AnimatedBuilder(
              animation: _statusBarColor,
              builder: (ctx, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _statusBarColor.value,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      config.shopName,
                      style: TextStyle(
                        fontSize: AppTextSizes.body,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings_outlined, size: 20, color: AppColors.textSecondary),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

// 设置页
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary.withValues(alpha: 0.85),
        surfaceTintColor: Colors.transparent,
        title: Text(
          '设置',
          style: TextStyle(
            fontSize: AppTextSizes.body,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 16, color: AppColors.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ConfigProvider>(
        builder: (ctx, config, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSection('店铺'),
              _buildSettingTile(
                context,
                '店铺名称',
                config.shopName,
                Icons.store_outlined,
                onEdit: (val) => config.setShopName(val),
              ),
              _buildSettingTile(
                context,
                'DeepSeek API Key',
                config.apiKey.isNotEmpty && config.apiKey != AppDefaults.defaultApiKey
                    ? '${config.apiKey.substring(0, 8)}...'
                    : '',
                Icons.key,
                onEdit: (val) => config.setApiKey(val),
              ),
              const SizedBox(height: 24),
              _buildSection('关于'),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.info_outline, color: AppColors.textSecondary, size: 20),
                title: Text('版本', style: TextStyle(color: AppColors.textPrimary, fontSize: AppTextSizes.bodySm)),
                trailing: Text(
                  '4.0.0',
                  style: TextStyle(color: AppColors.textDim, fontSize: AppTextSizes.caption, fontFamily: 'Consolas'),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.favorite_border, color: AppColors.textSecondary, size: 20),
                title: Text('打赏状态', style: TextStyle(color: AppColors.textPrimary, fontSize: AppTextSizes.bodySm)),
                trailing: Text(
                  config.hasPaid ? '已打赏' : '未打赏',
                  style: TextStyle(
                    color: config.hasPaid ? AppColors.success : AppColors.textDim,
                    fontSize: AppTextSizes.caption,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppTextSizes.captionSm,
          fontWeight: FontWeight.w600,
          color: AppColors.textDim,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, String label, String value, IconData icon, {void Function(String)? onEdit}) {
    final controller = TextEditingController(text: value);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppColors.textSecondary, size: 20),
      title: Text(label, style: TextStyle(color: AppColors.textPrimary, fontSize: AppTextSizes.bodySm)),
      trailing: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.cardBg,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.md)),
              title: Text('修改$label', style: TextStyle(color: AppColors.textPrimary)),
              content: TextField(
                controller: controller,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: label,
                  hintStyle: TextStyle(color: AppColors.textDim),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.borderDefault),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.accent),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('取消', style: TextStyle(color: AppColors.textDim)),
                ),
                TextButton(
                  onPressed: () {
                    onEdit?.call(controller.text);
                    Navigator.pop(ctx);
                  },
                  child: Text('保存', style: TextStyle(color: AppColors.accent)),
                ),
              ],
            ),
          );
        },
        child: Text(
          value.isEmpty ? '点击设置' : value,
          style: TextStyle(
            color: value.isEmpty ? AppColors.textDim : AppColors.textSecondary,
            fontSize: AppTextSizes.caption,
          ),
        ),
      ),
    );
  }
}

// 录音中对话框占位
class _RecordingDialog extends StatefulWidget {
  @override
  State<_RecordingDialog> createState() => __RecordingDialogState();
}

class __RecordingDialogState extends State<_RecordingDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgGradientMid,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.xl)),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🎤',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              '正在聆听...',
              style: TextStyle(
                fontSize: AppTextSizes.h2,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context, '3号桌 两碗牛肉面 加一个炒青菜'),
              child: Text('模拟完成', style: TextStyle(color: AppColors.accentSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}