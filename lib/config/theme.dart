import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

/// ===========================================================================
/// theme.dart — the SINGLE source of truth for BudgetBuddy's design system.
///
/// Everything visual (colour, typography, component styling, dark mode) is
/// defined here. Editing this file re-skins the entire app; no widget should
/// declare its own colours or hardcode a hex value.
///
/// HOW TO USE IT IN A WIDGET
/// -------------------------
/// ```dart
/// final c = context.colors;                 // semantic, theme-aware palette
/// Container(color: c.background, ...)
/// Text('Hi', style: AppTextStyles.title.copyWith(color: c.onBanner));
/// ```
/// `context.colors` resolves to the LIGHT or DARK value automatically based on
/// the active [ThemeMode], so toggling dark mode repaints the whole app.
///
/// ADDING / CHANGING A COLOUR
/// --------------------------
/// 1. Add the raw value ONCE to [AppPalette] (the normalized hex registry).
/// 2. Expose it as a semantic role on [AppColors], giving it BOTH a light and a
///    dark value in [AppColors.light] / [AppColors.dark].
/// 3. Consume it through `context.colors.<role>` — never reference the raw hex.
///
/// Most widgets (AppBar, Card, Dialog, inputs, buttons, navigation, chips …)
/// are already themed centrally in [AppTheme]; prefer omitting per-widget
/// colour overrides so the theme stays in control.
/// ===========================================================================

/// ---------------------------------------------------------------------------
/// AppPalette — the normalized raw colour registry.
///
/// Each distinct hex value used anywhere in the app lives here exactly once.
/// These are the *ingredients*; [AppColors] maps them onto semantic roles for
/// the light and dark themes. Nothing outside this file should reference these
/// constants directly — go through `context.colors` instead.
/// ---------------------------------------------------------------------------
class AppPalette {
  AppPalette._();

  // Neutrals
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  // Brand greens
  static const Color moss = Color(0xFF637D65); // primary (light)
  static const Color sage = Color(0xFF8FAF8A); // primary (dark) / secondary
  static const Color pine = Color(0xFF3A493B); // banner (light)
  static const Color pineDark = Color(0xFF2E4034); // banner (dark)
  static const Color forest = Color(0xFF26352B); // deepest green / text (light)
  static const Color deepPine = Color(0xFF35463A); // secondary text (light)
  static const Color mint = Color(0xFFB8D5AE); // cards / muted light text

  // Creams (light surfaces)
  static const Color cream = Color(0xFFE0D5BD); // background (light)
  static const Color warmCream = Color(0xFFF3DCAA); // surface / accent (light)
  static const Color sand = Color(0xFFD7D4B7); // surface variant (light)

  // Dark surfaces
  static const Color ink = Color(0xFF18211C); // background (dark)
  static const Color charcoal = Color(0xFF22302A); // card / input fill (dark)
  static const Color slate = Color(0xFF33453A); // surface variant (dark)
  static const Color shadow = Color(0xFF292828);

  // Disabled / muted
  static const Color disabledLight = Color(0xFF93A094);
  static const Color disabledDark = Color(0xFF6E7C6F);

  // Status & money
  static const Color error = Color(0xFFFB372E);
  static const Color errorDark = Color(0xFFFF6F61);
  static const Color success = Color(0xFF21CC21);
  static const Color income = Color(0xFF82B58A);
  static const Color expense = Color(0xFFD98289);

  // Category accents (charts / chips)
  static const Color catYellow = Color(0xFFE6C779);
  static const Color catPurple = Color(0xFFB9A2E8);
  static const Color catBlue = Color(0xFF88B9E0);

  // Hairlines (pre-composed alpha so they can stay const)
  static const Color dividerLight = Color(0x1F26352B); // forest @ ~12%
  static const Color dividerDark = Color(0x1FE0D5BD); // cream @ ~12%
  static const Color borderLight = Color(0x2626352B); // forest @ ~15%
  static const Color borderDark = Color(0x26E0D5BD); // cream @ ~15%
}

