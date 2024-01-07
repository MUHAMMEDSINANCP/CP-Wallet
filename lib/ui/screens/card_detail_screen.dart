import 'package:cp_wallet/ui/widgets/credit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../utils/constants.dart';
import '../widgets/blur_card.dart';

class CardDetailScreen extends StatefulWidget {
  final Future<bool> Function()? onBack;
  const CardDetailScreen({super.key, this.onBack});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen>
    with TickerProviderStateMixin {
  final double _leftCicleSize = 180;
  final double _rightCicleSize = 220;

  final _keyTitle = GlobalKey();
  final _keyGesture = GlobalKey();
  final _keyBalanceCard = GlobalKey();
  final _keySettingCard = GlobalKey();
  final _keyList = GlobalKey();
  final _keyCreditCard = GlobalKey();

  late final AnimationController _pageAnimation;

  late Animation<Offset> _titleAnimation;
  late Animation<double> _titleOpacityAnimation;
  late Animation<Offset> _circleLeftAnimation;
  late Animation<Offset> _circleRightAnimation;
  late Animation<Offset> _balanceCardAnimation;
  late Animation<Offset> _settingCardAnimation;
  late Animation<Offset> _listAnimation;
  late Animation<Offset> _creditCardAnimation;

  double _startY = 0.0;

  @override
  void initState() {
    _initAnimController();
    _initEmptyAnimations();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _initAnimations();
      _pageAnimation.forward().orCancel;
    });
  }

  void _initAnimController() {
    _pageAnimation = AnimationController(
      vsync: this,
      duration: detailPageEntryDuration,
      reverseDuration: detailPageEntryDuration * 0.75,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          _onTapBack();
        }
      });
  }

  @override
  void dispose() {
    _pageAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) async {
        await _pageAnimation.reverse().orCancel;
        if (widget.onBack != null) {
          await widget.onBack!();
          return;
        }

        if (mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Transform.translate(
                    offset: _titleAnimation.value,
                    child: Opacity(
                      opacity: _titleOpacityAnimation.value,
                      child: Row(
                        key: _keyTitle,
                        children: [
                          IconButton(
                              onPressed: () async {
                                await _pageAnimation.reverse().orCancel;
                              },
                              icon: const Icon(Icons.close)),
                          Text(
                            "Your Wallet",
                            style: Theme.of(context).textTheme.titleLarge,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      bottom: -50,
                      child: Transform.translate(
                        offset: _circleLeftAnimation.value,
                        child: SizedBox.square(
                          dimension: _leftCicleSize,
                          child: const DecoratedBox(
                              decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          )),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -50,
                      right: 0,
                      child: Transform.translate(
                        offset: _circleRightAnimation.value,
                        child: SizedBox.square(
                          dimension: _rightCicleSize,
                          child: const DecoratedBox(
                              decoration: BoxDecoration(
                            color: Colors.cyan,
                            shape: BoxShape.circle,
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Transform.translate(
                          offset: _creditCardAnimation.value,
                          child: GestureDetector(
                            key: _keyGesture,
                            onVerticalDragStart: _onDragStart,
                            onVerticalDragCancel: _onDragEnd,
                            onVerticalDragEnd: (_) => _onDragEnd(),
                            onVerticalDragUpdate: _onDragUpdate,
                            child: Hero(
                                tag: "credit_card",
                                child: CreditCardWidget(
                                  key: _keyCreditCard,
                                  blur: 20.0,
                                )),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                          child: Transform.translate(
                              offset: _balanceCardAnimation.value,
                              child: _ThisBalanceCard(
                                key: _keyBalanceCard,
                              )),
                        ),
                        const SizedBox(width: 24),
                        AspectRatio(
                            aspectRatio: 1.0,
                            child: Transform.translate(
                                offset: _settingCardAnimation.value,
                                child: _ThisSettingsCard(
                                  key: _keySettingCard,
                                ))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Transform.translate(
                    offset: _listAnimation.value,
                    child: BlurCard(
                      child: ListView.builder(
                          key: _keyList,
                          padding: const EdgeInsets.all(20),
                          itemBuilder: (context, index) => _ThisListItemWidget(
                                date:
                                    DateTime.now().add(Duration(days: -index)),
                              ),
                          itemCount: 10),
                    ),
                  ),
                ))
              ],
            ),
          ),
        );
      }),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final diff = details.localPosition.dy - _startY;
    if (diff < 0) return;
    final box = _keyGesture.currentContext!.findRenderObject() as RenderBox;
    final value = (diff / box.size.height).clamp(0.0, 1.0);
    _pageAnimation.value = 1 - value;
  }

  void _onDragEnd() {
    _startY = 0.0;
    if (_pageAnimation.value > 0.75) {
      _pageAnimation.forward();
    } else {
      _pageAnimation.reverse();
    }
  }

  void _onDragStart(DragStartDetails details) {
    _startY = details.localPosition.dy;
  }

  void _onTapBack() async {
    await _pageAnimation.reverse().orCancel;

    if (widget.onBack != null) {
      final res = await widget.onBack!();
      if (!res) return;
    }
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _initEmptyAnimations() {
    _titleOpacityAnimation = ConstantTween<double>(0.0).animate(_pageAnimation);
    _titleAnimation =
        ConstantTween<Offset>(Offset.zero).animate(_pageAnimation);
    _circleLeftAnimation =
        ConstantTween<Offset>(Offset.zero).animate(_pageAnimation);
    _circleRightAnimation =
        ConstantTween<Offset>(Offset.zero).animate(_pageAnimation);
    _balanceCardAnimation =
        ConstantTween<Offset>(Offset.zero).animate(_pageAnimation);
    _settingCardAnimation =
        ConstantTween<Offset>(Offset.zero).animate(_pageAnimation);
    _listAnimation = ConstantTween<Offset>(Offset.zero).animate(_pageAnimation);
    _creditCardAnimation =
        ConstantTween<Offset>(Offset.zero).animate(_pageAnimation);
  }

  void _initAnimations() {
    Offset offset;
    Size size;

    final screenSize = MediaQuery.of(context).size;

    _titleOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _pageAnimation, curve: Curves.ease));
    _titleAnimation = Tween<Offset>(
      begin: const Offset(-10.0, -10.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pageAnimation, curve: Curves.ease));

    _circleLeftAnimation = Tween<Offset>(
      begin: Offset(-_leftCicleSize, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pageAnimation, curve: Curves.ease));

    _circleRightAnimation = Tween<Offset>(
      begin: Offset(_rightCicleSize, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pageAnimation, curve: Curves.ease));

    (offset, size) = getOffsetSizeFromKey(_keyBalanceCard);
    _balanceCardAnimation = Tween<Offset>(
      begin: Offset(-(offset.dy + size.width), 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pageAnimation, curve: Curves.ease));

    (offset, size) = getOffsetSizeFromKey(_keySettingCard);
    _settingCardAnimation = Tween<Offset>(
      begin: Offset((offset.dy + size.width), 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pageAnimation, curve: Curves.ease));

    (offset, size) = getOffsetSizeFromKey(_keyList);
    _listAnimation = Tween<Offset>(
      begin: Offset(0.0, screenSize.height + offset.dy),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pageAnimation, curve: Curves.ease));

    (offset, size) = getOffsetSizeFromKey(_keyCreditCard);
    _creditCardAnimation = Tween<Offset>(
      begin: const Offset(0.0, 100.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _pageAnimation, curve: Curves.ease));
  }
}

class _ThisListItemWidget extends StatelessWidget {
  final DateTime date;
  const _ThisListItemWidget({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                DateFormat("dd MMMM").format(date),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54,
                ),
              ),
            ),
            const Text(
              "\$200.20",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white54,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(10),
              child: FittedBox(
                child: Icon(
                  Icons.credit_card,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "ATM, 375 Canal St",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Cash withdrawal",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.45),
                  ),
                ),
              ],
            )),
            const SizedBox(width: 12),
            const Text(
              "-\$300.00",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _ThisSettingsCard extends StatelessWidget {
  const _ThisSettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: BlurCard(
          width: null,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.security),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )),
    );
  }
}

class _ThisBalanceCard extends StatelessWidget {
  const _ThisBalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlurCard(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Expanded(
                  child: Text(
                    "Balance",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white54,
                    ),
                  ),
                ),
                Icon(
                  Icons.ssid_chart_rounded,
                  color: Colors.green,
                )
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "\$6,253.2%",
              style: GoogleFonts.electrolize(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
