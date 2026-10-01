# @westline/style-selector

Reusable style selector engine for Westline client sites. Install it into separate site repos, keep each site's `style-selector` config and presets local, and enable it only in staging or preview environments.

## When to use

- A client needs to compare 3-5 design directions on a real site
- The site already uses CSS custom properties for theme tokens
- You want a reusable picker engine without copying source between repos

## Features

- **Draggable trigger** — edge tab can be repositioned vertically; position persists in localStorage
- **Accent bar indicator** — active preset card shows a colored left-edge bar
- **Dynamic border-radius** — drawer and card radii scale from `theme.borderRadius`
- **Contrast-safe accent foregrounds** — CTA button text adapts automatically for light/dark accent colors
- **Keyboard accessible** — trigger responds to Enter/Space, not just pointer events
- **prefers-reduced-motion** — all animations respect the user's OS motion preference

## Install

```bash
npm install @westline/style-selector
```

Published publicly on npm. No authentication required for install — works on local machines, Vercel, Railway, and any other CI without additional configuration.

## Quick Start

1. Create local presets in `src/style-selector/presets/*`
2. Create local config in `src/style-selector/config.ts` (use `instanceId`, not `storageKey`, for new sites)
3. Mount `PrepaintScript` from `@westline/style-selector`
4. Mount `StyleSelector` from `@westline/style-selector/client`
5. Set `NEXT_PUBLIC_ENABLE_STYLE_SELECTOR=true` only in staging/preview

That env var is a build-time flag. Changing it requires a rebuild/redeploy in the consuming app — it is not a runtime toggle. Non-Next consumers can pass `enabled={yourFlag}` on both components instead of relying on the env fallback.

## Package API

Server-safe root entry:

```ts
import {
  DEFAULT_UI_THEME,
  DRAWER_THEMES,
  PrepaintScript,
  deriveDrawerTheme,
  findPreset,
  lerpHex,
  parseHex,
  resolveDrawerTheme,
  parsePreviewDrawerParam,
  validatePreset,
  type PreviewConfig,
  type PreviewUITheme,
  type StylePreset,
  type DrawerThemeName,
} from '@westline/style-selector'
```

Client entry:

```ts
import { StyleSelector, useStyleSelector, buildPreviewUrl } from '@westline/style-selector/client'
```

Both `PrepaintScript` and `StyleSelector` accept an optional `enabled?: boolean` prop. When omitted, they fall back to `process.env.NEXT_PUBLIC_ENABLE_STYLE_SELECTOR === 'true'`.

The `StyleSelector` trigger is keyboard accessible (Enter/Space) and draggable — users can reposition it vertically, with the position persisted across sessions. All transitions respect `prefers-reduced-motion`.

## Consumer Repo Shape

```text
site-repo/
  package.json
  .npmrc
  .env.local
  src/
    app/
      layout.tsx
    style-selector/
      config.ts
      presets/
        storefront.ts
```

## Local Debugging

Use the package artifact, not a live link:

```bash
# package repo
npm run build
npm pack
# produces westline-style-selector-<version>.tgz in the package repo root

# consumer repo
npm i ../path-to-style-selector/westline-style-selector-<version>.tgz
```

Substitute the actual version from `package.json` for `<version>`. When finished testing, switch the consumer back to the published version.

## Checks

`npm run preflight` runs whitespace, typecheck, tests and the build in seconds; a pre-push hook runs it (`npm install` sets the hook up).

## Full Guide

See [GUIDE.md](./GUIDE.md) for install, layout wiring, env setup, and deployment notes for separate repos on Vercel and Railway.

## Architecture

```text
src/
├── index.ts      <- server-safe root exports
├── client.ts     <- client entrypoint for StyleSelector + useStyleSelector
├── types/        <- StylePreset, PreviewConfig, PreviewUITheme, DrawerThemeName
├── themes/       <- built-in drawer themes, auto derivation, and resolver
├── core/         <- persistence, theme application, prepaint, validation
└── react/        <- UI components and runtime hooks
```

## Status

Package source of truth for the shared picker engine. Site-specific presets, selectors, token allowlists, and UI overrides stay local to each consuming repo.
