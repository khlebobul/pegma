# Pegma — App Store Connect

- Bundle ID / Android application ID: `com.khlebobul.pegma`.
- ASC app ID: `6754343848`, Pegma - Peg Solitaire. Verified by bundle ID.
- Auth: `minimo`, System Keychain. Always use `--profile minimo`; leave global settings untouched.
- Read current version/build from `pubspec.yaml`: prepared locally for `1.11.5+41`.
- Remote `1.11.5`: `80b871de-d4cb-49fe-9f0a-bbd664274819`, published (`READY_FOR_DISTRIBUTION`).
  No editable version was created. Recheck version state before any future remote work.
- Canonical local copy: `metadata/app-info/<locale>.json` and
  `metadata/version/1.11.5/<locale>.json`. Original ASC copy: `.asc/baseline/`.
- Prepared locales: en-US, ru, es-ES, it, fr-FR, de-DE, ja, ko, nl-NL, pl, pt-BR, tr, zh-Hans, zh-Hant.
  Polish version localization is a local draft; the other supplied fields already match the pulled copy.
  Polish subtitle follows the user's copy. Existing What's New text is preserved except
  Polish and Traditional Chinese drafts based on the dependency update in CHANGELOG.md.
- Preserved support / marketing URL: `https://pegma.vercel.app`.
  Preserved privacy URL: `https://pegma.vercel.app/privacy_policy`.
  Polish version URLs use the existing English URLs because no Polish version localization exists remotely.
- UI and screenshot languages: en, ru, es, it, fr, de.
  Mapping: en → en-US, es → es-ES, fr → fr-FR, de → de-DE; ru and it unchanged.
  Extra store locales do not imply extra interface languages.
- Readable prepared texts: `docs/store/store-content.md` (local, ignored).
- Editor: `store_screenshots/`, port 3020. Images and ZIPs remain local.
  iPhone / iPad PNGs: `store_screenshots/export/apple/<device>/<WxH>/<language>/NN.png`.
  Android: `store_screenshots/export/android/phone/1080x1920/<language>/NN.png`.
  Android Feature Graphic: `store_screenshots/export/android/feature-graphic/1024x500/<language>/01.png`.
  Apple Header / Search Results: `export/apple/{header,search-results}/<language>/01.png`,
  3840×1646 / 3840×2560. These are separate creative assets, not device screenshots.

Use installed `asc-*` skills listed in AGENTS.md; discover flags with `--help`.
Credentials stay in Keychain or outside the repository. Never print private keys.

## Local and read-only workflow

```sh
rtk proxy asc --read-only --profile minimo apps list --bundle-id com.khlebobul.pegma --output table
rtk proxy asc --read-only --profile minimo versions list --app 6754343848 --paginate --output table
rtk proxy asc --read-only --profile minimo metadata pull --app 6754343848 --version 1.11.5 --platform IOS --dir /tmp/pegma-metadata-baseline
rtk proxy asc --read-only --profile minimo metadata validate --dir ./metadata --output table
```

Pull into a fresh baseline directory to preserve local edits. Keep original locale-specific
URLs when updating copy. Merge into a fresh baseline before any future push so other
localizations survive; do not enable deletion. Validate before remote work.

Remote writes, uploads, version creation, review and publication require a separate
user request. This setup only reads ASC and prepares local files.
