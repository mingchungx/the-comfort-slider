import type { Metadata } from "next";
import { LegalPage } from "@/components/legal-page";
import { site } from "@/lib/site";

export const metadata: Metadata = {
  title: `Terms of Use — ${site.name}`,
  description:
    "The terms for using The Comfort Slider. It's a calculator with jokes, not financial advice.",
};

/*
  Section 4 (Not financial advice) and Section 11 (Apple as third-party
  beneficiary) are the two that matter most: the first is what keeps the App on
  the right side of the App Store's financial-services rules, and the second is
  required of any custom EULA. Do not remove them without legal review.
*/
export default function Terms() {
  return (
    <LegalPage
      title="Terms of Use"
      updated="July 14, 2026"
      summary="The Comfort Slider is a novelty calculator. It estimates what a purchase would cost you monthly and what salary that implies, and then it makes a joke about it. It is not financial advice, it is not an offer of credit, and its numbers are estimates — check anything that matters with your lender."
    >
      <h2>1. Agreement</h2>
      <p>
        These Terms of Use (the &ldquo;Terms&rdquo;) are an agreement between you
        and EclipseCard, Inc. (&ldquo;we,&rdquo; &ldquo;us,&rdquo;
        &ldquo;our&rdquo;) governing your use of The Comfort Slider mobile
        application (the &ldquo;App&rdquo;) and this website (the &ldquo;Site&rdquo;).
        By downloading or using the App, you agree to these Terms. If you do not
        agree, please do not use the App.
      </p>

      <h2>2. Licence</h2>
      <p>
        The App is free. We grant you a personal, non-exclusive, non-transferable,
        revocable licence to use the App on Apple-branded devices you own or
        control, as permitted by the App Store Terms of Service. You may not sell,
        rent, sublicense, or redistribute the App, and you may not reverse
        engineer, decompile, or disassemble it except to the extent that applicable
        law expressly permits despite this limitation.
      </p>

      <h2>3. What the App does</h2>
      <p>
        You enter a price and financing terms. The App applies a standard amortized
        payment formula to produce an estimated monthly payment and total interest,
        and it applies a debt-to-income ratio — the share of your income that
        payment would consume, which you choose with the comfort slider — to produce
        the annual salary that purchase would imply. It then displays a randomly
        selected humorous remark about your choice.
      </p>

      <h2>4. Not financial advice</h2>
      <p>
        <strong>
          This is the most important section of these Terms, and we would rather you
          read it than skip it.
        </strong>
      </p>
      <p>
        The App is provided for informational and entertainment purposes only. It is
        not financial, investment, lending, tax, accounting, or legal advice, and no
        fiduciary or advisory relationship is created by your use of it. We are not
        a bank, lender, credit broker, financial adviser, or financial institution,
        and we are not affiliated with any. The App does not offer, arrange, or
        advertise credit, and nothing it displays is an offer, a pre-approval, a
        quote, or a credit decision.
      </p>
      <p>
        The App&rsquo;s outputs are <strong>estimates</strong>. They are produced
        from the figures you type, using simplified and rounded models. Real
        financing involves things the App does not know and does not model —
        including your actual credit terms, lender fees, insurance, registration and
        closing costs, taxes beyond the sales tax you enter, variable rates,
        prepayment terms, and the rest of your financial life. Real numbers from a
        real lender will differ, sometimes substantially.
      </p>
      <p>
        The &ldquo;comfort&rdquo; framing — Comfortable, Stretching, Unhinged — is a
        rough rule of thumb about debt-to-income ratios, not a personalized
        assessment of what you can afford. Whether a purchase is wise for you depends
        on facts the App has never seen.
      </p>
      <p>
        <strong>
          Do not make a purchase, borrowing, or financial decision on the basis of
          this App.
        </strong>{" "}
        Talk to a qualified professional, and confirm any figure that matters with
        the lender who would actually be lending you the money. You are solely
        responsible for your financial decisions.
      </p>

      <h2>5. The jokes</h2>
      <p>
        The App responds to your inputs with pre-written comic remarks, selected at
        random. They are jokes. They are not directed at you personally, they are not
        a judgment of your character or your finances, and they are not a
        recommendation to do or not do anything. If a joke lands badly, we would
        genuinely like to hear about it:{" "}
        <a href={`mailto:${site.email}`}>{site.email}</a>.
      </p>

      <h2>6. Your responsibilities</h2>
      <ul>
        <li>Use the App lawfully, and for your own personal, non-commercial use.</li>
        <li>Do not misrepresent the App&rsquo;s output as professional advice, as a lender&rsquo;s quote, or as ours, to anyone else.</li>
        <li>Do not interfere with the App or attempt to derive its source code beyond what the law permits.</li>
      </ul>

      <h2>7. Privacy</h2>
      <p>
        The App collects no data. Everything you type stays on your device. Our{" "}
        <a href="/privacy">Privacy Policy</a> explains this in full, and it is part
        of these Terms.
      </p>

      <h2>8. Intellectual property</h2>
      <p>
        The App, the Site, and their content — including the name, design, code, and
        the roasts — are owned by us and protected by intellectual property laws.
        These Terms grant you a licence to use the App, not any ownership of it.
      </p>

      <h2>9. No warranty</h2>
      <p>
        To the fullest extent permitted by law, the App and the Site are provided{" "}
        <strong>&ldquo;as is&rdquo; and &ldquo;as available,&rdquo;</strong> without
        warranties of any kind, whether express, implied, or statutory — including
        any implied warranties of merchantability, fitness for a particular purpose,
        accuracy, and non-infringement. We do not warrant that the App&rsquo;s
        calculations are accurate, complete, or suitable for your circumstances, or
        that the App will be uninterrupted or error-free.
      </p>
      <p>
        Some jurisdictions do not allow the exclusion of implied warranties, so parts
        of this section may not apply to you. Nothing in these Terms limits any
        consumer rights you have that cannot be waived under the law of your
        country of residence.
      </p>

      <h2>10. Limitation of liability</h2>
      <p>
        To the fullest extent permitted by law, we will not be liable for any
        indirect, incidental, special, consequential, exemplary, or punitive damages,
        or for any loss of profits, savings, data, or goodwill, arising out of or
        relating to your use of — or inability to use — the App or the Site, even if
        we have been advised of the possibility of such damages.
      </p>
      <p>
        In particular, and without limiting the foregoing, we are not liable for any
        financial decision you make, or decline to make, in reliance on the App or
        anything it displays.
      </p>
      <p>
        The App is provided free of charge. To the fullest extent permitted by law,
        our total aggregate liability arising out of or relating to the App or these
        Terms will not exceed the greater of (a) the amount you paid us for the App,
        which is zero, and (b) CAD $50.
      </p>

      <h2>11. Apple</h2>
      <p>
        You acknowledge that these Terms are between you and us only, and not with
        Apple Inc. (&ldquo;Apple&rdquo;), and that Apple is not responsible for the
        App or its content. Apple has no obligation to furnish any maintenance or
        support for the App, and no warranty obligation whatsoever with respect to
        it; any claim that the App fails to conform to an applicable warranty may be
        directed to Apple, which will refund the purchase price (if any) — and, to
        the maximum extent permitted by law, Apple has no other warranty obligation
        regarding the App. Apple is not responsible for addressing any claim by you
        or a third party relating to the App, including product liability claims,
        claims that the App fails to conform to a legal or regulatory requirement,
        and claims arising under consumer protection or similar legislation. Apple
        and its subsidiaries are third-party beneficiaries of these Terms, and upon
        your acceptance, Apple will have the right (and will be deemed to have
        accepted the right) to enforce these Terms against you.
      </p>
      <p>
        You represent that you are not located in a country subject to a U.S.
        Government embargo or designated as a &ldquo;terrorist supporting&rdquo;
        country, and that you are not listed on any U.S. Government list of
        prohibited or restricted parties.
      </p>

      <h2>12. Changes</h2>
      <p>
        We may update the App or these Terms. If we make a material change to these
        Terms, we will revise the &ldquo;Last updated&rdquo; date and post the new
        version here. Continuing to use the App after a change means you accept the
        revised Terms; if you do not accept them, delete the App.
      </p>

      <h2>13. Termination</h2>
      <p>
        This licence lasts until terminated. It ends automatically if you breach
        these Terms, and you may end it at any time by deleting the App. Sections 4,
        8, 9, 10, 11, and 14 survive termination.
      </p>

      <h2>14. Governing law</h2>
      <p>
        These Terms are governed by the laws of the Province of Ontario and the
        federal laws of Canada applicable in it, without regard to conflict-of-laws
        rules, and the courts of Ontario will have exclusive jurisdiction — except
        that if you are a consumer, you keep the benefit of any mandatory protections
        and any right to bring proceedings in the courts of the country where you
        live.
      </p>

      <h2>15. Everything else</h2>
      <p>
        If any provision of these Terms is held unenforceable, the rest remains in
        force and the unenforceable provision is limited to the minimum extent
        necessary. Our failure to enforce a provision is not a waiver of it. These
        Terms, together with the <a href="/privacy">Privacy Policy</a>, are the
        entire agreement between you and us regarding the App.
      </p>

      <h2>16. Contact</h2>
      <p>
        Questions about these Terms:{" "}
        <a href={`mailto:${site.email}`}>{site.email}</a>.
      </p>
    </LegalPage>
  );
}
