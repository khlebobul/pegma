# Agent instructions

Keep responses concise and concrete. Preserve technical accuracy; omit filler.
Use `rtk` for shell commands when available; use `rtk proxy` for unsupported commands.
If `rtk` is unavailable, run commands directly.

For App Store Connect work, read [ASC.md](ASC.md). Use installed
`asc-cli-usage`, `asc-id-resolver`, and `asc-metadata-sync` skills for discovery,
read-only app lookup and canonical metadata. Use `asc-xcode-build`,
`asc-signing-setup`, `asc-release-flow`, `asc-testflight-orchestration` and
`asc-submission-health` only when the corresponding work is requested.

For store screenshots use `app-store-screenshots` and [editor instructions](store_screenshots/README.md).
Reuse the real Flutter screens, Pegma font, app colors and supported UI locales.
Use `asc-screenshot-resize` when Apple screenshot sizing needs repair.

Select `--profile minimo` explicitly; never change the global ASC profile.
Keep metadata, captures, screenshot images, archives, credentials and reports
local and ignored by Git. Preserve unrelated user changes.
The README preview at `screenshots/github.jpg` is the only public screenshot asset;
it may be tracked in Git. Store captures and exports remain local.
Local setup authorizes no upload, remote edit, version creation, review or publication.
