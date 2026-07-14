/// Single source of truth for anything that appears in more than one place —
/// or that changes the day the app ships.
export const site = {
  name: "The Comfort Slider",
  tagline: "How much do you need to earn to comfortably, or uncomfortably, afford it?",
  description:
    "Enter any price and financing, and see the monthly payment, the interest, and the salary it takes. Then get roasted for it.",
  url: "https://the-comfort-slider.vercel.app",
  email: "info@eclipsecard.net",
  company: {
    name: "Eclipse",
    url: "https://eclipsecard.net",
  },
  /// Set this the day the app is approved; every CTA switches from
  /// "coming soon" to a live App Store link on its own.
  appStore: null as string | null,
} as const;
