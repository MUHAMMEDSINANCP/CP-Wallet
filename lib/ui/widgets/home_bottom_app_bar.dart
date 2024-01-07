import 'package:flutter/material.dart';

class HomeBottomAppBar extends StatefulWidget {
  const HomeBottomAppBar({
    super.key,
  });

  @override
  State<HomeBottomAppBar> createState() => _HomeBottomAppBarState();
}

class _HomeBottomAppBarState extends State<HomeBottomAppBar> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ThisItemWidget(
            iconData: Icons.dashboard_rounded,
            label: "Dashboard",
            isSelected: _selectedIndex == 0,
            onTap: () {
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          _ThisItemWidget(
            iconData: Icons.stacked_line_chart_rounded,
            label: "Portfolio",
            isSelected: _selectedIndex == 1,
            onTap: () {
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          const SizedBox(width: 32),
          _ThisItemWidget(
            iconData: Icons.signal_cellular_alt_rounded,
            label: "Prices",
            isSelected: _selectedIndex == 2,
            onTap: () {
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          _ThisItemWidget(
            iconData: Icons.notifications_active_rounded,
            label: "Notifications",
            isSelected: _selectedIndex == 3,
            onTap: () {
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),
        ],
      ),
    );
  }
}

class _ThisItemWidget extends StatelessWidget {
  final String label;
  final IconData iconData;
  final bool isSelected;
  final VoidCallback? onTap;
  const _ThisItemWidget({
    required this.iconData,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  double get _getOpacity => isSelected ? 1 : 0.5;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 3),
        opacity: _getOpacity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData),
            const SizedBox(height: 7),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
