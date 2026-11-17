# Changelog

All notable changes to `@westline/style-selector` are documented here.
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1] - 2026-11-17

### Changed
- Published from GitHub Actions with npm trusted publishing (OIDC) and provenance; no long-lived npm token.
- README: notes on the preflight check and pre-push hook.

No API changes.

## [0.2.0] - 2026-05-12

### Changed (breaking)
- Package renamed from `@westline/style-preview` to `@westline/style-selector`
- Component renamed: `StylePreview` → `StyleSelector`
- Hook renamed: `useStylePreview` → `useStyleSelector` (return type `UseStylePreviewReturn` → `UseStyleSelectorReturn`)
- Env gate renamed: `NEXT_PUBLIC_ENABLE_STYLE_PREVIEW` → `NEXT_PUBLIC_ENABLE_STYLE_SELECTOR`
- Internal dev-warning log prefix renamed: `[style-preview]` → `[style-selector]`
- Repo moved to `github.com/westline-marketing/westline-style-selector`

### Migration
1. `npm uninstall @westline/style-preview && npm install @westline/style-selector`
2. Update imports: `StylePreview` → `StyleSelector`, `useStylePreview` → `useStyleSelector`
3. Rename the env var in `.env.local` (and Vercel/Railway): `NEXT_PUBLIC_ENABLE_STYLE_PREVIEW` → `NEXT_PUBLIC_ENABLE_STYLE_SELECTOR` (build-time, requires rebuild)
4. The recommended consumer folder convention is now `src/style-selector/` (was `src/preview-styles/`). Renaming is optional — only the import paths in your layout need to match wherever you keep `config.ts`.

No runtime behavior changed; this release is a rename only.

## [0.1.4] - 2026-04-22

### Fixed
- Preset card descriptions were clipped on mobile when the drawer list couldn't fit every card at natural height. Cards now carry `flex-shrink: 0` so the flex algorithm can't squash them — the parent list scrolls instead, and long descriptions stay readable.

## [0.1.3] - 2026-04-20

### Changed
- Default trigger position moved to 15% of viewport height on first load. Stored positions from prior drags are unaffected.

## [0.1.2] - 2026-04-20

### Changed
- Default trigger position moved from 50% to 25% of viewport height (top quarter) on first load. Stored positions from prior drags are unaffected.

## [0.1.1] - 2026-04-18

### Changed
- Docs: README, GUIDE, and CLAUDE.md updated to reflect public npm distribution (no `NPM_TOKEN` or `.npmrc` required)

## [0.1.0] - 2026-04-18

Initial public release.

### Added
- Core theming engine with CSS custom property overrides on a themed wrapper class
- `StyleSelector` client component with draggable edge trigger and drawer UI
- `PrepaintScript` server-safe component to apply saved preview state before hydration
- Auto-derived drawer chrome from preset swatches (`drawerTheme: 'auto'`)
- Built-in drawer themes: `studio`, `techie`, `rustic`
- `?previewDrawer=` dev-mode override for theme preview
- `validatePreset` and `findPreset` utilities
- Full keyboard navigation and `prefers-reduced-motion` support
- Contrast-safe accent foregrounds on CTA buttons
- `NEXT_PUBLIC_ENABLE_STYLE_SELECTOR=true` env gate for Next.js consumers
