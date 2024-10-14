import 'package:core_kosmos/core_package.dart';
import 'package:flutter/material.dart';
import 'package:onboarding_kosmos/src/model/onboarding_model.dart';
import 'package:onboarding_kosmos/src/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ui_kosmos_v4/cta/theme.dart';
import 'package:ui_kosmos_v4/ui_kosmos_v4.dart';

enum OnboardingType {
  center,
  fullscreen,
}

/// Widget de l'onboarding
class OnboardingWidget extends StatefulWidget {
  /// Liste des pages
  /// @Required
  final List<OnboardingModel> pages;

  /// Type d'onboarding [OnboardingType],
  /// @Default: [OnboardingType.center]
  final OnboardingType type;

  /// Revenir en arrière ou non,
  /// @Default: false
  final bool canGoBack;

  /// Fonction de construction de page avec image de fond en plein écran
  ///
  /// [BuildContext] context
  /// [int] index: page actuel
  ///
  final Widget Function(BuildContext context, int index)? fullscreenBackgroundBuilder;

  /// Fonction de la page suivant l'onboarding
  ///
  /// [BuildContext] context
  ///
  final Function(BuildContext)? finalCallback;

  final Function(BuildContext)? onTapLater;

  /// ThemeData de l'onboarding
  final OnboardingThemeData? theme;

  final TextStyle? titleTextStyle;
  final TextStyle? subtitleTextStyle;
  final CtaThemeData? ctaNextButtonThemeData;
  final CtaThemeData? ctaBackgroundThemeData;
  final Color? backgroundClr;
  final TextStyle? skipButtonStyle;
  final Color? dotsViewIndicatorClr;
  final Color? activeDotViewIndicatorClr;

  /// Nom du thème
  final String? themeName;

  const OnboardingWidget(
      {Key? key,
      required this.pages,
      this.type = OnboardingType.center,
      this.canGoBack = false,
      this.fullscreenBackgroundBuilder,
      this.finalCallback,
      this.onTapLater,
      this.theme,
      this.titleTextStyle,
      this.subtitleTextStyle,
      this.ctaNextButtonThemeData,
      this.ctaBackgroundThemeData,
      this.backgroundClr,
      this.skipButtonStyle,
      this.dotsViewIndicatorClr,
      this.activeDotViewIndicatorClr,
      this.themeName})
      : super(key: key);

  @override
  State<OnboardingWidget> createState() => _OnboardingWidgetState();
}

class _OnboardingWidgetState extends State<OnboardingWidget> {
  late final OnboardingThemeData theme;

  final PageController _pageController = PageController(initialPage: 0);
  int index = 0;

  @override
  initState() {
    theme = loadThemeData(widget.theme, widget.themeName ?? "onboarding", () => const OnboardingThemeData())!;
    super.initState();
  }

  @override
  dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Fonction envoyant à la page suivante
  void jumpToNext() => _pageController.nextPage(duration: const Duration(milliseconds: 180), curve: Curves.easeIn);

  /// Fonction envoyant à la page précédente
  void jumpToPrev() => _pageController.previousPage(duration: const Duration(milliseconds: 180), curve: Curves.easeIn);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (widget.type == OnboardingType.fullscreen && widget.fullscreenBackgroundBuilder != null)
            ? widget.fullscreenBackgroundBuilder!(context, index)
            : SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: widget.backgroundClr ?? theme.backgroundClr ?? Colors.transparent),
                )),
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: (widget.canGoBack && index > 0)
                          ? Padding(
                              padding: EdgeInsets.only(left: formatWidth(10)),
                              child: CTA.back(
                                onTap: index > 0 ? jumpToPrev : () => Navigator.pop(context),
                                theme: widget.ctaBackgroundThemeData ?? theme.ctaBackgroundThemeData,
                              ),
                            )
                          : SizedBox(height: formatHeight(50)),
                    ),
                  ),
                  Expanded(flex: 2, child: Align(alignment: Alignment.center, child: theme.logo ?? const SizedBox())),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: (widget.pages[index].skipButtonText != null)
                          ? Padding(
                              padding: EdgeInsets.only(right: formatWidth(23)),
                              child: InkWell(
                                onTap: () {
                                  if (widget.onTapLater != null) {
                                    widget.onTapLater!(context);
                                  }
                                },
                                child: Text(
                                  widget.pages[index].skipButtonText!,
                                  style: widget.skipButtonStyle ?? theme.skipButtonStyle,
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (currentPage) {
                    setState(() {
                      index = currentPage;
                    });
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  children: widget.pages.map((page) {
                    return _buildPage(page);
                  }).toList(),
                ),
              ),
              AnimatedSmoothIndicator(
                activeIndex: index,
                count: widget.pages.length,
                effect: WormEffect(
                  type: WormType.thin,
                  dotWidth: formatWidth(7.5),
                  dotHeight: formatWidth(7.5),
                  dotColor: widget.dotsViewIndicatorClr ?? theme.dotsViewIndicatorClr ?? Colors.grey,
                  activeDotColor: widget.activeDotViewIndicatorClr ?? theme.activeDotViewIndicatorClr ?? Colors.white,
                ),
              ),
              sh(15),
              CTA.primary(
                width: formatWidth(152),
                height: formatHeight(54),
                radius: formatWidth(15),
                textButton: widget.pages[index].nextButtonText ?? "Next",
                onTap: () {
                  if (index + 1 < widget.pages.length) {
                    jumpToNext();
                    if (widget.pages[index].callback != null) widget.pages[index].callback!;
                  } else if (index == widget.pages.length - 1) {
                    if (widget.pages[index].callback != null)
                      widget.pages[index].callback!();
                    else if (widget.finalCallback != null)
                      widget.finalCallback!(context);
                    else if (widget.onTapLater != null) widget.onTapLater!(context);
                  }
                },
                theme: widget.ctaNextButtonThemeData ?? theme.ctaNextButtonThemeData,
              ),
              sh(40)
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPage(OnboardingModel page) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: formatWidth(49)),
      child: Column(
        mainAxisAlignment: widget.type == OnboardingType.fullscreen ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          if (widget.type == OnboardingType.center)
            Column(
              children: [
                sh(40),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: formatHeight(300),
                    width: formatWidth(300),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: page.urlpath != null ? Image.network(page.urlpath!, fit: BoxFit.cover) : page.imageChild!,
                    ),
                  ),
                ),
                sh(20),
              ],
            ),
          Padding(
            padding: EdgeInsets.all(formatWidth(8)),
            child: SizedBox(
                width: formatWidth(272),
                child: page.title != null
                    ? Text(page.title!,
                        textAlign: TextAlign.center,
                        style: widget.titleTextStyle ?? theme.titleTextStyle ?? TextStyle(color: Colors.black, fontSize: sp(24), fontWeight: FontWeight.w700))
                    : page.titleChild!),
          ),
          SizedBox(
            width: formatWidth(272),
            child: Text(
              page.subtitle!,
              textAlign: TextAlign.center,
              style: widget.subtitleTextStyle ?? theme.subtitleTextStyle ?? TextStyle(color: Colors.black, fontSize: sp(13), fontWeight: FontWeight.w400),
            ),
          ),
        ],
      ),
    );
  }
}
