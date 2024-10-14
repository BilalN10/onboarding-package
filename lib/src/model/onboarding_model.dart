import 'package:flutter/material.dart';

class OnboardingModel {
  /// Widget à la place de l'image
  final Widget? imageChild;

  /// URL (lien) d'une image
  final String? urlpath;

  /// Widget à la place du titre
  final Widget? titleChild;

  /// Texte
  final String? title;

  /// Sous-texte
  final String? subtitle;

  /// Texte du bouton pour passer l'onboarding
  final String? skipButtonText;

  /// Texte du bouton pour passer à la page suivante
  final String? nextButtonText;

  /// Action supplémentaire lors du passage a la page suivante
  final VoidCallback? callback;

  const OnboardingModel({this.imageChild, this.urlpath, this.titleChild, this.title, this.subtitle, this.skipButtonText, this.nextButtonText, this.callback});
}