/// ---------------------------------------------------------------------------
/// AppColors — the semantic, theme-aware colour roles.
///
/// This is a [ThemeExtension], registered on both [AppTheme.light] and
/// [AppTheme.dark]. Widgets read it with `context.colors.<role>`; the correct
/// light/dark value is supplied automatically and animates on theme change.
/// ---------------------------------------------------------------------------
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceVariant,
    required this.card,
    required this.banner,
    required this.inputFill,
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.onBanner,
    required this.onBannerMuted,
    required this.onPrimary,
    required this.onAccent,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.error,
    required this.onError,
    required this.success,
    required this.income,
    required this.expense,
    required this.divider,
    required this.border,
    required this.shadow,
    required this.disabled,
    required this.chartPalette,
  });

  // Surfaces
  /// Base scaffold / page background.
  final Color background;

  /// Elevated panels: dialogs, bottom sheets, popovers.
  final Color surface;

  /// Secondary panels: dropdown menus, segmented backgrounds.
  final Color surfaceVariant;

  /// Content cards: budget cards, expense tiles, chips.
  final Color card;

  /// Branded dark-green header surfaces: app bar, nav bar, hero panels.
  final Color banner;

  /// Text-field fill.
  final Color inputFill;

  // Text & icons
  /// Primary foreground on [background] / [surface] / [card].
  final Color textPrimary;

  /// Secondary / caption foreground.
  final Color textSecondary;

  /// Disabled foreground.
  final Color textDisabled;

  /// Foreground placed on a [banner].
  final Color onBanner;

  /// Muted foreground placed on a [banner].
  final Color onBannerMuted;

  /// Foreground placed on a [primary] control.
  final Color onPrimary;

  /// Foreground placed on an [accent] / money surface (dark in both modes).
  final Color onAccent;

  // Brand
  final Color primary;
  final Color secondary;
  final Color accent;

  // Status & money
  final Color error;
  final Color onError;
  final Color success;
  final Color income;
  final Color expense;

  // Detail
  final Color divider;
  final Color border;
  final Color shadow;
  final Color disabled;

  /// Ordered palette for charts (pie / bars / legend dots).
  final List<Color> chartPalette;

  // -- Light & dark instances ------------------------------------------------
  static const AppColors light = AppColors(
    background: AppPalette.cream,
    surface: AppPalette.warmCream,
    surfaceVariant: AppPalette.sand,
    card: AppPalette.mint,
    banner: AppPalette.pine,
    inputFill: AppPalette.white,
    textPrimary: AppPalette.forest,
    textSecondary: AppPalette.deepPine,
    textDisabled: AppPalette.disabledLight,
    onBanner: AppPalette.cream,
    onBannerMuted: AppPalette.mint,
    onPrimary: AppPalette.white,
    onAccent: AppPalette.forest,
    primary: AppPalette.moss,
    secondary: AppPalette.sage,
    accent: AppPalette.warmCream,
    error: AppPalette.error,
    onError: AppPalette.white,
    success: AppPalette.success,
    income: AppPalette.income,
    expense: AppPalette.expense,
    divider: AppPalette.dividerLight,
    border: AppPalette.borderLight,
    shadow: AppPalette.shadow,
    disabled: AppPalette.disabledLight,
    chartPalette: <Color>[
      AppPalette.moss,
      AppPalette.mint,
      AppPalette.expense,
      AppPalette.warmCream,
      AppPalette.forest,
      AppPalette.catBlue,
      AppPalette.catPurple,
      AppPalette.catYellow,
    ],
  );

  static const AppColors dark = AppColors(
    background: AppPalette.ink,
    surface: AppPalette.forest,
    surfaceVariant: AppPalette.slate,
    card: AppPalette.charcoal,
    banner: AppPalette.pineDark,
    inputFill: AppPalette.charcoal,
    textPrimary: AppPalette.cream,
    textSecondary: AppPalette.mint,
    textDisabled: AppPalette.disabledDark,
    onBanner: AppPalette.cream,
    onBannerMuted: AppPalette.mint,
    onPrimary: AppPalette.ink,
    onAccent: AppPalette.forest,
    primary: AppPalette.sage,
    secondary: AppPalette.moss,
    accent: AppPalette.warmCream,
    error: AppPalette.errorDark,
    onError: AppPalette.ink,
    success: AppPalette.success,
    income: AppPalette.income,
    expense: AppPalette.expense,
    divider: AppPalette.dividerDark,
    border: AppPalette.borderDark,
    shadow: AppPalette.black,
    disabled: AppPalette.disabledDark,
    chartPalette: <Color>[
      AppPalette.sage,
      AppPalette.mint,
      AppPalette.expense,
      AppPalette.warmCream,
      AppPalette.pine,
      AppPalette.catBlue,
      AppPalette.catPurple,
      AppPalette.catYellow,
    ],
  );

  /// Look up the active [AppColors] from the nearest [Theme].
  static AppColors of(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.extension<AppColors>();
    assert(
      colors != null,
      'AppColors is not registered on the current ThemeData. Use AppTheme.light/dark.',
    );
    return colors ??
        (theme.brightness == Brightness.dark ? AppColors.dark : AppColors.light);
  }

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceVariant,
    Color? card,
    Color? banner,
    Color? inputFill,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? onBanner,
    Color? onBannerMuted,
    Color? onPrimary,
    Color? onAccent,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? error,
    Color? onError,
    Color? success,
    Color? income,
    Color? expense,
    Color? divider,
    Color? border,
    Color? shadow,
    Color? disabled,
    List<Color>? chartPalette,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      card: card ?? this.card,
      banner: banner ?? this.banner,
      inputFill: inputFill ?? this.inputFill,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      onBanner: onBanner ?? this.onBanner,
      onBannerMuted: onBannerMuted ?? this.onBannerMuted,
      onPrimary: onPrimary ?? this.onPrimary,
      onAccent: onAccent ?? this.onAccent,
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      shadow: shadow ?? this.shadow,
      disabled: disabled ?? this.disabled,
      chartPalette: chartPalette ?? this.chartPalette,
    );
  }

  @override
  AppColors lerp(covariant AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      card: Color.lerp(card, other.card, t)!,
      banner: Color.lerp(banner, other.banner, t)!,
      inputFill: Color.lerp(inputFill, other.inputFill, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      onBanner: Color.lerp(onBanner, other.onBanner, t)!,
      onBannerMuted: Color.lerp(onBannerMuted, other.onBannerMuted, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      success: Color.lerp(success, other.success, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      chartPalette: _lerpPalette(chartPalette, other.chartPalette, t),
    );
  }

  static List<Color> _lerpPalette(List<Color> a, List<Color> b, double t) {
    if (a.length != b.length) return t < 0.5 ? a : b;
    return <Color>[
      for (int i = 0; i < a.length; i++) Color.lerp(a[i], b[i], t)!,
    ];
  }
}

/// Convenience accessors so widgets can write `context.colors.background`.
extension AppThemeContextX on BuildContext {
  /// The active [ThemeData].
  ThemeData get theme => Theme.of(this);

  /// The active semantic colour roles (light or dark).
  AppColors get colors => AppColors.of(this);

  /// The active themed [TextTheme] (DM Sans, correctly coloured).
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Whether the active theme is dark.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}

/// ---------------------------------------------------------------------------
/// AppTextStyles — colourless typographic presets (DM Sans).
///
/// Colours are intentionally NOT baked in so the same style works in light and
/// dark mode. Tint with a semantic colour when needed, e.g.
/// `AppTextStyles.title.copyWith(color: context.colors.onBanner)`.
/// For most cases prefer the themed [TextTheme] (`context.textTheme`).
/// ---------------------------------------------------------------------------
class AppTextStyles {
  AppTextStyles._();

  static final TextStyle header = GoogleFonts.dmSans(
    fontSize: kHeaderSize,
    fontWeight: FontWeight.w700,
  );

  static final TextStyle subHeader = GoogleFonts.dmSans(
    fontSize: kSubHeaderSize,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle title = GoogleFonts.dmSans(
    fontSize: kTitleSize,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle body = GoogleFonts.dmSans(
    fontSize: kTextSize,
    fontWeight: FontWeight.w400,
  );

  /// Alias of [body], kept for the budget/expense features.
  static final TextStyle text = GoogleFonts.dmSans(
    fontSize: kTextSize,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle chart = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );

  /// Alias of [chart].
  static final TextStyle chartTextStyle = chart;

  static final TextStyle button = GoogleFonts.dmSans(
    fontSize: kTitleSize,
    fontWeight: FontWeight.w600,
  );
}

/// ---------------------------------------------------------------------------
/// AppTheme — builds the light and dark [ThemeData], wiring the [AppColors]
/// extension and every component theme. [light] is the default; [dark] is
/// toggled from the drawer via ThemeController.
/// ---------------------------------------------------------------------------
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light, AppColors.light);
  static ThemeData get dark => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors c) {
    final bool isDark = brightness == Brightness.dark;

    final ColorScheme scheme =
        (isDark ? const ColorScheme.dark() : const ColorScheme.light()).copyWith(
      primary: c.primary,
      onPrimary: c.onPrimary,
      secondary: c.secondary,
      onSecondary: c.onPrimary,
      tertiary: c.accent,
      onTertiary: c.onAccent,
      error: c.error,
      onError: c.onError,
      surface: c.background,
      onSurface: c.textPrimary,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerHighest: c.surface,
      outline: c.border,
      outlineVariant: c.divider,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[c],
      scaffoldBackgroundColor: c.background,
      dividerColor: c.divider,
      textTheme: _textTheme(c),
      iconTheme: IconThemeData(color: c.textPrimary),
      primaryIconTheme: IconThemeData(color: c.onBanner),
      appBarTheme: AppBarThemeData(
        backgroundColor: c.banner,
        foregroundColor: c.onBanner,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        shadowColor: c.shadow,
        iconTheme: IconThemeData(color: c.onBanner),
        titleTextStyle: AppTextStyles.subHeader.copyWith(color: c.onBanner),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: c.background,
        elevation: 2,
        scrimColor: c.shadow.withValues(alpha: 0.4),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
      ),
      cardTheme: CardThemeData(
        color: c.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultRadius),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: AppTextStyles.subHeader.copyWith(color: c.textPrimary),
        contentTextStyle: AppTextStyles.body.copyWith(color: c.textSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        modalBackgroundColor: c.surface,
        elevation: 4,
        showDragHandle: true,
        dragHandleColor: c.textSecondary,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      inputDecorationTheme: _inputTheme(c),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.primary,
          foregroundColor: c.onPrimary,
          disabledBackgroundColor: c.primary.withValues(alpha: 0.45),
          disabledForegroundColor: c.onPrimary.withValues(alpha: 0.85),
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.primary,
          elevation: 0,
          minimumSize: const Size.fromHeight(52),
          side: BorderSide(color: c.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultRadius),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          textStyle: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.banner,
        foregroundColor: c.onBanner,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kDefaultRadius),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.banner,
        selectedItemColor: c.accent,
        unselectedItemColor: c.onBannerMuted,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.card,
        selectedColor: c.primary,
        disabledColor: c.disabled,
        surfaceTintColor: Colors.transparent,
        labelStyle: AppTextStyles.body.copyWith(
          color: c.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: AppTextStyles.body.copyWith(color: c.onPrimary),
        side: BorderSide.none,
        showCheckmark: false,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: c.textPrimary,
        textColor: c.textPrimary,
        titleTextStyle: AppTextStyles.title.copyWith(
          color: c.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        subtitleTextStyle: AppTextStyles.body.copyWith(color: c.textSecondary),
      ),
      dividerTheme: DividerThemeData(color: c.divider, thickness: 1, space: 1),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.border,
        circularTrackColor: c.border,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.banner,
        contentTextStyle: AppTextStyles.body.copyWith(color: c.onBanner),
        actionTextColor: c.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: c.surface,
        headerBackgroundColor: c.banner,
        headerForegroundColor: c.onBanner,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  /// DM Sans [TextTheme] tinted with the semantic foreground colours.
  static TextTheme _textTheme(AppColors c) {
    final TextTheme base = GoogleFonts.dmSansTextTheme().apply(
      bodyColor: c.textPrimary,
      displayColor: c.textPrimary,
    );
    return base.copyWith(
      displayLarge: AppTextStyles.header.copyWith(color: c.textPrimary),
      displayMedium: AppTextStyles.header.copyWith(color: c.textPrimary),
      headlineLarge: AppTextStyles.header.copyWith(color: c.textPrimary),
      headlineMedium: AppTextStyles.subHeader.copyWith(color: c.textPrimary),
      headlineSmall: AppTextStyles.subHeader.copyWith(color: c.textPrimary),
      titleLarge: AppTextStyles.title.copyWith(color: c.textPrimary),
      titleMedium: AppTextStyles.title.copyWith(
        color: c.textPrimary,
        fontSize: kTitleSize - 2,
      ),
      titleSmall: AppTextStyles.body.copyWith(
        color: c.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: AppTextStyles.title.copyWith(color: c.textPrimary),
      bodyMedium: AppTextStyles.body.copyWith(color: c.textPrimary),
      bodySmall: AppTextStyles.body.copyWith(color: c.textSecondary, fontSize: 12),
      labelLarge: AppTextStyles.button.copyWith(color: c.onPrimary),
      labelMedium: AppTextStyles.body.copyWith(
        color: c.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: AppTextStyles.body.copyWith(color: c.textSecondary, fontSize: 11),
    );
  }

  /// Shared input decoration used across auth, budget and expense forms.
  static InputDecorationThemeData _inputTheme(AppColors c) {
    OutlineInputBorder border(Color color, [double width = 1.0]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(kDefaultRadius),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationThemeData(
      filled: true,
      fillColor: c.inputFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      hintStyle: AppTextStyles.body.copyWith(color: c.textSecondary),
      labelStyle: AppTextStyles.body.copyWith(color: c.textSecondary),
      floatingLabelStyle: AppTextStyles.body.copyWith(
        color: c.primary,
        fontWeight: FontWeight.w600,
      ),
      errorStyle: AppTextStyles.body.copyWith(color: c.error, fontSize: 12),
      prefixIconColor: c.primary,
      suffixIconColor: c.textSecondary,
      iconColor: c.textSecondary,
      border: border(c.border),
      enabledBorder: border(c.border),
      focusedBorder: border(c.primary, 1.5),
      errorBorder: border(c.error),
      focusedErrorBorder: border(c.error, 1.5),
      disabledBorder: border(c.border),
    );
  }
}
