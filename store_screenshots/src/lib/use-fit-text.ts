"use client";
import * as React from "react";

// Preserve explicit line breaks when a translation needs more room.
export function useFitText(value: unknown, style: React.CSSProperties | undefined, enabled: boolean) {
  const ref = React.useRef<HTMLDivElement>(null);
  const fontSize = style?.fontSize;
  const fontFamily = style?.fontFamily;
  const wordSpacing = style?.wordSpacing;
  const letterSpacing = style?.letterSpacing;
  React.useEffect(() => {
    if (!enabled) return;
    let cancelled = false;
    void document.fonts.ready.then(() => {
      const el = ref.current;
      if (!el || cancelled) return;
      el.style.fontSize = typeof fontSize === "number" ? `${fontSize}px` : fontSize || "";
      const computed = getComputedStyle(el);
      const size = parseFloat(computed.fontSize);
      const canvas = document.createElement("canvas").getContext("2d")!;
      canvas.font = `${computed.fontWeight} ${size}px ${computed.fontFamily}`;
      canvas.wordSpacing = computed.wordSpacing === "normal" ? "0px" : computed.wordSpacing;
      canvas.letterSpacing = computed.letterSpacing === "normal" ? "0px" : computed.letterSpacing;
      const width = Math.max(...el.innerText.split("\n").map(line => canvas.measureText(line).width));
      const padding = parseFloat(computed.paddingLeft) + parseFloat(computed.paddingRight);
      const parent = el.parentElement!;
      const parentStyle = getComputedStyle(parent);
      const available = parent.clientWidth - parseFloat(parentStyle.paddingLeft) - parseFloat(parentStyle.paddingRight);
      el.style.fontSize = `${size * Math.min(1, (available - 2) / Math.max(1, width + padding))}px`;
    });
    return () => { cancelled = true; };
  }, [value, fontSize, fontFamily, wordSpacing, letterSpacing, enabled]);
  return ref;
}
