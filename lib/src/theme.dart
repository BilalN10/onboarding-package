import 'package:flutter/material.dart';
import 'package:ui_kosmos_v4/cta/theme.dart';

class OnboardingThemeData {
  /// Style du texte principal au centre
  final TextStyle? titleTextStyle;

  /// Style du texte secondaire au centre
  final TextStyle? subtitleTextStyle;

  /// Customisation du bouton pour passer à la page suivante
  final CtaThemeData? ctaNextButtonThemeData;

  /// Customisation du bouton pour passer à la page précédente
  final CtaThemeData? ctaBackgroundThemeData;

  /// Couleur du fond d'écran lorsque l'image est au centre
  final Color? backgroundClr;

  /// Couleur du texte du bouton pour passer l'onboarding
  final TextStyle? skipButtonStyle;

  /// Couleur des points indicateurs de pages
  final Color? dotsViewIndicatorClr;

  /// Couleur du point indicateur de la page active
  final Color? activeDotViewIndicatorClr;

  final Widget? logo;

  const OnboardingThemeData({
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.ctaNextButtonThemeData,
    this.ctaBackgroundThemeData,
    this.backgroundClr,
    this.skipButtonStyle,
    this.dotsViewIndicatorClr,
    this.activeDotViewIndicatorClr,
    this.logo,
  });
}
