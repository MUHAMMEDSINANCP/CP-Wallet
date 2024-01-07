import 'package:cp_wallet/ui/widgets/blur_card.dart';
import 'package:cp_wallet/ui/widgets/credit_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BalanceCard extends StatefulWidget {
  final AnimationController dragController;
  final AnimationController animationController;
  const BalanceCard({
    required this.animationController,
    required this.dragController,
    super.key,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard>
    with SingleTickerProviderStateMixin {
  double _startY = 0.0;

  @override
  void initState() {
    widget.animationController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const double limit = 5.0;
    double animVal = widget.animationController.value;
    final scale = 1 - (animVal * limit).clamp(0.0, 1.0);
    return BlurCard(
      borderWidth: 0.3,
      clipBehaviour: Clip.none,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..scale(1 - 0.125 * scale, 1 - 0.200 * scale)
                ..translate(0.0, -500 * animVal),
              child: Hero(
                tag: "credit_card",
                child: GestureDetector(
                  onVerticalDragUpdate: _onDragUpdate,
                  onVerticalDragStart: _onDragStart,
                  onVerticalDragCancel: _onDragCancel,
                  onVerticalDragEnd: _onDragEnd,
                  child: const CreditCardWidget(),
                ),
              ),
            ),
          ),
          const _ThisBalanceDetailWidget(),
          Container(),
        ],
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    double value = (details.localPosition.dy - _startY) / 100;

    widget.dragController.value = value.abs();
  }

  void _onDragStart(DragStartDetails details) {
    _startY = details.localPosition.dy;
  }

  void _onDragCancel() {
    _finishAnim();
    _startY = 0.0;
  }

  void _onDragEnd(DragEndDetails details) {
    _finishAnim();
    _startY = 0.0;
  }

  void _finishAnim() {
    if (widget.dragController.value > 0.4) {
      widget.dragController.forward().orCancel;
    } else {
      widget.dragController.reverse().orCancel;
    }
  }
}

class _ThisBalanceDetailWidget extends StatefulWidget {
  const _ThisBalanceDetailWidget();

  @override
  State<_ThisBalanceDetailWidget> createState() =>
      _ThisBalanceDetailWidgetState();
}

class _ThisBalanceDetailWidgetState extends State<_ThisBalanceDetailWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dragController;
  double _dragStartY = 0.0;
  final double _height = 200;
  @override
  void initState() {
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _dragController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _height,
      child: GestureDetector(
        onVerticalDragUpdate: _onDragUpdate,
        onVerticalDragDown: _onDragDown,
        onVerticalDragCancel: _onDragCancel,
        onVerticalDragEnd: _onDragEnd,
        onVerticalDragStart: _onDragStart,
        child: Stack(
          children: [
            Positioned.fill(
              top: 100 * _dragController.value,
              child: BlurCard(
                borderWidth: 0.3,
                whiteOpacity: 0.0,
                blur: 8,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        width: 44,
                        height: 6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.grey.withOpacity(0.7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  "Balance",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white54,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Container(
                                      width: 30,
                                      height: 30,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.amber,
                                      ),
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(4),
                                      child: const FittedBox(
                                        child: Icon(
                                          Icons.attach_money_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "8,614.14",
                                      style: GoogleFonts.electrolize(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 16),
                            child: const Text(
                              "See more",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 0.0,
              right: 0.0,
              child: Opacity(
                opacity: (1 - (_dragController.value * 2)).clamp(0.0, 1.0),
                child: const _ThisBottomSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final y = details.localPosition.dy;
    double value = (y - _dragStartY) / _height;

    if (value.isNegative) {
      if (_dragController.value <= 0) return;
      value += 1;
    } else if (_dragController.value >= 1) {
      return;
    }

    _dragController.value = value;
  }

  void _onDragDown(DragDownDetails details) {}

  void _onDragCancel() {
    _finishAnim();
    _dragStartY = 0;
  }

  void _onDragEnd(DragEndDetails details) {
    _finishAnim();
    _dragStartY = 0;
  }

  void _onDragStart(DragStartDetails details) {
    _dragStartY = details.localPosition.dy;
  }

  void _finishAnim() {
    if (_dragController.value < 0.5) {
      _dragController.reverse();
    } else {
      _dragController.forward();
    }
  }
}

class _ThisBottomSection extends StatelessWidget {
  const _ThisBottomSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  "23 March",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white54,
                  ),
                ),
              ),
              Text(
                "-\$ 145",
                style: GoogleFonts.electrolize(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black38,
                ),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                child: const FittedBox(
                  child: Icon(
                    Icons.credit_card_rounded,
                    color: Colors.white54,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "ATM, 375 Canal St",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Cash withdrawal",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                "-\$ 145",
                style: GoogleFonts.electrolize(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
