"use client";

/**
 * 0–9, wrapped with a 9 above and a 0 below. The easing deliberately overshoots
 * before settling, and without these guard digits an overshoot at either end would
 * expose blank space above the 0 or below the 9. With them, it rolls past a real
 * digit and comes back — which is what an odometer does.
 */
const DIGITS = [9, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
const OFFSET_PER_DIGIT = 100 / DIGITS.length;

/**
 * The web read of the app's `.contentTransition(.numericText())`.
 *
 * Each digit is a column holding 0–9 that slides to show the right one, so a 3→5
 * rolls *through* 4 the way an odometer does. It's a CSS transition rather than a
 * keyframe animation on purpose: dragging the slider fires updates faster than any
 * animation can finish, and a transition retargets smoothly from wherever it is,
 * where a restarting keyframe stutters.
 *
 * Columns are keyed by place value (distance from the right), so when the number
 * grows a digit — 9 → 10 — the existing digits keep their columns and only the new
 * leading one appears, instead of every digit rewriting itself one place over.
 */
export function RollingNumber({
  value,
  className = "",
}: {
  value: string;
  className?: string;
}) {
  const chars = value.split("");

  return (
    <>
      {/* The columns spell out 0123456789 to a screen reader, so give it the real value. */}
      <span className="sr-only">{value}</span>

      <span aria-hidden className={`roll ${className}`}>
        {/*
          A digit column clips its overflow, and CSS derives a clipped box's baseline
          from its bottom edge rather than from the glyph — so a number starting with
          a digit would sit above the surrounding text. This zero-width character is
          not clipped, and being first, it donates its real text baseline to the row.
        */}
        <span className="roll-static">&#8203;</span>

        {chars.map((char, index) => {
          const place = chars.length - 1 - index;
          return /\d/.test(char) ? (
            <span key={place} className="roll-col">
              <span
                className="roll-track"
                style={{
                  transform: `translateY(${
                    -(Number(char) + 1) * OFFSET_PER_DIGIT
                  }%)`,
                }}
              >
                {DIGITS.map((digit, slot) => (
                  <span key={slot} className="roll-digit">
                    {digit}
                  </span>
                ))}
              </span>
            </span>
          ) : (
            <span key={`sep-${place}`} className="roll-static">
              {char}
            </span>
          );
        })}
      </span>
    </>
  );
}
