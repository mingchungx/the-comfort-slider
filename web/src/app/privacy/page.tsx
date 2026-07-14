import type { Metadata } from "next";
import { LegalPage } from "@/components/legal-page";
import { site } from "@/lib/site";

export const metadata: Metadata = {
  title: `Privacy Policy — ${site.name}`,
  description:
    "The Comfort Slider collects no data. Everything you type stays on your device.",
};

/*
  Every factual claim below is verifiable against the source: the app makes no
  network requests, has no analytics or advertising SDKs, and stores preferences
  only in on-device UserDefaults. If that ever stops being true, this page must
  change in the same commit.
*/
export default function Privacy() {
  return (
    <LegalPage
      title="Privacy Policy"
      updated="July 14, 2026"
      summary="The Comfort Slider does not collect your data. There is no account to create, no analytics, no advertising, and no tracking of any kind. The app makes no network requests at all — the prices, salaries, and settings you enter never leave your device."
    >
      <h2>1. Who we are</h2>
      <p>
        The Comfort Slider (the &ldquo;App&rdquo;) is published by EclipseCard,
        Inc. (&ldquo;we,&rdquo; &ldquo;us,&rdquo; &ldquo;our&rdquo;). This policy
        explains what happens to information when you use the App or visit this
        website (the &ldquo;Site&rdquo;). You can reach us any time at{" "}
        <a href={`mailto:${site.email}`}>{site.email}</a>.
      </p>

      <h2>2. The short version</h2>
      <p>
        <strong>We do not collect, store, transmit, sell, or share any personal
        information through the App.</strong> We could not do so even if we wanted
        to: the App has no server, no account system, and no networking code. Our
        Apple App Store privacy label accordingly declares{" "}
        <strong>&ldquo;Data Not Collected.&rdquo;</strong>
      </p>

      <h2>3. Information in the App</h2>

      <h3>What you enter</h3>
      <p>
        The App works with information you type: a purchase price, financing terms
        (down payment, APR, term length, sales tax), and — if you choose to set one
        — a default salary. This information is used solely to perform a
        calculation on your device and display the result to you.
      </p>

      <h3>Where it lives</h3>
      <p>
        Your settings (default salary, default APR, default sales tax, currency
        preference) are saved locally on your device using Apple&rsquo;s standard
        on-device preferences storage, so the App remembers them the next time you
        open it. The price you type is not saved at all. None of this information
        is transmitted anywhere, and we have no ability to read it.
      </p>

      <h3>How to delete it</h3>
      <p>
        Deleting the App from your device deletes everything it has stored. There
        is nothing on our side to request, export, or erase, because we never
        received it.
      </p>

      <h3>What the App does not do</h3>
      <ul>
        <li>No account, sign-in, email address, or phone number is required or requested.</li>
        <li>No analytics, telemetry, crash reporting, or usage measurement SDKs.</li>
        <li>No advertising, ad identifiers (IDFA), or App Tracking Transparency prompts — we do not track you across apps or websites.</li>
        <li>No location, contacts, photos, camera, microphone, or health data access.</li>
        <li>No cookies, fingerprinting, or device identifiers collected by us.</li>
        <li>No data sold or shared with data brokers. Ever.</li>
      </ul>
      <p>
        The App contains no third-party code that collects, receives, or transmits
        information about you.
      </p>

      <h2>4. Information on this website</h2>
      <p>
        The Site is a static page. We do not set cookies, run analytics, or embed
        trackers or social widgets, and web fonts are served from our own domain
        rather than a third party, so visiting this page does not report your visit
        to anyone else.
      </p>
      <p>
        Like nearly all websites, the Site is delivered by a hosting provider whose
        servers automatically create ordinary technical logs — typically your IP
        address, browser type, and the pages requested — for the limited purposes
        of serving the page, keeping it available, and preventing abuse. We do not
        use those logs to identify you or build a profile, and we do not combine
        them with anything else. Where the GDPR applies, our legal basis for this
        processing is our legitimate interest in operating and securing the Site.
      </p>

      <h2>5. If you email us</h2>
      <p>
        If you contact us at <a href={`mailto:${site.email}`}>{site.email}</a>, we
        will receive your email address and whatever you choose to write, and we
        will keep the message for as long as needed to answer you and to keep a
        record of the support we have provided. We use it for that purpose only. Ask
        us to delete the correspondence and we will.
      </p>

      <h2>6. Children</h2>
      <p>
        The App is rated 4+ and is safe for all ages, but it is not directed at
        children, and it collects no information from anyone — including children
        under 13 (or under 16 in the EEA/UK). We have no personal information about
        a child to disclose or delete.
      </p>

      <h2>7. Your rights</h2>
      <p>
        Privacy laws including the GDPR (EU/UK), PIPEDA (Canada), and the CCPA/CPRA
        (California) give you rights to access, correct, delete, and port your
        personal information, and to object to or restrict its processing.{" "}
        <strong>
          For App users, these rights have nothing to act on: we hold no personal
          information about you.
        </strong>{" "}
        We do not sell or share personal information as those terms are defined
        under California law, and we have never done so.
      </p>
      <p>
        If you have emailed us, you can exercise any of these rights over that
        correspondence by writing to{" "}
        <a href={`mailto:${site.email}`}>{site.email}</a>. We will respond within
        the time your law requires — 30 days in most cases — and we will not
        discriminate against you for making a request.
      </p>

      <h2>8. Security</h2>
      <p>
        The most effective security measure available is not to hold data in the
        first place, and that is the design of this App. Information you enter
        remains on your device, protected by your device&rsquo;s own encryption and
        passcode.
      </p>

      <h2>9. Changes to this policy</h2>
      <p>
        If the App ever changes in a way that affects this policy — for example, if
        a future version adds a feature that requires a network connection — we will
        update this page and revise the &ldquo;Last updated&rdquo; date before that
        version ships, and we will describe the change plainly rather than quietly
        broadening it.
      </p>

      <h2>10. Contact</h2>
      <p>
        Questions about this policy, or about privacy generally, go to{" "}
        <a href={`mailto:${site.email}`}>{site.email}</a>. A person reads that
        inbox.
      </p>
    </LegalPage>
  );
}
