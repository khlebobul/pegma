# Pegma store screenshots

Local editor based on the app-store-screenshots template and knights_graph example.
Uses Pegma's own font, light/dark colors and lavender move highlights.
Six slides × six UI languages: en, ru, es, it, fr, de. iPhone, iPad and Android phone decks.
Isolated mode keeps each game and its caption readable independently.

## Editor

```sh
cd store_screenshots
rtk proxy npm install --cache /tmp/pegma-npm-cache
rtk proxy npm run dev
```

Open http://localhost:3020. Reorder slides, edit localized text and move/resize devices.
Autosave: `app-store-screenshots.json`; Reset restores `src/lib/initial-project.json`.
**Export bundle** downloads PNGs at every editor size and locale for the active device.
Preview: `/preview?device=iphone&locale=ru&h=640` (also ipad / android).
Apple creatives: `/creative?kind=header&locale=ru` and `/creative?kind=search&locale=ru`.
Android Feature Graphic: select **Feature Graphic** in the editor, or open
`/preview?device=feature-graphic&locale=ru&h=500`. Uses a real Android game screen.

## Real UI captures

From Flutter app root on macOS:

```sh
rtk proxy flutter test test/store_screenshots/capture_test.dart
```

Capture tests carry the `store-screenshots` tag. Linux CI runs
`flutter test --coverage --exclude-tags store-screenshots` because capture uses
macOS system fonts and generates local images.

Production game, level list and tutorial widgets rendered offline. Legal moves run
through the real game provider. Mock preferences and database reads never use personal
saves. Flutter assertions check legal moves, loaded boards and layout errors.
The app font is loaded explicitly; macOS Arial supplies missing native fallback glyphs.
Source dimensions: iPhone 1320×2868, iPad 2064×2752, Android phone 1080×2340.
Captures are widget renders, without OS status bar text, rather than simulator screenshots.

## PNGs, ZIPs and contact sheets

Requires Python Playwright, Pillow and installed Google Chrome. With server running:

```sh
rtk proxy python3 scripts/export-pngs.py
```

Use `BASE` / `CHROME` to override server URL / Chrome executable.
Filters: `--device android`, `--locales ru de`, `--creatives-only`.

- iPhone: 1320×2868, 1284×2778, 1206×2622, 1125×2436.
- iPad: 2064×2752, 2048×2732.
- Android phone: 1080×1920.
- Android Feature Graphic: 1024×500, six languages, `export/android/feature-graphic/1024x500/<language>/01.png`.
- Apple Header: 3840×1646. Search Results: 3840×2560.
- Full export: 270 RGB PNGs, per-language ZIPs and `export/pegma-all-localized.zip`.
- Contact sheets: `export/preview.jpg`, `preview-ipad.jpg`, `preview-android.jpg`,
  `preview-locales.jpg`, `preview-apple-header.jpg`, `preview-apple-search-results.jpg`.

Exporter checks dimensions, RGB, nonblank images, text bounds and overlap.
Smaller Apple sizes retain composition with less than 0.5% edge cropping.
Screenshots, all image assets, ZIPs, metadata and reports are ignored by Git;
code, scripts, settings and documentation may be tracked.
Restore fonts, icon and device mockup after a fresh checkout:
`rtk proxy python3 scripts/prepare-assets.py`. Then run the Flutter capture command.

Built with [app-store-screenshots](https://www.parthjadhav.com/products/app-store-screenshots).
See the showcase; tag **@parthjadhav8** on Twitter to share your app.

## Dependencies and checks

Stable releases with exact versions in package.json and package-lock.json.
Tailwind 4 uses [@tailwindcss/postcss](https://tailwindcss.com/docs/installation/using-postcss),
CSS theme variables and tailwind-merge 3. React uses stable 19, without RC releases.
Webpack mode keeps local file watching compatible with this macOS environment.

```sh
rtk proxy npm ci --cache /tmp/pegma-npm-cache
rtk proxy npm audit --include=dev
rtk proxy npm run build
```

From the app root: `rtk proxy flutter analyze` and
`rtk proxy flutter test test/store_screenshots/capture_test.dart`.
Local audit and QA reports live in `reports/` and stay out of Git.

Browser ZIP smoke check (with server running): `rtk proxy python3 scripts/check-editor.py`.
Feature Graphic check: `rtk proxy python3 scripts/check-editor.py --device feature-graphic`.
Run this separately from the full PNG exporter. It intercepts project persistence in its
isolated browser session, exports six Android PNGs, validates their dimensions and checks
for JS errors; the actual project file is never modified.
