/**
 * A faithful port of the app's ComfortScale + AffordabilityCalculator, so the
 * numbers the hero slider shows are the numbers the app would show. If the Swift
 * changes, change this with it.
 */

export type Zone = "comfortable" | "stretching" | "unhinged";

const MIDPOINT = 0.5;
const MIDPOINT_DTI = 0.2;
const STRETCHING_DTI = 0.15;
const UNHINGED_DTI = 0.4;

/**
 * Maps the 0–100 slider onto a debt-to-income fraction with the app's deliberate
 * non-linear stretch: the first half spans a sensible 0–20% of income, the second
 * half ramps through the reckless 20–100%. Snapped to whole percentage points so
 * the number shown and the number used are always the same.
 */
export function dtiFraction(sliderValue: number): number {
  const position = Math.min(Math.max(sliderValue / 100, 0), 1);
  const raw =
    position <= MIDPOINT
      ? (position / MIDPOINT) * MIDPOINT_DTI
      : MIDPOINT_DTI +
        ((position - MIDPOINT) / (1 - MIDPOINT)) * (1 - MIDPOINT_DTI);
  return Math.round(raw * 100) / 100;
}

export function zoneFor(dti: number): Zone {
  if (dti < STRETCHING_DTI) return "comfortable";
  if (dti < UNHINGED_DTI) return "stretching";
  return "unhinged";
}

/**
 * Zone palette and copy, mirroring ComfortZone in the app.
 *
 * The colours are literal values on purpose. Building a variable name at runtime
 * (`var(--color-${zone})`) does not work: Tailwind only emits theme variables it
 * can see used in the source, so a name assembled at runtime gets pruned, the
 * `var()` fails to resolve, and any declaration using it is dropped entirely.
 */
export const zoneMeta: Record<
  Zone,
  {
    title: string;
    subtitle: string;
    emoji: string;
    particle: string;
    color: string;
    washes: [string, string, string];
  }
> = {
  comfortable: {
    title: "Comfortable",
    subtitle: "Barely feels it",
    emoji: "😌",
    particle: "💵",
    color: "oklch(0.65 0.16 152)",
    washes: ["oklch(0.88 0.09 155)", "oklch(0.93 0.05 150)", "oklch(0.96 0.03 95)"],
  },
  stretching: {
    title: "Stretching",
    subtitle: "Feels the squeeze",
    emoji: "😬",
    particle: "💸",
    color: "oklch(0.68 0.15 62)",
    washes: ["oklch(0.87 0.1 75)", "oklch(0.92 0.06 80)", "oklch(0.96 0.03 90)"],
  },
  unhinged: {
    title: "Unhinged",
    subtitle: "Sending it",
    emoji: "🤡",
    particle: "🤑",
    color: "oklch(0.58 0.2 27)",
    washes: ["oklch(0.78 0.13 32)", "oklch(0.88 0.08 30)", "oklch(0.95 0.04 45)"],
  },
};

/** Standard amortized payment. Falls back to straight division at 0% APR. */
export function monthlyPayment(
  principal: number,
  annualRatePercent: number,
  months: number,
): number {
  const count = Math.max(months, 1);
  const rate = annualRatePercent / 100 / 12;
  if (rate <= 0) return principal / count;
  const growth = Math.pow(1 + rate, count);
  return (principal * rate * growth) / (growth - 1);
}

export type Affordability = {
  monthly: number;
  /** null when the comfort level implies 0% of income — no finite salary works. */
  requiredAnnualIncome: number | null;
  totalInterest: number;
  dti: number;
  zone: Zone;
};

export function affordability(
  price: number,
  annualRatePercent: number,
  months: number,
  sliderValue: number,
): Affordability {
  const dti = dtiFraction(sliderValue);
  const monthly = monthlyPayment(price, annualRatePercent, months);
  return {
    monthly,
    requiredAnnualIncome: dti > 0 ? (monthly / dti) * 12 : null,
    totalInterest: Math.max(0, monthly * months - price),
    dti,
    zone: zoneFor(dti),
  };
}

export const usd = (value: number) =>
  value.toLocaleString("en-US", {
    style: "currency",
    currency: "USD",
    maximumFractionDigits: 0,
  });
