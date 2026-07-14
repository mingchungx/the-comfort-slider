import Link from "next/link";
import { Footer } from "./footer";

/**
 * Shared chrome for the legal pages. Plain, readable, no glass — these documents
 * are meant to be read and, if it ever comes to it, cited.
 */
export function LegalPage({
  title,
  updated,
  summary,
  children,
}: {
  title: string;
  updated: string;
  summary: string;
  children: React.ReactNode;
}) {
  return (
    <>
      <div className="shader-bg flex-1">
        <div className="mx-auto w-full max-w-3xl px-6 pt-24 pb-24">
          <Link
            href="/"
            className="text-sm text-subtle transition hover:text-ink"
          >
            ← The Comfort Slider
          </Link>

          <h1 className="mt-8 font-display text-5xl italic leading-tight">
            {title}
          </h1>
          <p className="mt-4 text-sm text-subtle">Last updated: {updated}</p>

          <div className="glass mt-10 rounded-[var(--radius-card)] p-7">
            <p className="text-base leading-relaxed">{summary}</p>
          </div>

          <div className="legal mt-14">{children}</div>
        </div>
      </div>
      <Footer />
    </>
  );
}
