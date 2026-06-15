import 'package:flutter/material.dart';
import '../app.dart';

class SettingsBottomSheet extends StatefulWidget {
  const SettingsBottomSheet({
    super.key,
    required this.initialAccentColor,
    required this.initialThemeMode,
    required this.onAccentColorChanged,
    required this.onThemeModeChanged,
  });

  final Color initialAccentColor;
  final ThemeMode initialThemeMode;
  final ValueChanged<Color> onAccentColorChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  @override
  State<SettingsBottomSheet> createState() => _SettingsBottomSheetState();
}

class _SettingsBottomSheetState extends State<SettingsBottomSheet> {
  late Color _accentColor;
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _accentColor = widget.initialAccentColor;
    _themeMode = widget.initialThemeMode;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _themeMode == ThemeMode.dark;
    final theme = isDark ? MainTheme.dark(_accentColor) : MainTheme.light(_accentColor);

    return Theme(
      data: theme,
      child: Builder(
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.d24.responsive()),
                topRight: Radius.circular(Dimens.d24.responsive()),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            padding: EdgeInsets.all(Dimens.d24.responsive()),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cài đặt giao diện',
                      style: TextStyle(
                        fontSize: 20.0.responsive(),
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ],
                ),
                SizedBox(height: Dimens.d20.responsive()),
                Text(
                  'Màu chủ đạo',
                  style: TextStyle(
                    fontSize: 16.0.responsive(),
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                SizedBox(height: Dimens.d12.responsive()),
                Row(
                  children: [
                    SettingsColorOption(
                      color: const Color(0xFF2E7D32),
                      label: 'Green',
                      isSelected: _accentColor == const Color(0xFF2E7D32),
                      isDark: isDark,
                      onTap: () {
                        setState(() {
                          _accentColor = const Color(0xFF2E7D32);
                        });
                        widget.onAccentColorChanged(_accentColor);
                      },
                    ),
                    SizedBox(width: Dimens.d16.responsive()),
                    SettingsColorOption(
                      color: const Color(0xFFD81B60),
                      label: 'Pink',
                      isSelected: _accentColor == const Color(0xFFD81B60),
                      isDark: isDark,
                      onTap: () {
                        setState(() {
                          _accentColor = const Color(0xFFD81B60);
                        });
                        widget.onAccentColorChanged(_accentColor);
                      },
                    ),
                    SizedBox(width: Dimens.d16.responsive()),
                    SettingsColorOption(
                      color: const Color(0xFFE65100),
                      label: 'Orange',
                      isSelected: _accentColor == const Color(0xFFE65100),
                      isDark: isDark,
                      onTap: () {
                        setState(() {
                          _accentColor = const Color(0xFFE65100);
                        });
                        widget.onAccentColorChanged(_accentColor);
                      },
                    ),
                  ],
                ),
                SizedBox(height: Dimens.d24.responsive()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chế độ tối',
                      style: TextStyle(
                        fontSize: 16.0.responsive(),
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isDark ? Icons.wb_sunny : Icons.nightlight_round,
                        color: isDark ? Colors.amber : Colors.blueGrey,
                      ),
                      onPressed: () {
                        setState(() {
                          _themeMode = isDark ? ThemeMode.light : ThemeMode.dark;
                        });
                        widget.onThemeModeChanged(_themeMode);
                      },
                    ),
                  ],
                ),
                SizedBox(height: Dimens.d12.responsive()),
              ],
            ),
          );
        }
      ),
    );
  }
}

class SettingsColorOption extends StatelessWidget {
  const SettingsColorOption({
    super.key,
    required this.color,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50.0.responsive(),
            height: 50.0.responsive(),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(Dimens.d12.responsive()),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: 3,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : [
                      const BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
            ),
            child: isSelected
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : null,
          ),
          SizedBox(height: Dimens.d6.responsive()),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0.responsive(),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isDark ? Colors.white : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
