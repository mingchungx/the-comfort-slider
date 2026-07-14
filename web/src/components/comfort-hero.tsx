"use client";

import { useEffect, useRef, useState } from "react";
import { affordability, usd, zoneMeta } from "@/lib/comfort";
import { DownloadButton } from "./download-button";
import { RollingNumber } from "./rolling-number";
import { site } from "@/lib/site";

const APR = 7.5;
const TERM_MONTHS = 60;

type Particle = { id: number; emoji: string; left: number; delay: number };

export function ComfortHero() {
  const [priceText, setPriceText] = useState("80,000");
  const [slider, setSlider] = useState(28);
  const [particles, setParticles] = useState<Particle[]>([]);
  const particleSeed = useRef(0);

  const price = Number(priceText.replace(/[^0-9]/g, "")) || 0;
  const { monthly, requiredAnnualIncome, dti, zone } = affordability(
    price,
    APR,
    TERM_MONTHS,
    slider,
  );
  const meta = zoneMeta[zone];

  // Retint the whole page, not just this card — the background and every
  // zone-tinted surface downstream read these variables.
  useEffect(() => {
    const root = document.documentElement.style;
    const [a, b, c] = meta.washes;
    root.setProperty("--zone", meta.color);
    root.setProperty("--wash-a", a);
    root.setProperty("--wash-b", b);
    root.setProperty("--wash-c", c);
  }, [meta]);

  // Money sprays when you cross a zone, exactly like the app does.
  useEffect(() => {
    const spawned = Array.from({ length: 5 }, () => ({
      id: particleSeed.current++,
      emoji: zoneMeta[zone].particle,
      left: 15 + Math.random() * 70,
      delay: Math.random() * 220,
    }));
    setParticles(spawned);
    const timer = window.setTimeout(() => setParticles([]), 1600);
    return () => window.clearTimeout(timer);
  }, [zone]);

  return (
    <section className="relative mx-auto grid w-full max-w-6xl items-center gap-14 px-6 pt-28 pb-20 md:grid-cols-[1.05fr_1fr] md:gap-10 md:pt-36 md:pb-28">
      <div className="text-center md:text-left">
        <p className="zone-text text-xs font-medium uppercase tracking-[0.2em]">
          The Comfort Slider
        </p>

        <h1 className="mt-6 text-balance text-4xl leading-[1.05] tracking-tight sm:text-5xl lg:text-6xl">
          How much do you need to earn to{" "}
          <em className="zone-text font-display italic">comfortably</em>, or{" "}
          <em className="font-display italic text-unhinged">uncomfortably</em>,
          afford it?
        </h1>

        <p className="mx-auto mt-7 max-w-md text-pretty text-base text-subtle md:mx-0">
          Put in a price. Set your financing. Drag the slider and watch the salary
          it would take move with it — then get roasted for what you were about to
          buy.
        </p>

        <div className="mt-9 flex flex-col items-center gap-4 sm:flex-row md:justify-start">
          <DownloadButton />
          <a
            href="#how"
            className="text-sm font-medium text-subtle transition hover:text-ink"
          >
            See how it works →
          </a>
        </div>
      </div>

      {/* The app, in miniature. The math is the app's math. */}
      <div className="relative mx-auto w-full max-w-md">
        <div className="glass rounded-[var(--radius-card)] p-7">
          <label
            htmlFor="price"
            className="text-xs font-medium uppercase tracking-[0.14em] text-subtle"
          >
            Total price
          </label>
          <div className="mt-2 flex items-baseline gap-2">
            <span className="text-2xl text-subtle">$</span>
            <input
              id="price"
              inputMode="numeric"
              value={priceText}
              onChange={(event) => {
                const digits = event.target.value.replace(/[^0-9]/g, "").slice(0, 9);
                setPriceText(digits ? Number(digits).toLocaleString("en-US") : "");
              }}
              placeholder="80,000"
              className="tabular w-full bg-transparent text-4xl font-semibold tracking-tight outline-none placeholder:text-ink/25"
            />
          </div>

          <hr className="my-6 border-ink/10" />

          <p className="text-xs font-medium uppercase tracking-[0.14em] text-subtle">
            How uncomfortable?
          </p>

          <div className="mt-4 text-center">
            <p className="zone-text font-display text-3xl italic">{meta.title}</p>
            <p className="mt-1 text-sm text-subtle">{meta.subtitle}</p>
          </div>

          <div className="mt-5 flex items-center gap-3">
            <span aria-hidden className="text-xl">
              😌
            </span>
            <input
              type="range"
              min={0}
              max={100}
              step={1}
              value={slider}
              onChange={(event) => setSlider(Number(event.target.value))}
              aria-label="Comfort level"
              className="zone-range h-1.5 w-full cursor-pointer appearance-none rounded-full"
              style={{
                background: `linear-gradient(to right, var(--zone) ${slider}%, color-mix(in oklch, var(--color-ink) 12%, transparent) ${slider}%)`,
              }}
            />
            <span aria-hidden className="text-xl">
              🤡
            </span>
          </div>

          <hr className="my-6 border-ink/10" />

          <div className="text-center">
            <p className="flex justify-center text-4xl font-semibold tracking-tight">
              {requiredAnnualIncome === null ? (
                "Not possible"
              ) : (
                <RollingNumber value={usd(requiredAnnualIncome)} />
              )}
            </p>
            <p className="mt-1.5 flex items-baseline justify-center text-sm text-subtle">
              <span>salary to afford it&nbsp;·&nbsp;</span>
              <RollingNumber value={`${Math.round(dti * 100)}%`} />
              <span>&nbsp;of income</span>
            </p>
            <p className="mt-4 flex items-baseline justify-center text-xl font-semibold">
              <RollingNumber value={usd(monthly)} />
              <span className="text-sm font-normal text-subtle">&nbsp;/ mo</span>
            </p>
            <p className="mt-1 text-xs text-subtle">
              5 yrs · {APR}% APR · in the app, all of this is yours to change
            </p>
          </div>
        </div>

        {/* Spray. Decorative only. */}
        <div
          aria-hidden
          className="pointer-events-none absolute inset-x-0 bottom-24 top-0 overflow-hidden"
        >
          {particles.map((particle) => (
            <span
              key={particle.id}
              className="spray absolute bottom-0 text-2xl"
              style={{
                left: `${particle.left}%`,
                animationDelay: `${particle.delay}ms`,
              }}
            >
              {particle.emoji}
            </span>
          ))}
        </div>
      </div>

      <p className="col-span-full text-center text-xs text-subtle/80 md:text-left">
        Built by{" "}
        <a
          href={site.company.url}
          target="_blank"
          rel="noreferrer"
          className="underline underline-offset-4 transition hover:text-ink"
        >
          {site.company.name}
        </a>
        .
      </p>
    </section>
  );
}
