import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // A landing page and a privacy policy — there is nothing to run on a server.
  // `next build` emits a plain HTML/CSS/JS bundle to `out/`, hostable anywhere.
  output: "export",
  // Static exports have no image optimization server.
  images: { unoptimized: true },
};

export default nextConfig;
