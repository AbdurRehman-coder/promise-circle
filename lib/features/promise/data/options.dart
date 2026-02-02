import 'package:sbp_app/features/promise/models/option_model.dart';

final whoOptions = [
  "Me",
  "My Friends",
  "My Partner",
  "My Business",
  "My Kids",
  "My Parents",
  "My Clients",
  "My Family",
  "Others",
];

final whoSelectOptions = [
  SelectOption(label: whoOptions[0], icon: '🧍‍♂️'),

  SelectOption(
    label: whoOptions[1],
    icon: '🧑‍🤝‍🧑',
    nameHint: 'Another reason...',
    optional: true,
  ),

  SelectOption(
    label: whoOptions[2],
    icon: "❤️",
    nameHint: 'Another reason...',
    optional: true,
  ),

  SelectOption(
    label: whoOptions[3],
    icon: '💼',
    nameHint: 'Another reason...',
    optional: true,
  ),

  SelectOption(
    label: whoOptions[4],
    icon: '👶',
    nameHint: 'Another reason...',
    optional: true,
  ),
  SelectOption(
    label: whoOptions[5],
    icon: '👵',
    nameHint: 'Another reason...',
    optional: true,
  ),

  SelectOption(
    label: whoOptions[6],
    icon: '🤝',
    nameHint: 'Another reason...',
    optional: true,
  ),

  SelectOption(
    label: whoOptions[7],
    icon: '👨‍👩‍👧‍👦',
    nameHint: 'Another reason...',
    optional: true,
  ),

  SelectOption(
    label: whoOptions[8],
    icon: '✨',
    nameHint: 'Specify...',
    optional: true,
  ),
];

final feelOptions = [
  'Proud',
  'Free',
  'Confident',
  'Calm',
  'Grateful',
  'Empowered',
  'Inspired',
  'Fulfilled',
  'Other',
  'Loved',
  'Appreciated',
];

// 2. List of SelectOption objects referencing labels from feelOptions list
// Note: 'const' must be removed from the list and elements because array access (feelOptions[i])
// is not a compile-time constant.
final feelSelectOptions = [
  SelectOption(label: feelOptions[0], icon: '🏅'),
  SelectOption(label: feelOptions[1], icon: '🕊️'),
  SelectOption(label: feelOptions[2], icon: '💪'),
  SelectOption(label: feelOptions[3], icon: '🌿'),
  SelectOption(label: feelOptions[4], icon: '🙏'),
  SelectOption(label: feelOptions[5], icon: '⚡'),
  SelectOption(label: feelOptions[6], icon: '️️💡'),
  SelectOption(label: feelOptions[7], icon: '🤲'),

  SelectOption(label: feelOptions[8], icon: '💭', needsCustomValue: true),
  SelectOption(label: feelOptions[9], icon: "❤️"),
  SelectOption(label: feelOptions[10], icon: '🫂'),
];
