import { ComfortHero } from "@/components/comfort-hero";
import { Showcase } from "@/components/showcase";
import { Footer } from "@/components/footer";
import { DownloadButton } from "@/components/download-button";

export default function Home() {
  return (
    <>
      <div className="shader-bg flex-1">
        <ComfortHero />
        <Showcase />

        <section className="mx-auto w-full max-w-3xl px-6 pb-28 text-center">
          <div className="glass rounded-[var(--radius-card)] px-8 py-14">
            <h2 className="text-balance font-display text-4xl italic leading-tight sm:text-5xl">
              Go on. Look it up.
            </h2>
            <p className="mx-auto mt-5 max-w-md text-pretty text-base text-subtle">
              Free. No account, no ads, and no judgement. Nothing you type ever leaves your phone.
            </p>
            <div className="mt-9 flex justify-center">
              <DownloadButton />
            </div>
          </div>
        </section>
      </div>

      <Footer />
    </>
  );
}
