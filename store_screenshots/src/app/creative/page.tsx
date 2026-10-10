"use client";
// Apple store creatives: /creative?kind=header|search&locale=en
import * as React from "react";
import { Phone } from "@/components/editor/device-frames";
import { brandFont, pickText } from "@/lib/locale";
import { useFitText } from "@/lib/use-fit-text";
import type { ProjectState } from "@/lib/types";

function Copy({ text, locale, size, heading = false }: { text: string; locale: string; size: number; heading?: boolean }) {
  const style = { fontFamily: brandFont(locale, heading), fontSize: size, fontWeight: 700, wordSpacing: "0.18em" };
  const ref = useFitText(text, style, true);
  return <div ref={ref} data-placeholder="copy" style={{ ...style, whiteSpace: "pre-wrap", lineHeight: 1.15, color: heading ? "#202020" : "#663475" }}>{text}</div>;
}

export default function CreativePage() {
  const [state, setState] = React.useState<ProjectState | null>(null);
  const [params, setParams] = React.useState<URLSearchParams | null>(null);
  React.useEffect(() => {
    setParams(new URLSearchParams(window.location.search));
    fetch("/api/project").then(r => r.json()).then(data => setState(data.state));
  }, []);
  if (!state || !params) return null;
  const locale = params.get("locale") || "en";
  const header = params.get("kind") !== "search";
  const w = 3840, h = header ? 1646 : 2560;
  const hero = state.slidesByDevice.iphone[0];
  const screens = ["03-hints.png", "01-classic.png", "04-dark.png"];
  const pw = header ? 680 : 760;
  return (
    <div style={{ position: "relative", width: w, height: h, overflow: "hidden", backgroundColor: "#F1F1F1", backgroundImage: "linear-gradient(#20202008 2px, transparent 2px), linear-gradient(90deg, #20202008 2px, transparent 2px)", backgroundSize: "192px 192px" }}>
      <style>{"body{margin:0} nextjs-portal{display:none!important}"}</style>
      <div style={{ position: "absolute", left: header ? 240 : 360, top: header ? 320 : 150, width: header ? 1540 : 3120, textAlign: header ? "left" : "center", zIndex: 10 }}>
        <Copy text={state.appName} locale={locale} size={header ? 100 : 90} />
        <div style={{ marginTop: 30 }}><Copy text={pickText(hero.headline, locale)} locale={locale} size={header ? 190 : 220} heading /></div>
        <div style={{ marginTop: 55 }}><Copy text={pickText(hero.textElements?.[0]?.text, locale)} locale={locale} size={header ? 90 : 100} /></div>
      </div>
      {screens.map((screen, i) => (
        <div key={screen} data-phone style={{ position: "absolute", width: pw, left: header ? 1900 + i * 530 : 570 + i * 900, top: header ? (i === 1 ? 100 : 260) : (i === 1 ? 1040 : 1190), transform: `rotate(${i === 0 ? -7 : i === 2 ? 7 : 0}deg)`, zIndex: i === 1 ? 3 : 2, filter: "drop-shadow(0 25px 35px #20202028)" }}>
          <Phone src={`/screenshots/apple/iphone/${locale}/${screen}`} hideEmpty />
        </div>
      ))}
    </div>
  );
}
