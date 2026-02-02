import '../models/seven_day_challenge_model.dart';

final List<String> inactivityNudges = [
  "This doesn’t expire. We’ll continue when you’re ready.",
  "You’re still someone who cares about keeping promises.",
  "Whenever you’re ready, we’ll pick up where you left off.",

  "Unfinished promises tend to stay heavy. Naming them helps.",

  "You’ve already started something most people avoid.",

  "You didn’t fall behind. You just paused.",
  "People who take this seriously don’t rush it.",
  "One promise today is enough.",
  "The promise you didn’t write yet still matters.",
  "Stopping doesn’t feel better than continuing — just quieter.",

  "There’s no penalty for taking your time here.",
  "Consistency starts with clarity — not pressure.",
  "You don’t need a full hour. Two minutes counts.",
  "Avoidance isn’t failure. It’s information.",
  "Your future self benefits from one honest step today.",

  "This isn’t about doing it perfectly. Just honestly.",
  "You don’t lose progress here. You build it.",
  "The next step is waiting — not demanding.",
  "What you don’t name quietly controls you.",
  "When you’re ready, the reset continues.",
];
final Map<int, ChallengeDayContent> challengeContentMap = {
  1: const ChallengeDayContent(
    theme: "Romantic Partner",

    title: "Promises to\nRomantic Partner.",
    prompt:
        "What have you promised your partner? Not\njust with words, but with expectations?",
    body:
        "These don’t need to be dramatic.\n\nSmall, repeated promises shape trust\nmore than one off big ones.",
    examples: [
      "I’ll be more present at home",
      "I’ll follow through when I say I will",
      "I’ll stop saying ‘later’ when I mean ‘no’",
    ],
    bottomCopy:
        "Name what matters. You’re not fixing it\nyet. If you don’t have a partner, maybe\nmake a promise to find one.",
    ctaText: "Make a Partner Promise",
    notifMorning:
        "A promise to your partner doesn’t disappear when it’s broken. It waits.",
    notifAfternoon:
        "What does your partner expect from you, even if they stopped asking?",
    notifEvening: "One honest promise today is enough.",
  ),
  2: const ChallengeDayContent(
    theme: "Self Trust",

    title: "Promises to\nYourself.",
    prompt: "What promises do you keep postponing\nwith yourself?",
    body:
        "Breaking promises to yourself quietly\nteaches others how seriously to take\nyour word.",
    examples: [
      "Taking care of your body",
      "Resting without guilt",
      "Doing what you said you would, even\nwhen no one’s watching",
    ],
    bottomCopy:
        "These Promises count the most, even if\nno one else sees them.",
    ctaText: "Make Yourself a Promise",
    notifMorning:
        "The hardest promises to keep are the ones no one else enforces.",
    notifAfternoon: "What’s one promise you keep pushing to “next week”?",
    notifEvening: "Write it down. You don’t have to solve it tonight.",
  ),
  3: const ChallengeDayContent(
    theme: "Overcommitment Patterns",

    title: "Where You Quietly\nBreak Promises.",
    prompt:
        "What do you say yes to and quietly fail at\nlater? Do you do it to yourself?",
    body: "Over-promising isn’t kindness. It’s\nmisalignment.",
    examples: [
      "Being on time",
      "Showing up consistently",
      "Finishing what you start",
    ],
    bottomCopy: "Awareness comes before discipline.",
    ctaText: "Make a Silent Promise",
    notifMorning: "Every “yes” is a future obligation.",
    notifAfternoon: "Which yes today will cost you too much later?",
    notifEvening: "If it keeps breaking, it belongs here.",
  ),
  4: const ChallengeDayContent(
    theme: "Social Responsibility",

    title: "Promises That Affect\nOther People.",
    prompt: "Who is impacted when you don’t\nfollow through?",
    body: "This isn’t about guilt. It’s about\nresponsibility.",
    examples: [
      "Being emotionally available",
      "Showing up when you say you will",
      "Being dependable, not just well-intentioned",
    ],
    bottomCopy: "You don’t need to be perfect. Just honest.",
    ctaText: "Make a Promise to Someone",
    notifMorning:
        "Someone adjusts their expectations based on your follow-through.",
    notifAfternoon: "Who feels it when you don’t show up?",
    notifEvening: "Name it without judging yourself.",
  ),
  5: const ChallengeDayContent(
    theme: "Avoided Promises",

    title: "The Promise You’ve\nBeen Avoiding.",
    prompt:
        "What promise would change things —\nif you actually made it and kept it?",
    body: "Avoided promises often carry\nthe most weight.",
    examples: [],
    bottomCopy: "If it feels uncomfortable, you’re close.",
    ctaText: "Make Promise I’m Avoiding",
    notifMorning: "There’s a promise you already know you’re avoiding.",
    notifAfternoon: "You don’t have to keep it yet. Just name it.",
    notifEvening: "Avoidance is information.",
  ),
  6: const ChallengeDayContent(
    theme: "Promise Clarity",
    title: "Not Every Promise\nBelongs on the list.",
    prompt: "Which promises are too vague,\nduplicated, or unrealistic?",
    body: "Clarity reduces failure more\nthan motivation.",
    examples: ["Rewrite", "Merge", "Remove"],
    bottomCopy: "Fewer promises = Better promises.",
    ctaText: "Clean up Promise List",
    notifMorning: "Precision is a form of self-respect.",
    notifAfternoon: "Which promise needs to be rewritten to be real?",
    notifEvening: "Removing a promise is not quitting. It’s choosing.",
  ),
  7: const ChallengeDayContent(
    theme: "Future Intent",
    title: "You’ve Named What\nMatters.",
    prompt: null,
    body:
        "You’ve done something most people avoid —\nyou’ve looked directly at your word.",
    examples: [],
    bottomCopy: "Add any last minute Promises\nthat come to mind!",
    ctaText: "Make One More Promise",
    notifMorning: "Today isn’t about adding. It’s about seeing clearly.",
    notifAfternoon: "What you named this week matters.",
    notifEvening: "Get ready to, Stop Breaking Promises!",
  ),
};
