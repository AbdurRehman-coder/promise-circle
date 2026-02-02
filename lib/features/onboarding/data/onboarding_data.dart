import 'package:sbp_app/features/onboarding/model/onboarding_step.dart';

List<OnboardingStep> onBoardingSteps = [
  OnboardingStep(
    question: "Where do you want to stop breaking promises most in life?",
    description: "Choose up to 3 areas",
    maxSelection: 3,

    isGrid: true,
    options: [
      OptionItem(
        icon: '🚀',
        title: 'Ambitions &\nPurpose',
        intent: 'purpose',
        microtags: ['Projects', 'Direction', 'Motivation', 'Consistency'],
      ),
      OptionItem(
        icon: '🏋️‍♂️',
        title: 'Health &\nFitness',
        intent: 'health',
        microtags: ['Exercise', 'Nutrition', 'Sleep', 'Recovery'],
      ),
      OptionItem(
        icon: '💰',
        title: 'Money &\nFinances',
        intent: 'finance',
        microtags: ['Budgeting', 'Saving', 'Investing', 'Spending'],
      ),
      OptionItem(
        icon: '🎯',
        title: 'Focus &\nProductivity',
        intent: 'focus',
        microtags: ['Time', 'Distraction', 'Completion', 'Discipline'],
      ),
      OptionItem(
        icon: '💞',
        title: 'Relationships &\nBoundaries',
        intent: 'relationships',
        microtags: ['Communication', 'Reliability', 'Boundaries', 'Presence'],
      ),
      OptionItem(
        icon: '🌱',
        title: 'Self-Worth &\nGrowth',
        intent: 'self-worth',
        microtags: ['Confidence', 'Habits', 'Reflection', 'Self-Care'],
      ),
    ],
  ),

  OnboardingStep(
    question: "Why is keeping your promises important to you now?",
    description: 'Choose two that fit you best',
    maxSelection: 2,
    minSelection: 2,
    isGrid: false,
    options: [
      OptionItem(icon: "", title: "I'm tired of falling short on my promises"),
      OptionItem(icon: "", title: "I've been stuck in the same cycles"),
      OptionItem(icon: "", title: "I want to prove I can follow through"),
      OptionItem(icon: "", title: "I want to become more consistent"),
      OptionItem(icon: "", title: "I want to feel proud again"),
      OptionItem(icon: "", title: "I want my actions to match my words"),
    ],
  ),

  OnboardingStep(
    question: "Who do you want to keep promises for the most?",
    description: 'Choose up to 3 that will keep you going',
    maxSelection: 3,
    isGrid: false,
    options: [
      OptionItem(icon: "👤", title: "Myself"),
      OptionItem(icon: "❤️", title: "My Partner"),
      OptionItem(icon: "👶", title: "My Kids"),
      OptionItem(icon: "👵", title: "My Parents"),
      OptionItem(icon: "🐈", title: "My Pets"),
      OptionItem(icon: "🧑‍🤝‍🧑", title: "My Friends"),
      OptionItem(icon: "👥", title: "My community or team"),
      OptionItem(icon: "🧭", title: "My future self"),
      OptionItem(icon: "👀", title: "People who don't believe in me"),
      OptionItem(icon: "🌀", title: "Someone or Something else"),
    ],
  ),

  OnboardingStep(
    question: "What often gets in your way of keeping promises?",
    description: "Choose two that feel real to you",
    maxSelection: 2,
    minSelection: 2,
    isGrid: false,
    options: [
      OptionItem(icon: "", title: "I get distracted or lose focus"),
      OptionItem(icon: "", title: "I avoid discomfort"),
      OptionItem(icon: "", title: "I start strong but don't finish"),
      OptionItem(icon: "", title: "I don't plan my time well"),
      OptionItem(icon: "", title: "I forget my 'why'"),
      OptionItem(icon: "", title: "I put others before myself"),
      OptionItem(icon: "", title: "I sometimes doubt I can change"),
    ],
  ),

  OnboardingStep(
    question: "Which of these might help you the most?",
    description: "Choose two that speak to you",
    maxSelection: 2,
    minSelection: 2,
    isGrid: false,
    options: [
      OptionItem(icon: "🥰", title: "Gentle encouragement"),
      OptionItem(icon: "💪", title: "Tough love — I need real talk"),
      OptionItem(icon: "🔥", title: "Progress tracking and streaks"),
      OptionItem(icon: "✍️", title: "Reflection and journaling"),
      OptionItem(icon: "✅", title: "Accountability from others"),
    ],
  ),
  // OnboardingStep(
  //   question: "Last step: confirm your preferences",
  //   description: "You’re almost done, just finalize your selections.",
  //   maxSelection: 0,
  //   isGrid: false, // or true depending on layout
  //   options: [OptionItem(title: "Confirm", icon: "✅")],
  // ),
];
