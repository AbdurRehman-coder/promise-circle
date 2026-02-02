class SelectOption {
  final String label;
  final String icon;
  final String? nameHint;
  final bool optional;
  final bool needsCustomValue;


  const SelectOption({
    required this.label,
    required this.icon,
    this.nameHint,
    this.optional = false,
    this.needsCustomValue = false,
  });
}