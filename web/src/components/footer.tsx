import Link from "next/link";
import { site } from "@/lib/site";

export function Footer() {
  return (
    <footer className="border-t border-ink/10">
      <div className="mx-auto w-full max-w-6xl px-6 py-16">
        <div className="flex flex-col gap-10 sm:flex-row sm:justify-between">
          <div className="max-w-xs">
            <p className="font-display text-2xl italic">{site.name}</p>
            <p className="mt-3 text-sm text-subtle">
              What salary does that need?
            </p>
          </div>

          <div className="grid grid-cols-2 gap-10 text-sm sm:grid-cols-3">
            <div>
              <p className="font-medium">Support</p>
              <ul className="mt-3 space-y-2 text-subtle">
                <li>
                  <a
                    href={`mailto:${site.email}`}
                    className="transition hover:text-ink"
                  >
                    {site.email}
                  </a>
                </li>
              </ul>
            </div>

            <div>
              <p className="font-medium">Legal</p>
              <ul className="mt-3 space-y-2 text-subtle">
                <li>
                  <Link href="/privacy" className="transition hover:text-ink">
                    Privacy Policy
                  </Link>
                </li>
                <li>
                  <Link href="/terms" className="transition hover:text-ink">
                    Terms of Use
                  </Link>
                </li>
              </ul>
            </div>

            <div>
              <p className="font-medium">More</p>
              <ul className="mt-3 space-y-2 text-subtle">
                <li>
                  <a
                    href={site.company.url}
                    target="_blank"
                    rel="noreferrer"
                    className="transition hover:text-ink"
                  >
                    {site.company.name}
                  </a>
                </li>
              </ul>
            </div>
          </div>
        </div>

        <div className="mt-14 flex flex-col gap-3 border-t border-ink/10 pt-6 text-xs text-subtle sm:flex-row sm:items-center sm:justify-between">
          <p>
            © {new Date().getFullYear()} EclipseCard, Inc. All rights reserved.
          </p>
          <p>
            For entertainment. Not financial advice.
          </p>
        </div>
      </div>
    </footer>
  );
}
