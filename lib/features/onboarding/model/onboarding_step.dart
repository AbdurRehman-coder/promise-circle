class OnboardingStep {
  final String question;
  final String description;
  final int maxSelection;
  final int? minSelection;
  final bool isGrid;
  final List<OptionItem> options;

  OnboardingStep({
    required this.question,
    required this.description,
    required this.maxSelection,
    required this.isGrid,
    required this.options,
    this.minSelection
  });
}

class OptionItem {
  final String icon;
  final String title;

  final String? intent;
  final List<String>? microtags;

  OptionItem({
    required this.icon,
    required this.title,
    this.intent,
    this.microtags,
  });

  Object toApiJson() {
    if (intent != null) {
      return {"intent": intent!, "microtags": microtags ?? []};
    } else {
      return title;
    }
  }
}
