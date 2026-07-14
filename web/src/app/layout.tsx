import type { Metadata } from "next";
import { Inter, Instrument_Serif } from "next/font/google";
import { site } from "@/lib/site";
import "./globals.css";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  display: "swap",
});

const instrumentSerif = Instrument_Serif({
  variable: "--font-instrument-serif",
  subsets: ["latin"],
  weight: "400",
  style: ["normal", "italic"],
  display: "swap",
});

export const metadata: Metadata = {
  title: `${site.name} — What salary does that need?`,
  description: site.description,
  metadataBase: new URL(site.url),
  openGraph: {
    title: `${site.name} — What salary does that need?`,
    description: site.description,
    type: "website",
    images: ["/screenshot_1.png"],
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${inter.variable} ${instrumentSerif.variable} h-full antialiased`}
    >
      <body className="font-sans min-h-full flex flex-col">{children}</body>
    </html>
  );
}
