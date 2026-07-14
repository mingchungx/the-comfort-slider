import Image from "next/image";

const shots = [
  { src: "/screenshot_1.png", alt: "The Comfort Slider showing a comfortable purchase" },
  { src: "/screenshot_2.png", alt: "The Comfort Slider financing controls" },
  { src: "/screenshot_3.png", alt: "The Comfort Slider showing an unhinged purchase" },
];

const features = [
  {
    title: "Price anything",
    body: "A car, a couch, a ring, a jet ski you have no business owning. If it has a number on it, it goes in the box.",
  },
  {
    title: "Real financing",
    body: "Down payment, APR, term, and optional sales tax. See the monthly payment and the total interest you'll actually pay.",
  },
  {
    title: "Or flip it around",
    body: "Set your salary and the slider snaps to where the purchase actually lands for you. Comfortable, or clown emoji.",
  },
];

export function Showcase() {
  return (
    <section id="how" className="mx-auto w-full max-w-6xl px-6 py-20 md:py-28">
      <h2 className="text-balance text-center font-display text-4xl italic leading-tight sm:text-5xl">
        Drag it and find out.
      </h2>
      <p className="mx-auto mt-5 max-w-lg text-pretty text-center text-base text-subtle">
        The slider runs from Comfortable to Unhinged. Everything recalculates as you
        drag — the payment, the interest, and the salary that purchase quietly
        assumes you make.
      </p>

      <div className="mt-16 grid items-start gap-8 sm:grid-cols-3">
        {shots.map((shot, index) => (
          <div
            key={shot.src}
            className={`overflow-hidden rounded-[var(--radius-card)] leading-none shadow-2xl shadow-ink/15 transition duration-500 hover:-translate-y-1.5 ${
              index === 1 ? "sm:mt-10" : ""
            }`}
          >
            <Image
              src={shot.src}
              alt={shot.alt}
              width={1284}
              height={2778}
              className="h-auto w-full"
              priority={index === 0}
            />
          </div>
        ))}
      </div>

      <div className="mt-24 grid gap-6 md:grid-cols-3">
        {features.map((feature) => (
          <div
            key={feature.title}
            className="glass rounded-[var(--radius-card)] p-7"
          >
            <h3 className="font-display text-2xl italic">{feature.title}</h3>
            <p className="mt-3 text-sm leading-relaxed text-subtle">{feature.body}</p>
          </div>
        ))}
      </div>
    </section>
  );
}
