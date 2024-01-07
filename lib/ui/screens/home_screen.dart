import 'package:cp_wallet/ui/screens/card_detail_screen.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/balance_card.dart';
import '../widgets/home_banner_card.dart';
import '../widgets/home_bottom_app_bar.dart';
import '../widgets/monthly_stat_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _keyTopHeader = GlobalKey();
  final _keyTopBanner = GlobalKey();
  final _keyBalanceCard = GlobalKey();
  final _keyProfitCard = GlobalKey();
  final _keyFAB = GlobalKey();
  final _keyBottomBar = GlobalKey();

  late final AnimationController _dragController;
  late final AnimationController _detailPageEntryController;

  late Animation<Offset> _topHeaderAnimation;
  late Animation<Offset> _topBannerAnimation;
  late Animation<Offset> _balanceCardAnimation;
  late Animation<Offset> _profitCardAnimation;
  late Animation<Offset> _profitCardRightAnimation;
  late Animation<Offset> _fabAnimation;
  late Animation<Offset> _bottomBarAnimation;

  @override
  void initState() {
    _initDragController();
    _initDetailPageEntryController();

    _initEmptyAnimations();

    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(const Duration(milliseconds: 350));

      _initAnimations();
    });
  }

  @override
  void dispose() {
    _dragController.dispose();
    _detailPageEntryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(),
      bottomNavigationBar: Transform.translate(
          offset: _bottomBarAnimation.value,
          child: HomeBottomAppBar(
            key: _keyBottomBar,
          )),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          clipBehavior: Clip.none,
          padding: const EdgeInsets.symmetric(horizontal: 24)
              .add(const EdgeInsets.only(bottom: 36, top: 16)),
          child: Column(
            children: [
              Column(
                children: [
                  AnimatedBuilder(
                    animation: _topHeaderAnimation,
                    builder: (context, child) => Transform.translate(
                        offset: _topHeaderAnimation.value, child: child),
                    child: _ThisHeaderWidget(
                      key: _keyTopHeader,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Transform.translate(
                    offset: _topBannerAnimation.value,
                    child: HomeBannerCard(
                      key: _keyTopBanner,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Transform.translate(
                key: _keyBalanceCard,
                offset: _balanceCardAnimation.value,
                child: BalanceCard(
                  dragController: _dragController,
                  animationController: _detailPageEntryController,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                      child: Transform.translate(
                          key: _keyProfitCard,
                          offset: _profitCardAnimation.value,
                          child: const MonthlyStatCard())),
                  const SizedBox(width: 24),
                  Expanded(
                      child: Transform.translate(
                          offset: _profitCardRightAnimation.value,
                          child: const MonthlyStatCard())),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return Transform.translate(
      offset: _fabAnimation.value,
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        backgroundColor: Colors.blueGrey,
        key: _keyFAB,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onDragAnimChanged(AnimationStatus status) async {
    if (status == AnimationStatus.completed && !_dragController.isAnimating) {
      _navigateToDetailPage();
    }
  }

  void _initDragController() {
    _dragController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )
      ..addListener(() {
        if (_detailPageEntryController.isAnimating) return;

        _detailPageEntryController.value =
            (_dragController.value / 3.5).clamp(0.0, 1.0);
      })
      ..addStatusListener(_onDragAnimChanged);
  }

  void _initDetailPageEntryController() {
    _detailPageEntryController = AnimationController(
      vsync: this,
      duration: detailPageEntryDuration,
      reverseDuration: detailPageEntryDuration * 1.0,
    )
      ..addListener(() {
        setState(() {});
        if (_dragController.isAnimating) return;

        var value = _detailPageEntryController.value * 1.3;
        value = value.clamp(0.0, 1.0);
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {}
      });
  }

  void _navigateToDetailPage() async {
    _detailPageEntryController.forward();
    await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: detailPageEntryDuration * 1.0,
        reverseTransitionDuration: detailPageEntryDuration * 0.75,
        opaque: false,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
        pageBuilder: (context, animation, secondaryAnimation) =>
            CardDetailScreen(
          onBack: () async {
            Future.delayed(detailPageEntryDuration * 0.0,
                () => _detailPageEntryController.reverse());
            return true;
          },
        ),
      ),
    );
  }

  void _initEmptyAnimations() {
    _topHeaderAnimation =
        ConstantTween(Offset.zero).animate(_detailPageEntryController);
    _topBannerAnimation =
        ConstantTween(Offset.zero).animate(_detailPageEntryController);
    _balanceCardAnimation =
        ConstantTween(Offset.zero).animate(_detailPageEntryController);
    _profitCardAnimation =
        ConstantTween(Offset.zero).animate(_detailPageEntryController);
    _profitCardRightAnimation =
        ConstantTween(Offset.zero).animate(_detailPageEntryController);
    _fabAnimation =
        ConstantTween(Offset.zero).animate(_detailPageEntryController);
    _bottomBarAnimation =
        ConstantTween(Offset.zero).animate(_detailPageEntryController);
  }

  void _initAnimations() {
    try {
      Offset offset;

      final view = View.of(context);
      double screenWidth = view.physicalSize.width / view.devicePixelRatio;
      double screenHeight = view.physicalSize.height / view.devicePixelRatio;

      Size screenSize = Size(screenWidth, screenHeight);

      screenSize = (context.findRenderObject() as RenderBox).size;
      screenSize = MediaQuery.of(context).size;

      (offset, _) = getOffsetSizeFromKey(_keyTopHeader);

      _topHeaderAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, -screenSize.height + offset.dy),
      ).animate(_detailPageEntryController);

      (offset, _) = getOffsetSizeFromKey(_keyTopBanner);

      _topBannerAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, -screenSize.height + offset.dy),
      ).animate(CurvedAnimation(
        parent: _detailPageEntryController,
        curve: const Cubic(0.94, 0.38, 1.0, 0.85),
      ));

      (offset, _) = getOffsetSizeFromKey(_keyBalanceCard);
      _balanceCardAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, screenSize.height + offset.dy),
      ).animate(CurvedAnimation(
        parent: _detailPageEntryController,
        curve: const Cubic(0.94, 0.38, 1.0, 0.85),
      ));

      (offset, _) = getOffsetSizeFromKey(_keyProfitCard);
      _profitCardAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, screenSize.height + offset.dy),
      ).animate(_detailPageEntryController);

      _profitCardRightAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, screenSize.height + offset.dy),
      ).animate(CurvedAnimation(
        parent: _detailPageEntryController,
        curve: const Cubic(0.34, 0.80, 0.71, 0.92),
      ));

      (offset, _) = getOffsetSizeFromKey(_keyFAB);
      _fabAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, screenSize.height + offset.dy),
      ).animate(CurvedAnimation(
        parent: _detailPageEntryController,
        curve: const Cubic(0.42, 0.67, 0.79, 0.90),
      ));

      (offset, _) = getOffsetSizeFromKey(_keyBottomBar);
      _bottomBarAnimation = Tween<Offset>(
        begin: Offset.zero,
        end: Offset(0.0, screenSize.height + offset.dy),
      ).animate(CurvedAnimation(
        parent: _detailPageEntryController,
        curve: const Cubic(0.34, 0.80, 0.71, 0.92),
      ));
    } finally {}
  }
}

class _ThisHeaderWidget extends StatelessWidget {
  const _ThisHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Hi, Muhammed Sinan CP",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Dashboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Colors.white38,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person_rounded),
          ),
        ],
      ),
    );
  }
}
