import type { Metadata } from "next";

import "./globals.css";



export const metadata: Metadata = {
  title: "Pegma — Store Screenshots",
  description: "Design and export App Store + Google Play screenshots.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body style={{ fontFamily: "Arial, sans-serif" }}>{children}</body>
    </html>
  );
}
